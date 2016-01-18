%%mergePSFiles: merge a ps-file to a single ms-file
%folderPSFile: Folder ps-file
%nameMSFile: Name of ms-file
%folderMSfile: Folder of ms-file

function outFile = mergePsFiles(folderPSFile, nameMSFile, folderMSFile)

%get ps-file names
cd(folderPSFile);
psfilenames = dir('*_ps.mat');
psfilenames = {psfilenames.name};
emptyPsFile = zeros(1,numel(psfilenames));

%loop over ps-files
for cnt = 1:numel(psfilenames)
    fprintf('Merge Perticle Statistik File: %04u / %04u\n',cnt, numel(psfilenames) );
    temp = load(psfilenames{cnt});  
    
    if ~isfield(temp, 'pStats') 
        emptyPsFile(cnt) = 1;
    elseif isnan(temp.pStats.zPos)
        emptyPsFile(cnt) = 1;
    else
        if ~isfield(temp, 'dx'); temp.dx = 2.72e-06; end
        if ~isfield(temp, 'dy'); temp.dy = 2.72e-06; end
        if ~isfield(temp, 'dz'); temp.dz = 50e-06; end
        if isfield(temp.pStats, 'isBorder')
        temp.pStats.isBorderOld = temp.pStats.isBorder;
        end
        parameterIsBorder.borderPixel = 10;
        parameterIsBorder.minZPos = 1e-3;
        parameterIsBorder.maxZPos = 20e-3;
        temp.pStats.isBorder = isBorderParticle(temp.pStats.xPos, ...
            temp.pStats.yPos, temp.pStats.zPos, temp.zs ,temp.Nx, temp.Ny,...
            temp.dx, temp.dy, temp.dz, parameterIsBorder);
        
        
        temp.pStats.pDiamOldThresh= pDiamFrompImage(temp.pStats.pImage, ...
            -6, inf, -0.17, 0.17, @and, temp.ampMean, temp.ampSTD, temp.dx, temp.dy);
        
        %add RadTrStats
        if sum(~isnan(temp.pStats.rtDp)) == 0
            for cnt2 = 1:numel(temp.pStats.rtDp)
                radst = particleForRtStats.getRadTrStats(temp.pStats.pImage{cnt2},....
                    temp.pStats.imCenterx(cnt2),...
                    temp.pStats.imCenterx(cnt2));
                dr = sqrt(temp.dx*temp.dy);
                radst.rtrs(2)        = radst.rtrs(2) * dr;
                radst.rtBestFit(3:4) = radst.rtBestFit(3:4) *dr;
                radst.rtDp           = radst.rtDp *dr;
                radst.rtBSlope       = radst.rtBSlope *dr;
                radst.rtSignal       = radst.rtSignal *dr^2;
                temp.pStats.rtrs{cnt2} = radst.rtrs;
                temp.pStats.rtBestFit{cnt2} = radst.rtBestFit;
                temp.pStats.rtDp(cnt2) = radst.rtDp;
                temp.pStats.rtBSlope(cnt2) = radst.rtBSlope;
                temp.pStats.rtSignal(cnt2) = radst.rtSignal;
                temp.pStats.rtGoodFit(cnt2) = radst.rtGoodFit;
                temp.pStats.rtAsym(cnt2) = radst.rtAsym;
                temp.pStats.rtCenterx(cnt2) = radst.rtCenterx;
                temp.pStats.rtCentery(cnt2) = radst.rtCentery;
                if rem(cnt2,100)==0
                    fprintf('Calculating rtStats from particle nr. %u / %u from ms file %u / %u\n',...
                        cnt2, numel(temp.pStats.rtDp), cnt, numel(psfilenames))
                end
                
            end
        end
            
        
        if ~isnan(temp.pStats.zPos)
            if ~exist('outFile','var')
                cntOutFile = 1;
                
                outFile = temp;
                
                outFile.folderPSFile = pwd;
                outFile.psFilenames = psfilenames;
                outFile.dateVecHolo = [2014 1 1 0 0 str2num(psfilenames{cntOutFile}(18:20))];
                outFile.dateNumHolo = datenum(outFile.dateVecHolo);
                %[outFile.dateNumHolo, outFile.dateVecHolo] = getTimeFromFileName(psfilenames{1});
                outFile.dateVecHolo =  outFile.dateVecHolo';
                
                outFile.pStats.nHolo = ones(1,numel(outFile.pStats.pDiam));
                outFile.pStats.isInVolume = cell2mat(outFile.pStats.isInVolume);
                if iscell(temp.pStats.isBorder)
                    outFile.pStats.isBorder = cell2mat(outFile.pStats.isBorder);
                end
                outFile.ampThresh = outFile.ampThresh';
                
                copyFields              = fieldnames(outFile.pStats);
                outFile.pStats.dateNumPar = outFile.dateNumHolo*ones(1,numel(outFile.pStats.zPos));
            else
                cntOutFile = cntOutFile + 1;
                
                temp.pStats.nHolo = cntOutFile*ones(1,numel(temp.pStats.pDiam));
                temp.pStats.isInVolume = cell2mat(temp.pStats.isInVolume);                
                if iscell(temp.pStats.isBorder)
                    temp.pStats.isBorder = cell2mat(temp.pStats.isBorder);
                end
                outFile.ampMean(cntOutFile) = temp.ampMean;
                outFile.ampSTD(cntOutFile) = temp.ampSTD;
                outFile.ampThresh(:,cntOutFile) = temp.ampThresh';
                if isfield(temp,'valid_particles')
                    outFile.valid_particles = [outFile.valid_particles temp.valid_particles];
                end
                temp3 = [2014 1 1 0 0 str2num(psfilenames{cntOutFile}(18:20))];
                temp2 = datenum(temp3);
                outFile.dateNumHolo(cntOutFile) = temp2;
                outFile.dateVecHolo(:,cntOutFile) = temp3';
                for cnt2 = 1:numel(copyFields)
                    outFile.pStats.(copyFields{cnt2}) = [outFile.pStats.(copyFields{cnt2}) temp.pStats.(copyFields{cnt2})];
                end
                outFile.pStats.dateNumPar = [outFile.pStats.dateNumPar temp2*ones(1,numel(temp.pStats.zPos))];
            end
        end
        clear temp temp2 temp3
    end
