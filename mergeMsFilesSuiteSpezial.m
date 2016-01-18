function outFile = mergeMsFilesSuiteSpezial(folderMSFile, nameMSFile, nameASFile, folderASFile)

cd(folderMSFile); 
msfilenames = dir(['H-*' nameMSFile '*_ms.mat']);
msfilenames = {msfilenames.name};

%load the file and merge them together
for cnt = 1:numel(msfilenames)
    fprintf('Merge Particle Statistik File: %04u / %04u\n',cnt, numel(msfilenames) );
    temp = load(msfilenames{cnt});
    temp = temp.outFile;
    
    dateStamp = temp.folderPSFile(4:13);
    dateStamp = regexprep(dateStamp, '\.' , '-');
    dateStamp = textscan(dateStamp, '%u','delimiter','-');
    dateStamp = double(dateStamp{1}(1:3));
    dateStamp = dateStamp';    
    
    %correct dateNumHolo and dateVecHolo
    if temp.dateNumHolo(1) < 4e5
        for cnt2 = 1:numel(temp.dateNumHolo)
            
            timeStamp = temp.psFilenames{cnt2}(1:end-8);
            timeStamp = regexprep(timeStamp, '\.' , '-');
            timeStamp = textscan(timeStamp, '%u','delimiter','-');
            timeStamp = double(timeStamp{1}(1:4));
            timeStamp(3) = timeStamp(3) + timeStamp(4)/1000;
            timeStamp(4) = [];
            timeStamp = timeStamp';
            temp.dateNumHolo(cnt2) = datenum([dateStamp timeStamp]);
            temp.dateVecHolo(:,cnt2) = datevec(temp.dateNumHolo(cnt2))';          
        end   
    end
    temp.pStats.dateNumPar = temp.dateNumHolo(temp.pStats.nHolo);
    
    if  isfield(temp, 'pStats') && sum(~isnan(temp.pStats.zPos))
        if ~exist('outFile','var')
            cntOutFile = 1;
            
            outFile = temp;
            
            outFile.folderPSFile = {outFile.folderPSFile} ;
            copyFields              = fieldnames(outFile.pStats);
            copyFields = copyFields(~strcmp(copyFields,'pImage'));
            outFile.pStats = rmfield(outFile.pStats, 'pImage');
            
            outFile.pStats.nHoloAll = outFile.pStats.nHolo;
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


if exist('outFile','var')    
    outFile.sample.Number      = outFile.pStats.nHoloAll(end);
    outFile.sample.VolumeAll   = outFile.sample.VolumeHolo * outFile.sample.Number;
       
  
    outFile.sample.NumberReal = outFile.sample.Number - numel(outFile.blackListInd);
    outFile.sample.VolumeReal   = outFile.sample.VolumeHolo * outFile.sample.NumberReal;
else
    outFile = 'no Particle found';
end
if ~exist(folderASFile,'dir'), mkdir(folderASFile); end
save(fullfile(folderASFile, [nameASFile '_as.mat']),'outFile','-v7.3');






