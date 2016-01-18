%% analyzeCLACE2013_2014
% calculates cloud properties in intervals
%
% Read as-Files
% Predict Particle Class
% Read Sonic Data
% Read Manchester Data
% Calculates Data in Intervalls
% makes Inlet Efficiency Correction
%
% Paramter: Interval length / Histogram bins
%
% Uses: getHistBorder; predictClass; inputSonicData; mean_data; Paik_inert
%
% Output: nsecStat.mat

%Parameter for histogram bins [um]
anParameter.lowSize = 25;
anParameter.maxSize = 250;
anParameter.divideSize = 34;

%length of intervall [s]
anParameter.intervallVec = [0 0 0 0 0 60];
anParameter.intervall = datenum(anParameter.intervallVec);

%find as-files information
%anParameter.ParInfoFolder = 'D:\HOLOLAB';
%anParameter.ParInfoFolder = 'D:\TestCase2014\ParticleStats';
anParameter.ParInfoFolder = 'F:\HOLOLAB\10_28_ms2\';
%anParameter.ParInfoFolder = 'F:\CLACE2013\All\asFiles\';
%anParameter.ParInfoFolder = 'F:\CLACE2013\Background\';

cd(anParameter.ParInfoFolder);
anParameter.asSearch = '';
anParameter.ParInfoFiles = dir([anParameter.asSearch '*_as.mat']);
anParameter.ParInfoFiles = {anParameter.ParInfoFiles.name};

%load config file
anParameter.cfg = config(fullfile(anParameter.ParInfoFolder, 'holoviewer.cfg'));

%calculates histograms bins
[anParameter.histBinBorder, anParameter.histBinSizes, anParameter.histBinMiddle] ...
    = getHistBorder(anParameter.divideSize, anParameter.maxSize, anParameter.cfg, 1);
[anParameter.histBinBorderOldSizes, anParameter.histBinSizesOldSizes, anParameter.histBinMiddleOldSizes] ...
    = getHistBorder(anParameter.divideSize, anParameter.maxSize, anParameter.cfg, 0);