end
outFile.emptyPsFile = emptyPsFile;

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
    
    outFile.parameterInVolume.borderPixel = 10;
    outFile.parameterInVolume.minZPos = 1e-3;
    outFile.parameterInVolume.maxZPos = 20e-3;
    outFile.parameterInVolume.minXPos = (-outFile.Nx/2+outFile.parameterInVolume.borderPixel)*outFile.dx;
    outFile.parameterInVolume.maxXPos = (outFile.Nx/2-outFile.parameterInVolume.borderPixel)*outFile.dx;
    outFile.parameterInVolume.minYPos = (-outFile.Ny/2+outFile.parameterInVolume.borderPixel)*outFile.dy;
    outFile.parameterInVolume.maxYPos = (outFile.Ny/2-outFile.parameterInVolume.borderPixel)*outFile.dy;
    
    
    outFile.sample.Size.x      = outFile.parameterInVolume.maxXPos - outFile.parameterInVolume.minXPos;
    outFile.sample.Size.y      = outFile.parameterInVolume.maxYPos - outFile.parameterInVolume.minYPos;
    outFile.sample.Size.z      = outFile.parameterInVolume.maxZPos - outFile.parameterInVolume.minZPos;
    outFile.sample.VolumeHolo  = outFile.sample.Size.x * outFile.sample.Size.y * outFile.sample.Size.z;
    outFile.sample.Number      = outFile.pStats.nHolo(end);
    outFile.sample.VolumeAll   = outFile.sample.VolumeHolo * outFile.sample.Number;
    
    %outFile.timeVec = conTime2Vec(outFile.timeHolo);
    
    outFile.blackListInd = unique(outFile.pStats.nHolo(outFile.pStats.pDiam >0.00025));
    outFile.pStats.partIsOnBlackList = false(1, numel(outFile.pStats.nHolo));
    for i = 1:numel(outFile.blackListInd)
        outFile.pStats.partIsOnBlackList =  outFile.pStats.nHolo == outFile.blackListInd(i);
    end
    
    
    outFile.pStats.partIsRealAll  = ~outFile.pStats.isBorder;
    outFile.pStats.partIsReal     = ~outFile.pStats.isBorder & ~outFile.pStats.partIsOnBlackList;
    outFile.sample.NumberReal = outFile.sample.Number - numel(outFile.blackListInd);
    outFile.sample.VolumeReal   = outFile.sample.VolumeHolo * outFile.sample.NumberReal;
    outFile.realInd = find(outFile.pStats.partIsReal);
else
    outFile = 'no Particle found';
end
if ~exist(folderMSFile,'dir'), mkdir(folderMSFile); end
save(fullfile(folderMSFile, ['H-' nameMSFile '_ms.mat']),'outFile','-v7.3');






