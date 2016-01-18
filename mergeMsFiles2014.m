%%mergeMSFiles: merge all ms-file in a folder into a single as-file;
%%calculates 
%folderMSFile: Folder ms-file
%nameMSFile: Name of ms-file
%nameASFile: Name of as-file
%folderMSfile: Folder of as-file
%uses:
%output: as-files

function outFile = mergeMsFilesSuite(folderMSFile, nameMSFile, nameASFile, folderASFile)

%got to folderMSFile and find the ms-files
cd(folderMSFile);
msfilenames = dir(['H-*' nameMSFile '*_ms.mat']);
msfilenames = {msfilenames.name};

%sort the ms-files bei the part number
number = cell2mat(cellfun(@(x) str2double(x(end-9:end-7)),msfilenames,'UniformOutput',0));
[~, sortIndex] = sort(number);
msfilenames = msfilenames(sortIndex);

%load the file and merge them together
for cnt = 1:numel(msfilenames)
    fprintf('Merge Particle Statistik File: %04u / %04u\n',cnt, numel(msfilenames) );
    temp = load(msfilenames{cnt});
    temp = temp.outFile;
    
    %if ms-file is not empty
    if  isfield(temp, 'pStats') && sum(~isnan(temp.pStats.zPos))
        %for first non empty ms-file
        if ~exist('outFile','var')
            %ms file counter
            cntOutFile = 1;
            %create out file
            outFile = temp;            
            %copy all fields from ps-file without particle image
            outFile.folderPSFile = {outFile.folderPSFile} ;
            copyFields              = fieldnames(outFile.pStats);
            copyFields = copyFields(~strcmp(copyFields,'pImage'));
            outFile.pStats = rmfield(outFile.pStats, 'pImage');
            
            outFile.pStats.nHoloAll = outFile.pStats.nHolo;
        %for not first non empty ms-file
        else
            cntOutFile = cntOutFile + 1;
            
            outFile.ampMean = [outFile.ampMean temp.ampMean];
            outFile.ampSTD = [outFile.ampSTD temp.ampSTD];
            outFile.ampThresh = [outFile.ampThresh temp.ampThresh];
            outFile.valid_particles = [outFile.valid_particles temp.valid_particles];
            outFile.folderPSFile{cnt} = temp.folderPSFile;
            outFile.psFilenames = [outFile.psFilenames temp.psFilenames];
            outFile.emptyPsFile = [ outFile.emptyPsFile temp.emptyPsFile];
            outFile.dateNumHolo = [outFile.dateNumHolo temp.dateNumHolo];
            outFile.dateVecHolo = [outFile.dateVecHolo temp.dateVecHolo];           
            outFile.blackListInd = [outFile.blackListInd temp.blackListInd];
            outFile.realInd = [outFile.realInd temp.realInd];   

            for cnt2 = 1:numel(copyFields)
                if ~isfield(temp.pStats, copyFields{cnt2})
                    temp.pStats.(copyFields{cnt2}) = nan(1,numel(temp.pStats.zPos));
                end
                outFile.pStats.(copyFields{cnt2}) = [outFile.pStats.(copyFields{cnt2}) temp.pStats.(copyFields{cnt2})];
            end
            outFile.pStats.nHoloAll = [outFile.pStats.nHoloAll ...
                temp.pStats.nHolo+outFile.pStats.nHoloAll(end)];
        end
        clear temp
    end
end

%calculate whole sample statistics
if exist('outFile','var')    
    outFile.sample.Number      = outFile.pStats.nHoloAll(end);
    outFile.sample.VolumeAll   = outFile.sample.VolumeHolo * outFile.sample.Number;
       
  
    outFile.sample.NumberReal = outFile.sample.Number - numel(outFile.blackListInd);
    outFile.sample.VolumeReal   = outFile.sample.VolumeHolo * outFile.sample.NumberReal;
%emtpy as-file case
else
    outFile = 'no Particle found';
end
%write as-file
if ~exist(folderASFile,'dir'), mkdir(folderASFile); end
save(fullfile(folderASFile, [nameASFile '_as.mat']),'outFile','-v7.3');