%Holo Data input
if ~exist('dataAll','var');
    %load the file and merge them together
    for cnt = 1:numel(anParameter.ParInfoFiles)
        %load as-files
        fprintf('Merge Particle Statistik File: %04u / %04u\n',cnt, numel(anParameter.ParInfoFiles) );
        temp = load(anParameter.ParInfoFiles{cnt});
        temp = temp.outFile;
        
        %         %only for background
        %         %temp.pStats.dateNumPar = ones(1,numel(temp.pStats.dateNumPar))*temp.pStats.dateNumPar(1);
        
        %merge data from non empty as-files
        if  isfield(temp, 'pStats') && sum(~isnan(temp.pStats.zPos))
            %for first as-files
            if ~exist('dataAll','var')
                cntOutFile = 1;
                
                dataAll = temp;
                
                dataAll.folderPSFile = {dataAll.folderPSFile} ;
                copyFields              = fieldnames(dataAll.pStats);
                
                dataAll.pStats.nHoloAllAll = dataAll.pStats.nHoloAll;
                %non first as-files
            else
                cntOutFile = cntOutFile + 1;
                
                dataAll.ampMean = [dataAll.ampMean temp.ampMean];
                dataAll.ampSTD = [dataAll.ampSTD temp.ampSTD];
                dataAll.ampThresh = [dataAll.ampThresh temp.ampThresh];
                dataAll.valid_particles = [dataAll.valid_particles temp.valid_particles];
                dataAll.folderPSFile{cnt} = temp.folderPSFile;
                dataAll.psFilenames = [dataAll.psFilenames temp.psFilenames];
                dataAll.emptyPsFile = [ dataAll.emptyPsFile temp.emptyPsFile];
                dataAll.dateNumHolo = [dataAll.dateNumHolo temp.dateNumHolo];
                dataAll.dateVecHolo = [dataAll.dateVecHolo temp.dateVecHolo];
                dataAll.blackListInd = [dataAll.blackListInd temp.blackListInd];
                dataAll.realInd = [dataAll.realInd temp.realInd];
                
                for cnt2 = 1:numel(copyFields)
                    if ~isfield(temp.pStats, copyFields{cnt2})
                        temp.pStats.(copyFields{cnt2}) = nan(1,numel(temp.pStats.zPos));
                    end
                    dataAll.pStats.(copyFields{cnt2}) = [dataAll.pStats.(copyFields{cnt2}) temp.pStats.(copyFields{cnt2})];
                end
                dataAll.pStats.nHoloAllAll = [dataAll.pStats.nHoloAllAll ...
                    temp.pStats.nHoloAll+dataAll.pStats.nHoloAllAll(end)];
            end
            clear temp
        end
    end
    
    dataAll.timeStart = dataAll.dateNumHolo(1);
    dataAll.timeEnd = dataAll.dateNumHolo(end);
    
    dataAll.dateVecHoloStart = dataAll.dateVecHolo(:,1);
    dataAll.dateVecHoloEnd = dataAll.dateVecHolo(:,end);
    
    %Predict Class of Particles
    dataAll.pStats = predictClassHOLOLAB(dataAll.pStats);
      
    %recalculate isBorder
    parameterIsBorder.borderPixel = 30;
    parameterIsBorder.minZPos = 1e-3;
    parameterIsBorder.maxZPos = 20e-3;
    parameterIsBorder.minXPos = (-dataAll.Nx/2+parameterIsBorder.borderPixel)*dataAll.dx;
    parameterIsBorder.maxXPos = (dataAll.Nx/2-parameterIsBorder.borderPixel)*dataAll.dx;
    parameterIsBorder.minYPos = (-dataAll.Ny/2+parameterIsBorder.borderPixel)*dataAll.dy;
    parameterIsBorder.maxYPos = (dataAll.Ny/2-parameterIsBorder.borderPixel)*dataAll.dy;
    dataAll.pStats.isBorder = isBorderParticle(dataAll.pStats.xPos, ...
        dataAll.pStats.yPos, dataAll.pStats.zPos, dataAll.zs ,dataAll.Nx, dataAll.Ny,...
        dataAll.dx, dataAll.dy, dataAll.dz, parameterIsBorder);
    
    
    %first calculations
    dataAll.pStats.partIsRealAll = dataAll.pStats.isInVolume & ...
        ~dataAll.pStats.isBorder & ...
        ~ismember(dataAll.pStats.predictedHClass,'Artefact');
    dataAll.pStats.partIsReal = dataAll.pStats.partIsRealAll & ...
        ~dataAll.pStats.partIsOnBlackList;
    dataAll.meanD   = nanmean(dataAll.pStats.pDiamOldSizesOldThresh(dataAll.pStats.partIsReal & ...
        dataAll.pStats.pDiamOldSizesOldThresh > anParameter.lowSize*1e-6 &...
        dataAll.pStats.pDiamOldSizesOldThresh < anParameter.maxSize*1e-6));
    dataAll.totalCount = nansum(dataAll.pStats.partIsReal & ...
        dataAll.pStats.pDiamOldSizesOldThresh > anParameter.lowSize*1e-6 &...
        dataAll.pStats.pDiamOldSizesOldThresh < anParameter.maxSize*1e-6);
end





%find Intervall
if ~isfield(dataAll, 'intervall');
    time = dataAll.timeStart;
    
    %     if anParameter.choosenDay == 0;
    %         dateAll.day = ones(1,numel(dataAll.dateNumHolo));
    %     else
    %         dateAll.day = zeros(1,numel(dataAll.dateNumHolo));
    %         dateAll.day(dataAll.dateVecHolo(:,3) == anParameter.choosenDay) = 1;
    %     end
    dataAll.intervall = zeros(1,numel(dataAll.pStats.zPos));
    cnt = 1;
    while time < dataAll.timeEnd
        datevec(time)
        tmp = dataAll.pStats.dateNumPar >= time & dataAll.pStats.dateNumPar < time + anParameter.intervall;
        if sum(tmp~=0)
            dataAll.intervall(tmp) =  cnt;
            cnt = cnt+1;
            time = time + anParameter.intervall;
        else
            tmp2 = find(dataAll.dateNumHolo > time+anParameter.intervall,1,'first');
            time = dataAll.dateNumHolo(tmp2);
        end
        
    end
    clear time
    clear tmp
    clear tmp2
    clear anDataAll
