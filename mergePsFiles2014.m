%%mergePSFiles: merge all ps-file in a folder into a single ms-file;
%%calculates isBorderParticles; exlude holograms with large ice crystals;
%%perform size correction; 
%folderPSFile: Folder ps-file
%nameMSFile: Name of ms-file
%folderMSfile: Folder of ms-file
%uses: isBorderParticle; pDiamFromImage; getTimeFromeFileName;
%       correction_diameter
function outFile = mergePsFiles(folderPSFile, nameMSFile, folderMSFile)

%get ps-file names
cd(folderPSFile);
psfilenames = dir('*_ps.mat');
psfilenames = {psfilenames.name};
emptyPsFile = zeros(1,numel(psfilenames));

%%loop over ps-files
for cnt = 1:numel(psfilenames)
    fprintf('Merge Perticle Statistik File: %04u / %04u\n',cnt, numel(psfilenames) );

    try
        temp = load(psfilenames{cnt});
    catch exception
        warning(exception.message)
        temp = [];
        emptyPsFile(cnt) = 1;
    end
    
    if ~isfield(temp, 'pStats')
        emptyPsFile(cnt) = 1;
    elseif isnan(temp.pStats.zPos)
        emptyPsFile(cnt) = 1;
    else
        %        if ~isfield(temp, 'dx'); temp.dx = 2.72e-06; end
        %       if ~isfield(temp, 'dy'); temp.dy = 2.72e-06; end
        %      if ~isfield(temp, 'dz'); temp.dz = 50e-06; end
        
        %
        if isfield(temp.pStats, 'isBorder')
            temp.pStats.isBorderOld = temp.pStats.isBorder;
        end
        
        parameterIsBorder.borderPixel = 20;
        parameterIsBorder.minZPos = 1e-3;
        parameterIsBorder.maxZPos = 50e-3;
        parameterIsBorder.minXPos = (-temp.Nx/2+parameterIsBorder.borderPixel)*temp.dx;
        parameterIsBorder.maxXPos = (temp.Nx/2-parameterIsBorder.borderPixel)*temp.dx;
        parameterIsBorder.minYPos = (-temp.Ny/2+parameterIsBorder.borderPixel)*temp.dy;
        parameterIsBorder.maxYPos = (temp.Ny/2-parameterIsBorder.borderPixel)*temp.dy;
        temp.pStats.isBorder = isBorderParticle(temp.pStats.xPos, ...
            temp.pStats.yPos, temp.pStats.zPos, temp.zs ,temp.Nx, temp.Ny,...
            temp.dx, temp.dy, temp.dz, parameterIsBorder);
        
        %calculate particle diameter with 2012 paramter
        temp.pStats.pDiamOldThresh= pDiamFrompImage(temp.pStats.pImage, ...
            -6, inf, -0.17, 0.17, @and, temp.ampMean, temp.ampSTD, temp.dx, temp.dy);
        
        % add RadTrStats
        %         if sum(~isnan(temp.pStats.rtDp)) == 0
        %             for cnt2 = 1:numel(temp.pStats.rtDp)
        %                 radst = particleForRtStats.getRadTrStats(temp.pStats.pImage{cnt2},....
        %                     temp.pStats.imCenterx(cnt2),...
        %                     temp.pStats.imCenterx(cnt2));
        %                 dr = sqrt(temp.dx*temp.dy);
        %                 radst.rtrs(2)        = radst.rtrs(2) * dr;
        %                 radst.rtBestFit(3:4) = radst.rtBestFit(3:4) *dr;
        %                 radst.rtDp           = radst.rtDp *dr;
        %                 radst.rtBSlope       = radst.rtBSlope *dr;
        %                 radst.rtSignal       = radst.rtSignal *dr^2;
        %                 temp.pStats.rtrs{cnt2} = radst.rtrs;
        %                 temp.pStats.rtBestFit{cnt2} = radst.rtBestFit;
        %                 temp.pStats.rtDp(cnt2) = radst.rtDp;
        %                 temp.pStats.rtBSlope(cnt2) = radst.rtBSlope;
        %                 temp.pStats.rtSignal(cnt2) = radst.rtSignal;
        %                 temp.pStats.rtGoodFit(cnt2) = radst.rtGoodFit;
        %                 temp.pStats.rtAsym(cnt2) = radst.rtAsym;
        %                 temp.pStats.rtCenterx(cnt2) = radst.rtCenterx;
        %                 temp.pStats.rtCentery(cnt2) = radst.rtCentery;
        %                 if rem(cnt2,100)==0
        %                     fprintf('Calculating rtStats from particle nr. %u / %u from ms file %u / %u\n',...
        %                         cnt2, numel(temp.pStats.rtDp), cnt, numel(psfilenames))
        %                 end
        %
        %             end
        %         end
        
        %skip if empty ps-file
        if ~isnan(temp.pStats.zPos)
            %for the first non empty ps-file
            if ~exist('outFile','var')
                %counter of ps file
                cntOutFile = 1;
                %create outFile
                outFile = temp;
                %set folder of ps-files
                outFile.folderPSFile = pwd;
                %names of ps-files
                outFile.psFilenames = psfilenames;
                %convert name of ps-file into dateNum and dateVec
                [outFile.dateNumHolo, outFile.dateVecHolo] = getTimeFromFileName(psfilenames{1});
                outFile.dateVecHolo =  outFile.dateVecHolo';
                %every particle get ps-file number
                outFile.pStats.nHolo = ones(1,numel(outFile.pStats.pDiam));
                %some conversion
                outFile.pStats.isInVolume = cell2mat(outFile.pStats.isInVolume);
                if iscell(temp.pStats.isBorder)
                    outFile.pStats.isBorder = cell2mat(outFile.pStats.isBorder);
                end
                outFile.ampThresh = outFile.ampThresh';
                
                outFile.parameterIsBorder = parameterIsBorder;              
                
                %copy all parameter of pStats to outFile
                copyFields              = fieldnames(outFile.pStats);
                outFile.pStats.dateNumPar = outFile.dateNumHolo*ones(1,numel(outFile.pStats.zPos));
                
                %for the non first non empty ps-file
            else
                %counter of ps file
                cntOutFile = cntOutFile + 1;
                %every particle get ps-file number
                temp.pStats.nHolo = cntOutFile*ones(1,numel(temp.pStats.pDiam));
                %some conversion
                temp.pStats.isInVolume = cell2mat(temp.pStats.isInVolume);
                %maybe old
                if iscell(temp.pStats.isBorder)
                    temp.pStats.isBorder = cell2mat(temp.pStats.isBorder);
                end
                %add parameter of hologram
                outFile.ampMean(cntOutFile) = temp.ampMean;
                outFile.ampSTD(cntOutFile) = temp.ampSTD;
                outFile.ampThresh(:,cntOutFile) = temp.ampThresh';
                %add valid particle number
                if isfield(temp,'valid_particles')
                    outFile.valid_particles = [outFile.valid_particles temp.valid_particles];
                end
                %add dateNum and dateVec from name of ps-file
                [temp2, temp3] = getTimeFromFileName(psfilenames{cnt});
                outFile.dateNumHolo(cntOutFile) = temp2;
                outFile.dateVecHolo(:,cntOutFile) = temp3';
                %add all parameter of pStats to outFile
                for cnt2 = 1:numel(copyFields)
                    outFile.pStats.(copyFields{cnt2}) = [outFile.pStats.(copyFields{cnt2}) temp.pStats.(copyFields{cnt2})];
                end
                outFile.pStats.dateNumPar = [outFile.pStats.dateNumPar temp2*ones(1,numel(outFile.pStats.zPos))];
            end
        end
        clear temp temp2 temp3
    end