end

%first calculation in intervalls
if ~exist('anDataAll','var');
    for cnt = 1:max(dataAll.intervall)
        tmp = dataAll.intervall == cnt;
        anDataAll.timeStart(cnt) = min(dataAll.pStats.dateNumPar(tmp));
        anDataAll.timeEnd(cnt) = max(dataAll.pStats.dateNumPar(tmp));
        
        anDataAll.timeVecStart(:,cnt) = datevec(anDataAll.timeStart(cnt));
        anDataAll.timeVecEnd(:,cnt) =datevec(anDataAll.timeEnd(cnt));
        
        anDataAll.meanD(cnt)   = nanmean(dataAll.pStats.pDiamOldSizesOldThresh(tmp & dataAll.pStats.partIsReal & dataAll.pStats.pDiamOldSizesOldThresh > anParameter.lowSize*1e-6 &...
            dataAll.pStats.pDiamOldSizesOldThresh < anParameter.maxSize*1e-6));
        anDataAll.totalCount(cnt) = nansum(tmp & dataAll.pStats.partIsReal & dataAll.pStats.pDiamOldSizesOldThresh > anParameter.lowSize*1e-6 &...
            dataAll.pStats.pDiamOldSizesOldThresh < anParameter.maxSize*1e-6);
        
        anDataAll.isInVolume{cnt} = dataAll.pStats.isInVolume(tmp);
        anDataAll.isBorder{cnt} = dataAll.pStats.isBorder(tmp);
        anDataAll.partIsReal{cnt} = dataAll.pStats.partIsReal(tmp);
        anDataAll.partIsRealAll{cnt} = dataAll.pStats.partIsRealAll(tmp);
        
        anDataAll.predictedClass{cnt} = dataAll.pStats.predictedHClass(tmp);
        
        anDataAll.pDiam{cnt} = dataAll.pStats.pDiamOldSizesOldThresh(tmp);
        anDataAll.pDiamMean{cnt} = dataAll.pStats.pDiamMean(tmp);
        anDataAll.pDiamOldSizes{cnt} = dataAll.pStats.pDiamOldSizesOldThresh(tmp);
        anDataAll.pDiamOldThresh{cnt} = dataAll.pStats.pDiamOldSizesOldThresh(tmp);
        anDataAll.imEquivDiaOldSizes{cnt} = dataAll.pStats.imEquivDiaOldSizes(tmp);
        
        anDataAll.xPos{cnt} = dataAll.pStats.xPos(tmp);
        anDataAll.yPos{cnt} = dataAll.pStats.yPos(tmp);
        anDataAll.zPos{cnt} = dataAll.pStats.zPos(tmp);
        
        anDataAll.indHoloAll{cnt} = dataAll.pStats.nHoloAllAll(tmp);
        anDataAll.indHolo{cnt} = anDataAll.indHoloAll{cnt} - anDataAll.indHoloAll{cnt}(1)+1;
        
        anDataAll.sample{cnt}.Number      = anDataAll.indHolo{cnt}(end) - anDataAll.indHolo{cnt}(1);
        anDataAll.sample{cnt}.VolumeAll   = dataAll.sample.VolumeHolo * anDataAll.sample{cnt}.Number ;
        
        anDataAll.blackListInd{cnt} = unique(anDataAll.indHoloAll{cnt}(anDataAll.pDiam{cnt} >0.00025));
        anDataAll.partIsOnBlackList{cnt} = false(1, numel(anDataAll.indHoloAll{cnt}));
        for i = 1:numel(anDataAll.blackListInd{cnt})
            anDataAll.partIsOnBlackList{cnt} =  anDataAll.indHoloAll{cnt} == anDataAll.blackListInd{cnt}(i);
        end
        
        anDataAll.partIsWater{cnt} = anDataAll.partIsReal{cnt} & ...
            ismember(anDataAll.predictedClass{cnt},'Water');
        anDataAll.partIsSmallWater{cnt} = anDataAll.partIsReal{cnt} & ...
            ismember(anDataAll.predictedClass{cnt},'Small Water');
        anDataAll.partIsIce{cnt} = anDataAll.partIsReal{cnt} & ...
            ismember(anDataAll.predictedClass{cnt},'Ice');
        anDataAll.partIsSmallIce{cnt} = anDataAll.partIsReal{cnt} & ...
            ismember(anDataAll.predictedClass{cnt},'Small Ice');
        anDataAll.partIsAggregation{cnt} = anDataAll.partIsReal{cnt} & ...
            ismember(anDataAll.predictedClass{cnt},'Aggregation');
        
        
        anDataAll.partIsArtefact{cnt} = ~anDataAll.partIsReal{cnt};
        
        anDataAll.sample{cnt}.NumberReal = anDataAll.sample{cnt}.Number - numel(anDataAll.blackListInd{cnt});
        anDataAll.sample{cnt}.VolumeReal   = dataAll.sample.VolumeHolo * anDataAll.sample{cnt}.NumberReal;
        anDataAll.realInd{cnt} = find(anDataAll.partIsReal{cnt});
    end