end
outFile.emptyPsFile = emptyPsFile;

%%make size Correction of particle
if exist('outFile','var') && isfield(outFile, 'pStats')
    %size Correction
    outFile.pStats.pDiamOldSizes = outFile.pStats.pDiam;
    outFile.pStats.pDiam = correction_diameter(outFile.pStats.pDiam);
    
    outFile.pStats.pDiamOldSizesOldThresh = outFile.pStats.pDiamOldThresh;
    outFile.pStats.pDiamOldThresh = correction_diameter(outFile.pStats.pDiamOldThresh);
    
    outFile.pStats.imEquivDiaOldSizes = outFile.pStats.imEquivDia;
    outFile.pStats.imEquivDia = correction_diameter(outFile.pStats.imEquivDia);
    
    outFile.pStats.pDiamMean = nanmean([outFile.pStats.pDiam; outFile.pStats.imEquivDiaOldSizes]);
    outFile.pStats.imDiamMean = nanmean([outFile.pStats.pDiam; outFile.pStats.imEquivDia]);
    outFile.pStats.imDiamMeanOldSizes = nanmean([outFile.pStats.pDiamOldSizes; outFile.pStats.imEquivDiaOldSizes]);
    
    %calculate total sample parameters
    outFile.sample.Size.x      = outFile.parameterIsBorder.maxXPos - outFile.parameterIsBorder.minXPos;
    outFile.sample.Size.y      = outFile.parameterIsBorder.maxYPos - outFile.parameterIsBorder.minYPos;
    outFile.sample.Size.z      = outFile.parameterIsBorder.maxZPos - outFile.parameterIsBorder.minZPos;
    outFile.sample.VolumeHolo  = outFile.sample.Size.x * outFile.sample.Size.y * outFile.sample.Size.z;
    outFile.sample.Number      = outFile.pStats.nHolo(end);
    outFile.sample.VolumeAll   = outFile.sample.VolumeHolo * outFile.sample.Number;
    
    %filter out all particles on holograms with have a particle larger than
    %250 um
    outFile.blackListInd = unique(outFile.pStats.nHolo(outFile.pStats.pDiam >0.00025));
    outFile.pStats.partIsOnBlackList = false(1, numel(outFile.pStats.nHolo));
    for i = 1:numel(outFile.blackListInd)
        outFile.pStats.partIsOnBlackList =  outFile.pStats.nHolo == outFile.blackListInd(i);
    end
    
    %all particle which are not border
    outFile.pStats.partIsRealAll  = ~outFile.pStats.isBorder;
    %calculates statistics for particle which are not border and on holograms with large ice crystals
    outFile.pStats.partIsReal     = ~outFile.pStats.isBorder & ~outFile.pStats.partIsOnBlackList;
    outFile.sample.NumberReal = outFile.sample.Number - numel(outFile.blackListInd);
    outFile.sample.VolumeReal   = outFile.sample.VolumeHolo * outFile.sample.NumberReal;
    outFile.realInd = find(outFile.pStats.partIsReal);
else
    %empty ms-file case
    outFile = 'no Particle found';
end
%write outfile to an ms-file
if ~exist(folderMSFile,'dir'), mkdir(folderMSFile); end
save(fullfile(folderMSFile, ['H-' nameMSFile '_ms.mat']),'outFile','-v7.3');