end


%Calculation of Histograms
if true
    for cnt= 1:numel(anDataAll.timeStart);
        
        tmp = dataAll.intervall == cnt;
        
        
        
        anDataAll.timeString{cnt} = [num2str(anDataAll.timeVecStart(3,cnt),'%02u') 'th, ' ...
            num2str(anDataAll.timeVecStart(4, cnt),'%02u') ':' num2str(anDataAll.timeVecStart(5,cnt),'%02u') '-'...
            num2str(anDataAll.timeVecEnd(4,cnt),'%02u') ':' num2str(anDataAll.timeVecEnd(5,cnt),'%02u')];
        
        if isempty(anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt}))
            tmp = zeros(numel(anParameter.histBinMiddle),1);
            anDataAll.histReal(:,cnt) = tmp;
            anDataAll.limit(:,cnt) = tmp;
            anDataAll.histRealError(:,cnt) = tmp;
            anDataAll.histRealOldSizes(:,cnt) = tmp;
            anDataAll.limitOldSizes(:,cnt) = tmp;
            anDataAll.histRealErrorOldSizes(:,cnt) = tmp;
            anDataAll.histRealErrorCor(:,cnt) = tmp;
            anDataAll.histRealErrorCorOld(:,cnt) = tmp;
            anDataAll.histRealCount(:,cnt) = tmp;
            anDataAll.histRealCountCor(:,cnt)= tmp;
        else
            [anDataAll.histReal(:,cnt), ~, ~, anDataAll.limit(:,cnt), anDataAll.histRealError(:,cnt)] = ...
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt})*1e6, anDataAll.sample{cnt}.VolumeAll, anParameter.histBinBorder);
            [anDataAll.histRealOldSizes(:,cnt), ~, ~, anDataAll.limitOldSizes(:,cnt), anDataAll.histRealErrorOldSizes(:,cnt)] = ...
                histogram(anDataAll.pDiamOldSizes{cnt}(anDataAll.partIsReal{cnt})*1e6, anDataAll.sample{cnt}.VolumeAll, anParameter.histBinBorderOldSizes);
            
            
            
            anDataAll.histRealCount(:,cnt) =  histc(anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt})*1e6, anParameter.histBinBorder(1:end-1))';
            
        end
        
        if isempty(anDataAll.pDiam{cnt}(anDataAll.partIsWater{cnt}))
            tmp = zeros(numel(anParameter.histBinMiddle),1);
            anDataAll.water.histReal(:,cnt)=tmp;
            anDataAll.water.limit(:,cnt)=tmp;
            anDataAll.water.histRealError(:,cnt)=tmp;
            anDataAll.water.histRealCor(:,cnt)=tmp;
            anDataAll.water.histRealErrorCor(:,cnt)=tmp;
        else
            [anDataAll.water.histReal(:,cnt), ~, ~, anDataAll.water.limit(:,cnt), anDataAll.water.histRealError(:,cnt)] = ...
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsWater{cnt})*1e6, anDataAll.sample{cnt}.VolumeAll, anParameter.histBinBorder);
            
        end
        
        if isempty(anDataAll.pDiam{cnt}(anDataAll.partIsSmallWater{cnt}))
            tmp = zeros(numel(anParameter.histBinMiddle),1);
            anDataAll.smallWater.histReal(:,cnt)=tmp;
            anDataAll.smallWater.limit(:,cnt)=tmp;
            anDataAll.smallWater.histRealError(:,cnt)=tmp;
            anDataAll.smallWater.histRealCor(:,cnt)=tmp;
            anDataAll.smallWater.histRealErrorCor(:,cnt)=tmp;
        else
            [anDataAll.smallWater.histReal(:,cnt), ~, ~, anDataAll.smallWater.limit(:,cnt), anDataAll.smallWater.histRealError(:,cnt)] = ...
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsSmallWater{cnt})*1e6, anDataAll.sample{cnt}.VolumeAll, anParameter.histBinBorder);
            
        end
        
        
        if isempty(anDataAll.pDiam{cnt}(anDataAll.partIsIce{cnt}))
            tmp = zeros(numel(anParameter.histBinMiddle),1);
            anDataAll.ice.histReal(:,cnt)=tmp;
            anDataAll.ice.limit(:,cnt)=tmp;
            anDataAll.ice.histRealError(:,cnt)=tmp;
            anDataAll.ice.histRealCor(:,cnt)=tmp;
            anDataAll.ice.histRealErrorCor(:,cnt)=tmp;
        else
            [anDataAll.ice.histReal(:,cnt), ~, ~, anDataAll.ice.limit(:,cnt), anDataAll.ice.histRealError(:,cnt)] = ...
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsIce{cnt})*1e6, anDataAll.sample{cnt}.VolumeAll, anParameter.histBinBorder);
            
        end
        
        if isempty(anDataAll.pDiam{cnt}(anDataAll.partIsSmallIce{cnt}))
            tmp = zeros(numel(anParameter.histBinMiddle),1);
            anDataAll.smallIce.histReal(:,cnt)=tmp;
            anDataAll.smallIce.limit(:,cnt)=tmp;
            anDataAll.smallIce.histRealError(:,cnt)=tmp;
            anDataAll.smallIce.histRealCor(:,cnt)=tmp;
            anDataAll.smallIce.histRealErrorCor(:,cnt)=tmp;
        else
            [anDataAll.smallIce.histReal(:,cnt), ~, ~, anDataAll.smallIce.limit(:,cnt), anDataAll.smallIce.histRealError(:,cnt)] = ...
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsSmallIce{cnt})*1e6, anDataAll.sample{cnt}.VolumeAll, anParameter.histBinBorder);
            
        end
        
        if isempty(anDataAll.pDiam{cnt}(anDataAll.partIsAggregation{cnt}))
            tmp = zeros(numel(anParameter.histBinMiddle),1);
            anDataAll.aggregation.histReal(:,cnt)=tmp;
            anDataAll.aggregation.limit(:,cnt)=tmp;
            anDataAll.aggregation.histRealError(:,cnt)=tmp;
            anDataAll.aggregation.histRealCor(:,cnt)=tmp;
            anDataAll.aggregation.histRealErrorCor(:,cnt)=tmp;
        else
            [anDataAll.aggregation.histReal(:,cnt), ~, ~, anDataAll.aggregation.limit(:,cnt), anDataAll.aggregation.histRealError(:,cnt)] = ...
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsAggregation{cnt})*1e6, anDataAll.sample{cnt}.VolumeAll, anParameter.histBinBorder);
        end
        
        if isempty(anDataAll.pDiam{cnt}(anDataAll.partIsArtefact{cnt}))
            tmp = zeros(numel(anParameter.histBinMiddle),1);
            anDataAll.artefact.histReal(:,cnt)=tmp;
            anDataAll.artefact.limit(:,cnt)=tmp;
            anDataAll.artefact.histRealError(:,cnt)=tmp;
            
        else
            [anDataAll.artefact.histReal(:,cnt), ~, ~, anDataAll.artefact.limit(:,cnt), anDataAll.artefact.histRealError(:,cnt)] = ...
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsArtefact{cnt})*1e6, anDataAll.sample{cnt}.VolumeAll, anParameter.histBinBorder);
            
        end
        
        %Total Water calculations
        %parDiam = anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6);
        parDiam = anDataAll.pDiam{cnt}((anDataAll.partIsIce{cnt} | anDataAll.partIsWater{cnt}) & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
            anDataAll.pDiam{cnt} < anParameter.maxSize*1e-6);
        parDiam2 = anDataAll.pDiam{cnt}((anDataAll.partIsIce{cnt} | anDataAll.partIsWater{cnt}) & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
            anDataAll.pDiam{cnt} < 50*1e-6);
        if isempty(parDiam)
            hist = zeros(1,numel(anParameter.histBinMiddle));
        else
            hist = histc(parDiam, anParameter.histBinBorder*1e-6);
            hist = hist(1:end-1);
        end
        if isempty(parDiam2)
            hist2 = zeros(1,numel(anParameter.histBinMiddle));
        else
            hist2 = histc(parDiam2, anParameter.histBinBorder*1e-6);
            hist2 = hist2(1:end-1);
        end
        corr = 1;
        
        anDataAll.TWMeanDRaw(cnt) = nanmean(parDiam);
        if isnan(anDataAll.TWMeanDRaw(cnt))
            anDataAll.TWMeanD(cnt) = nan;
        else
            anDataAll.TWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*hist./corr/nansum(hist./corr));
        end
        anDataAll.TWCountRaw(cnt) = nansum(hist);
        anDataAll.TWCount(cnt) = nansum(hist./corr);
        anDataAll.TWConcentraction(cnt) = anDataAll.TWCount(cnt)/ anDataAll.sample{cnt}.VolumeReal*1e-6;
        %         if isnan(anDataAll.TWConcentraction(cnt))
        %             anDataAll.TWConcentraction(cnt) = 0;
        %         end
        anDataAll.TWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        anDataAll.TWContentRaw2(cnt)     = nansum(1/6*pi.*parDiam2.^3)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        %         if isnan(anDataAll.TWContentRaw(cnt))
        %             anDataAll.TWContentRaw(cnt) = 0;
        %         end
        anDataAll.TWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        anDataAll.TWContent2(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist2./corr)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        %         if isnan(anDataAll.TWContent(cnt))
        %             anDataAll.TWContent(cnt)  = 0;
        %         end
        
        clear parDiam
        clear parDiam2
        clear hist
        clear hist2
        clear corr
        
        %Ice Water calculations
        parDiam = anDataAll.pDiam{cnt}(anDataAll.partIsIce{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
            anDataAll.pDiam{cnt} < anParameter.maxSize*1e-6);
        if isempty(parDiam)
            hist = zeros(1,numel(anParameter.histBinMiddle));
        else
            hist = histc(parDiam, anParameter.histBinBorder*1e-6);
            hist = hist(1:end-1);
        end
        corr = 1;
        anDataAll.IWMeanDRaw(cnt) = nanmean(parDiam);
        if isnan(anDataAll.IWMeanDRaw(cnt))
            anDataAll.IWMeanD(cnt) = nan;
        else
            anDataAll.IWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*hist./corr/nansum(hist./corr));
        end
        anDataAll.IWCountRaw(cnt) = nansum(hist);
        anDataAll.IWCount(cnt) = nansum(hist./corr);
        anDataAll.IWConcentraction(cnt) = anDataAll.IWCount(cnt)/ anDataAll.sample{cnt}.VolumeReal*1e-6;
        anDataAll.IWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        anDataAll.IWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        clear parDiam
        clear parDaim2
        clear hist
        clear hist2
        clear corr
        
        %Small Ice Water calculations
        parDiam = anDataAll.pDiam{cnt}(anDataAll.partIsSmallIce{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
            anDataAll.pDiam{cnt} < anParameter.maxSize*1e-6);
        if isempty(parDiam)
            hist = zeros(1,numel(anParameter.histBinMiddle));
        else
            hist = histc(parDiam, anParameter.histBinBorder*1e-6);
            hist = hist(1:end-1);
        end
        corr = 1;
        anDataAll.SIWMeanDRaw(cnt) = nanmean(parDiam);
        if isnan(anDataAll.SIWMeanDRaw(cnt))
            anDataAll.SIWMeanD(cnt) = nan;
        else
            anDataAll.SIWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*hist./corr/nansum(hist./corr));
        end
        anDataAll.SIWCountRaw(cnt) = nansum(hist);
        anDataAll.SIWCount(cnt) = nansum(hist./corr);
        anDataAll.SIWConcentraction(cnt) = anDataAll.SIWCount(cnt)/ anDataAll.sample{cnt}.VolumeReal*1e-6;
        anDataAll.SIWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        anDataAll.SIWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        clear parDiam
        clear parDaim2
        clear hist
        clear hist2
        clear corr
        
        %Liquid Water calculations        
        parDiam = anDataAll.pDiam{cnt}(anDataAll.partIsWater{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
            anDataAll.pDiam{cnt} < anParameter.maxSize*1e-6);
        if isempty(parDiam)
            hist = zeros(1,numel(anParameter.histBinMiddle));
        else
            hist = histc(parDiam, anParameter.histBinBorder*1e-6);
            hist = hist(1:end-1);
        end
        corr = 1;
        
        anDataAll.LWMeanDRaw(cnt) = nanmean(parDiam);
        if isnan(anDataAll.LWMeanDRaw(cnt))
            anDataAll.LWMeanD(cnt) = nan;
        else
            anDataAll.LWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*hist./corr/nansum(hist./corr));
        end
        anDataAll.LWCountRaw(cnt) = nansum(hist);
        anDataAll.LWCount(cnt) = nansum(hist./corr);
        anDataAll.LWConcentraction(cnt) = anDataAll.LWCount(cnt)/ anDataAll.sample{cnt}.VolumeReal*1e-6;
        anDataAll.LWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        anDataAll.LWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        clear parDiam
        clear hist
        clear corr
        
        %SmallLiquid Water calculations        
        parDiam = anDataAll.pDiam{cnt}(anDataAll.partIsSmallWater{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
            anDataAll.pDiam{cnt} < anParameter.maxSize*1e-6);
        if isempty(parDiam)
            hist = zeros(1,numel(anParameter.histBinMiddle));
        else
            hist = histc(parDiam, anParameter.histBinBorder*1e-6);
            hist = hist(1:end-1);
        end
        corr = 1;
        
        anDataAll.SLWMeanDRaw(cnt) = nanmean(parDiam);
        if isnan(anDataAll.SLWMeanDRaw(cnt))
            anDataAll.SLWMeanD(cnt) = nan;
        else
            anDataAll.SLWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*hist./corr/nansum(hist./corr));
        end
        anDataAll.SLWCountRaw(cnt) = nansum(hist);
        anDataAll.SLWCount(cnt) = nansum(hist./corr);
        anDataAll.SLWConcentraction(cnt) = anDataAll.SLWCount(cnt)/ anDataAll.sample{cnt}.VolumeReal*1e-6;
        anDataAll.SLWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        anDataAll.SLWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        clear parDiam
        clear hist
        clear corr
        
        %Aggregation Water calculations        
        parDiam = anDataAll.pDiam{cnt}(anDataAll.partIsAggregation{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
            anDataAll.pDiam{cnt} < anParameter.maxSize*1e-6);
        if isempty(parDiam)
            hist = zeros(1,numel(anParameter.histBinMiddle));
        else
            hist = histc(parDiam, anParameter.histBinBorder*1e-6);
            hist = hist(1:end-1);
        end
        corr = 1;
        
        anDataAll.AWMeanDRaw(cnt) = nanmean(parDiam);
        if isnan(anDataAll.AWMeanDRaw(cnt))
            anDataAll.AWMeanD(cnt) = nan;
        else
            anDataAll.AWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*hist./corr/nansum(hist./corr));
        end
        anDataAll.AWCountRaw(cnt) = nansum(hist);
        anDataAll.AWCount(cnt) = nansum(hist./corr);
        anDataAll.AWConcentraction(cnt) = anDataAll.AWCount(cnt)/ anDataAll.sample{cnt}.VolumeReal*1e-6;
        anDataAll.AWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        anDataAll.AWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        clear parDiam
        clear hist
        clear corr
        
        
    end
end


%writeData
anDataAll.Parameter = anParameter;
save(['HOLOLAB_' num2str(anParameter.intervallVec(6)) 'secStat.mat'],'anDataAll');