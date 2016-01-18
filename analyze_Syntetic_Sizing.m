%% analyzeCLACE2013_2014_Syntetisch
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
% Output: nsecStat.mat_

%Parameter for histogram bins [um]
anParameter.lowSize = 6;
anParameter.maxSize = 250;
anParameter.divideSize = 34;

%length of intervall [s]
%dataAll = rmfield(dataAll, 'intervall');
anParameter.intervallVec = [0 0 0 0 0 1];
anParameter.intervall = datenum(anParameter.intervallVec);

%find as-files information
%anParameter.ParInfoFolder = 'D:\HOLOLAB';
%anParameter.ParInfoFolder = 'D:\TestCase2014\ParticleStats';
%anParameter.FolderData = 'Z:\3_Data\CLACE2013';
%anParameter.ParInfoFolder = 'Z:\5_ParticleStats\CLACE2013-10-as';
anParameter.ParInfoFolder = 'Z:\1_Raw_Images\2014_Synthisch';

%anParameter.ParInfoFolder = 'F:\CLACE2013\All\asFiles\';
%anParameter.ParInfoFolder = 'F:\CLACE2013\Background\';

cd(anParameter.ParInfoFolder);

%clear dataAll
anParameter.timeStart = datenum([2014 1 1 0 0 0.5]);
anParameter.timeEnd = anParameter.timeStart + datenum([0 0 0 0 0 101]);
anParameter.asSearch = 'SYNHOLO';
anParameter.ParInfoFiles = dir(['*' anParameter.asSearch '*_ms.mat']);
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
                dataAll{cnt} = temp;
                
                dataAll{cnt}.folderPSFile = {dataAll{cnt}.folderPSFile} ;
                       
        end
    end
end

if ~isfield(dataAll{1}, 'meanD');
    for cnt = 1:numel(anParameter.ParInfoFiles)
        
        %Predict Class of Particles
        dataAll{cnt}.pStats = predictClass(dataAll{cnt}.pStats);
        
        %first calculations
        dataAll{cnt}.pStats.partIsRealAll = dataAll{cnt}.pStats.isInVolume & ...
            ~dataAll{cnt}.pStats.isBorder & ...
            ~ismember(dataAll{cnt}.pStats.predictedHClass,'Artefact');
        dataAll{cnt}.pStats.partIsReal = dataAll{cnt}.pStats.partIsRealAll & ...
            ~dataAll{cnt}.pStats.partIsOnBlackList;
        dataAll{cnt}.meanD   = nanmean(dataAll{cnt}.pStats.pDiamOldSizesOldThresh(dataAll{cnt}.pStats.partIsReal & ...
            dataAll{cnt}.pStats.pDiamOldSizesOldThresh > anParameter.lowSize*1e-6 &...
            dataAll{cnt}.pStats.pDiamOldSizesOldThresh < anParameter.maxSize*1e-6));
        dataAll{cnt}.totalCount = nansum(dataAll{cnt}.pStats.partIsReal & ...
            dataAll{cnt}.pStats.pDiamOldSizesOldThresh > anParameter.lowSize*1e-6 &...
            dataAll{cnt}.pStats.pDiamOldSizesOldThresh < anParameter.maxSize*1e-6);
        
        
        
        dataAll{cnt}.timeStart = anParameter.timeStart;
        dataAll{cnt}.timeEnd = anParameter.timeEnd;
        dataAll{cnt}.dateVecHoloStart = datevec(dataAll{cnt}.timeStart);
        dataAll{cnt}.dateVecHoloEnd = datevec(dataAll{cnt}.timeEnd);
    end
end
%%%STOP%%%

if ~exist('anDataAll','var');
    for cnt = 1:numel(anParameter.ParInfoFiles)
        anDataAll.indHolo{cnt} = dataAll{cnt}.sample.Number;
        
        anDataAll.sample.VolumeHolo       = dataAll{cnt}.sample.VolumeHolo;
        anDataAll.sample.Number(cnt)      = anDataAll.indHolo{cnt}(end) - anDataAll.indHolo{cnt}(1)+1;
        anDataAll.sample.VolumeAll(cnt)   = dataAll{cnt}.sample.VolumeHolo * anDataAll.sample.Number(cnt) ;
        
        anDataAll.sample.NumberReal(cnt)  = anDataAll.sample.Number(cnt);
        anDataAll.sample.VolumeReal(cnt)    = dataAll{cnt}.sample.VolumeHolo * anDataAll.sample.NumberReal(cnt);
        
       
        
        %new start
        anDataAll.NpDiamOldSizes{cnt} = dataAll{cnt}.pStats.pDiamOldSizes;
        anDataAll.NpDiam{cnt} = dataAll{cnt}.pStats.pDiam;
        anDataAll.NpDiamOldSizesOldThresh{cnt} = dataAll{cnt}.pStats.pDiamOldSizesOldThresh;
        anDataAll.NpDiamOldThresh{cnt} = dataAll{cnt}.pStats.pDiamOldThresh;
        anDataAll.NimEquivDiaOldSizes{cnt} = dataAll{cnt}.pStats.imEquivDiaOldSizes;
        
        anDataAll.NimEquivDia{cnt} = dataAll{cnt}.pStats.imEquivDia;
        anDataAll.NpDiamMean{cnt} = dataAll{cnt}.pStats.pDiamMean;
        anDataAll.NimDiamMean{cnt} = dataAll{cnt}.pStats.imDiamMean;
        anDataAll.NimDiamMeanOldSizes{cnt} = dataAll{cnt}.pStats.imDiamMeanOldSizes;
        
        anDataAll.partIsReal{cnt} = dataAll{cnt}.pStats.partIsReal;
        
        %histBorder = anParameter.histBinBorder(1:end-1);
        %histBorder = [0.5:1:250];
        histBorder = logspace(log10(0.5),log10(250),60)
        tmpBorderHigh = histBorder(2:end);
        tmpBorderLow = histBorder(1:end-1);
        histMiddle = (tmpBorderHigh+tmpBorderLow)/2
        %histMiddle = [1:1:249];
        anDataAll.NHistBinBorder = histBorder;
        anDataAll.NHistBin = histMiddle;

        anDataAll.NpDiamOldSizesHist(:,cnt) =  histogram(anDataAll.NpDiamOldSizes{cnt}...
            (anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt),histBorder);
        anDataAll.NpDiamHist(:,cnt) =  histogram(anDataAll.NpDiam{cnt}...
            (anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt),histBorder)';
        anDataAll.NpDiamOldSizesOldThreshHist(:,cnt) =  histogram(anDataAll.NpDiamOldSizesOldThresh{cnt}...
            (anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt),histBorder)';
        anDataAll.NpDiamOldThreshHist(:,cnt) =  histogram(anDataAll.NpDiamOldThresh{cnt}...
            (anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt),histBorder)';
        
        anDataAll.NimEquivDiaOldSizesHist(:,cnt) =  histogram(anDataAll.NimEquivDiaOldSizes{cnt}...
            (anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt),histBorder)';
        anDataAll.NimEquivDiaHist(:,cnt) =  histogram(anDataAll.NimEquivDia{cnt}...
            (anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt),histBorder)';
        
        anDataAll.NpDiamMeanHist(:,cnt) =  histogram(anDataAll.NpDiamMean{cnt}...
            (anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt),histBorder)';
        anDataAll.NimDiamMeanHist(:,cnt) =  histogram(anDataAll.NimDiamMean{cnt}...
            (anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt),histBorder)';
        anDataAll.NimDiamMeanHistOldSizes(:,cnt) =  histogram(anDataAll.NimDiamMeanOldSizes{cnt}...
            (anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt),histBorder)';
        
        anDataAll.NpDiamOldSizesCount(cnt) = sum(isfinite(anDataAll.NpDiamOldSizes{cnt}...
            (anDataAll.partIsReal{cnt})));
        anDataAll.NpDiamCount(cnt) = sum(isfinite(anDataAll.NpDiam{cnt}...
            (anDataAll.partIsReal{cnt})));
        anDataAll.NpDiamOldSizesOldThreshCount(cnt) = sum(isfinite(anDataAll.NpDiamOldSizesOldThresh{cnt}...
            (anDataAll.partIsReal{cnt})));
        anDataAll.NpDiamOldThreshCount(cnt) = sum(isfinite(anDataAll.NpDiamOldThresh{cnt}...
            (anDataAll.partIsReal{cnt})));
        
        anDataAll.NimEquivDiaOldSizesCount(cnt) = sum(isfinite(anDataAll.NimEquivDiaOldSizes{cnt}...
            (anDataAll.partIsReal{cnt})));
        anDataAll.NimEquivDiaCount(cnt) = sum(isfinite(anDataAll.NimEquivDia{cnt}...
            (anDataAll.partIsReal{cnt})));
        
        anDataAll.NpDiamMeanCount(cnt) = sum(isfinite(anDataAll.NpDiamMean{cnt}...
            (anDataAll.partIsReal{cnt})));
        anDataAll.NimDiamMeanCount(cnt) = sum(isfinite(anDataAll.NimDiamMean{cnt}...
            (anDataAll.partIsReal{cnt})));
         anDataAll.NimDiamMeanOldSizesCount(cnt) = sum(isfinite(anDataAll.NimDiamMeanOldSizes{cnt}...
            (anDataAll.partIsReal{cnt})));
        
        %new end
        
        anDataAll.meanD(cnt)   = nanmean(dataAll{cnt}.pStats.pDiamOldSizesOldThresh...
            (dataAll{cnt}.pStats.partIsReal & dataAll{cnt}.pStats.pDiamOldSizesOldThresh > anParameter.lowSize*1e-6 &...
            dataAll{cnt}.pStats.pDiamOldSizesOldThresh < anParameter.maxSize*1e-6));
        anDataAll.totalCount(cnt) = nansum(dataAll{cnt}.pStats.partIsReal & dataAll{cnt}.pStats.pDiamOldSizesOldThresh > anParameter.lowSize*1e-6 &...
            dataAll{cnt}.pStats.pDiamOldSizesOldThresh < anParameter.maxSize*1e-6);
        
        anDataAll.isInVolume{cnt} = dataAll{cnt}.pStats.isInVolume;
        anDataAll.isBorder{cnt} = dataAll{cnt}.pStats.isBorder;
        anDataAll.partIsReal{cnt} = dataAll{cnt}.pStats.partIsReal;
        anDataAll.partIsRealAll{cnt} = dataAll{cnt}.pStats.partIsRealAll;
        
        anDataAll.predictedClass{cnt} = dataAll{cnt}.pStats.predictedHClass;
        %%%old
%         anDataAll.pDiam{cnt} = dataAll{cnt}.pStats.pDiamOldSizesOldThresh;
%         anDataAll.pDiamMean{cnt} = dataAll{cnt}.pStats.pDiamMean;
%         anDataAll.pDiamOldSizes{cnt} = dataAll{cnt}.pStats.pDiamOldSizesOldThresh;
%         anDataAll.pDiamOldThresh{cnt} = dataAll{cnt}.pStats.pDiamOldSizesOldThresh;
%         anDataAll.imEquivDiaOldSizes{cnt} = dataAll{cnt}.pStats.imEquivDiaOldSizes;
        %%%old-end
        
        %%%new
        anDataAll.pDiam{cnt} = dataAll{cnt}.pStats.imEquivDiaOldSizes;
        anDataAll.pDiamMean{cnt} = dataAll{cnt}.pStats.pDiamMean;
        
        anDataAll.pDiamOldThresh{cnt} = dataAll{cnt}.pStats.pDiamOldThresh;
        anDataAll.pDiamOldSizes{cnt} = dataAll{cnt}.pStats.pDiamOldSizes;
        anDataAll.pDiamOldSizesOldThresh{cnt} = dataAll{cnt}.pStats.pDiamOldSizesOldThresh;
        
        anDataAll.pDiamOMean{cnt} = dataAll{cnt}.pStats.pDiamMean;
        anDataAll.imDiamMean{cnt} = dataAll{cnt}.pStats.imDiamMean;
        anDataAll.imDiamMeanOldSizes{cnt} = dataAll{cnt}.pStats.imDiamMeanOldSizes;
        
        anDataAll.imEquivDia{cnt} = dataAll{cnt}.pStats.imEquivDia;        
        anDataAll.imEquivDiaOldSizes{cnt} = dataAll{cnt}.pStats.imEquivDiaOldSizes;
        
        anDataAll.rtDp{cnt} = dataAll{cnt}.pStats.rtDp;
        anDataAll.imMeanRadii{cnt} = dataAll{cnt}.pStats.imMeanRadii;
        %%%new-end
        
        
        anDataAll.xPos{cnt} = dataAll{cnt}.pStats.xPos;
        anDataAll.yPos{cnt} = dataAll{cnt}.pStats.yPos;
        anDataAll.zPos{cnt} = dataAll{cnt}.pStats.zPos;
 
        
        
        
        anDataAll.partIsWater{cnt} = anDataAll.partIsReal{cnt} & ...
            ismember(anDataAll.predictedClass{cnt},'Water');
        anDataAll.partIsIce{cnt} = anDataAll.partIsReal{cnt} & ...
            ismember(anDataAll.predictedClass{cnt},'Ice');
        anDataAll.partIsArtefact{cnt} = ~anDataAll.partIsReal{cnt};
        
        anDataAll.realInd{cnt} = find(anDataAll.partIsReal{cnt});
%calculation of holograms
               
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
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt), anParameter.histBinBorder);
            [anDataAll.histRealOldSizes(:,cnt), ~, ~, anDataAll.limitOldSizes(:,cnt), anDataAll.histRealErrorOldSizes(:,cnt)] = ...
                histogram(anDataAll.pDiamOldSizes{cnt}(anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt), anParameter.histBinBorderOldSizes);
            anDataAll.histRealCor(:,cnt) = anDataAll.histReal(:,cnt);
            anDataAll.histRealCorOldSizes(:,cnt) = anDataAll.histRealOldSizes(:,cnt);
            anDataAll.histRealErrorCor(:,cnt) =  anDataAll.histRealError(:,cnt);
            anDataAll.histRealErrorCorOld(:,cnt) = anDataAll.histRealErrorOldSizes(:,cnt);
            anDataAll.histRealCount(:,cnt) =  histc(anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt})*1e6, anParameter.histBinBorder(1:end-1))';
            anDataAll.histRealCountCor(:,cnt) = anDataAll.histRealCount(:,cnt)';
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
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsWater{cnt})*1e6, anDataAll.sample.VolumeReal(cnt), anParameter.histBinBorder);
            anDataAll.water.histRealCor(:,cnt) = anDataAll.water.histReal(:,cnt);
            anDataAll.water.histRealErrorCor(:,cnt) =  anDataAll.water.histRealError(:,cnt);
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
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsIce{cnt})*1e6, anDataAll.sample.VolumeReal(cnt), anParameter.histBinBorder);
            anDataAll.ice.histRealCor(:,cnt) = anDataAll.ice.histReal(:,cnt);
            anDataAll.ice.histRealErrorCor(:,cnt) =  anDataAll.ice.histRealError(:,cnt);
        end
        
        if isempty(anDataAll.pDiam{cnt}(anDataAll.partIsArtefact{cnt}))
            tmp = zeros(numel(anParameter.histBinMiddle),1);
            anDataAll.artefact.histReal(:,cnt)=tmp;
            anDataAll.artefact.limit(:,cnt)=tmp;
            anDataAll.artefact.histRealError(:,cnt)=tmp;
            anDataAll.artefact.histRealCor(:,cnt)=tmp;
            anDataAll.artefact.histRealErrorCor(:,cnt)=tmp;
        else
            [anDataAll.artefact.histReal(:,cnt), ~, ~, anDataAll.artefact.limit(:,cnt), anDataAll.artefact.histRealError(:,cnt)] = ...
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsArtefact{cnt})*1e6, anDataAll.sample.VolumeReal(cnt), anParameter.histBinBorder);
            anDataAll.artefact.histRealCor(:,cnt) = anDataAll.artefact.histReal(:,cnt);
            anDataAll.artefact.histRealErrorCor(:,cnt) =  anDataAll.artefact.histRealError(:,cnt);
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
        corr = 1%Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt});
        
        anDataAll.TWMeanDRaw(cnt) = nanmean(parDiam);
        if isnan(anDataAll.TWMeanDRaw(cnt))
            anDataAll.TWMeanD(cnt) = nan;
        else
            anDataAll.TWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*hist./corr/nansum(hist./corr));
        end
        anDataAll.TWCountRaw(cnt) = nansum(hist);
        anDataAll.TWCount(cnt) = nansum(hist./corr);
        anDataAll.TWConcentraction(cnt) = anDataAll.TWCount(cnt)/ anDataAll.sample.VolumeReal(cnt)*1e-6;
         
        anDataAll.TWCountRaw2(cnt) = nansum(hist2);
        anDataAll.TWCount2(cnt) = nansum(hist2./corr);
        anDataAll.TWConcentraction2(cnt) = anDataAll.TWCount2(cnt)/ anDataAll.sample.VolumeReal(cnt)*1e-6;
        
        %         if isnan(anDataAll.TWConcentraction(cnt))
        %             anDataAll.TWConcentraction(cnt) = 0;
        %         end
        anDataAll.TWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        anDataAll.TWContentRaw2(cnt)     = nansum(1/6*pi.*parDiam2.^3)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        %         if isnan(anDataAll.TWContentRaw(cnt))
        %             anDataAll.TWContentRaw(cnt) = 0;
        %         end
        anDataAll.TWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        anDataAll.TWContent2(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist2./corr)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        %         if isnan(anDataAll.TWContent(cnt))
        %             anDataAll.TWContent(cnt)  = 0;
        %         end
        
        clear parDiam
        clear parDiam2
        clear hist
        clear hist2
        clear corr
        
        %Ice Water calculations
        %         parDiam = anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt} ...
        %             & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 ...
        %             & anDataAll.pDiam{cnt} > anParameter.divideSize*1e-6);
        parDiam = anDataAll.pDiam{cnt}(anDataAll.partIsIce{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
            anDataAll.pDiam{cnt} < anParameter.maxSize*1e-6);
        parDiam2 = anDataAll.pDiam{cnt}(anDataAll.partIsIce{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
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
        corr = 1;%Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt});
        
        anDataAll.IWMeanDRaw(cnt) = nanmean(parDiam);
        if isnan(anDataAll.IWMeanDRaw(cnt))
            anDataAll.IWMeanD(cnt) = nan;
        else
            anDataAll.IWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*hist./corr/nansum(hist./corr));
        end
        anDataAll.IWCountRaw(cnt) = nansum(hist);
        anDataAll.IWCount(cnt) = nansum(hist./corr);
        anDataAll.IWConcentraction(cnt) = anDataAll.IWCount(cnt)/ anDataAll.sample.VolumeReal(cnt)*1e-6;
        
        anDataAll.IWCountRaw2(cnt) = nansum(hist2);
        anDataAll.IWCount2(cnt) = nansum(hist2./corr);
        anDataAll.IWConcentraction2(cnt) = anDataAll.IWCount2(cnt)/ anDataAll.sample.VolumeReal(cnt)*1e-6;
        
        %         if isnan(anDataAll.IWConcentraction(cnt))
        %             anDataAll.IWConcentraction(cnt) = 0;
        %         end
        anDataAll.IWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        anDataAll.IWContentRaw2(cnt)     = nansum(1/6*pi.*parDiam2.^3)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        %         if isnan(anDataAll.IWContentRaw(cnt))
        %             anDataAll.IWContentRaw(cnt) = 0;
        %         end
        anDataAll.IWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        anDataAll.IWContent2(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist2./corr)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        %         if isnan(anDataAll.IWContent(cnt))
        %             anDataAll.IWContent(cnt)  = 0;
        %         end
        clear parDiam
        clear parDaim2
        clear hist
        clear hist2
        clear corr
        
        %Liquid Water calculations
        %         parDiam = anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt} ...
        %             & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 ...
        %             & anDataAll.pDiam{cnt} <= anParameter.divideSize*1e-6);
        parDiam = anDataAll.pDiam{cnt}(anDataAll.partIsWater{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
            anDataAll.pDiam{cnt} < anParameter.maxSize*1e-6);
        parDiam2 = anDataAll.pDiam{cnt}(anDataAll.partIsWater{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
            anDataAll.pDiam{cnt} < 50*1e-6);
        if isempty(parDiam)
            hist = zeros(1,numel(anParameter.histBinMiddle));
            hist2 = zeros(1,numel(anParameter.histBinMiddle));
        else
            hist = histc(parDiam, anParameter.histBinBorder*1e-6);
            hist = hist(1:end-1);
            hist2 = histc(parDiam2, anParameter.histBinBorder*1e-6);
            hist2 = hist2(1:end-1);
        end
        corr = 1;%Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt});
        
        anDataAll.LWMeanDRaw(cnt) = nanmean(parDiam);
        if isnan(anDataAll.LWMeanDRaw(cnt))
            anDataAll.LWMeanD(cnt) = nan;
        else
            anDataAll.LWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*hist./corr/nansum(hist./corr));
        end
        anDataAll.LWCountRaw(cnt) = nansum(hist);
        anDataAll.LWCount(cnt) = nansum(hist./corr);
        anDataAll.LWConcentraction(cnt) = anDataAll.LWCount(cnt)/ anDataAll.sample.VolumeReal(cnt)*1e-6;
        
        anDataAll.LWCountRaw2(cnt) = nansum(hist2);
        anDataAll.LWCount2(cnt) = nansum(hist2./corr);
        anDataAll.LWConcentraction2(cnt) = anDataAll.LWCount2(cnt)/ anDataAll.sample.VolumeReal(cnt)*1e-6;
        
        %         if isnan(anDataAll.LWConcentraction(cnt))
        %             anDataAll.LWConcentraction(cnt) = 0;
        %         end
        anDataAll.LWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        anDataAll.LWContentRaw2(cnt)     = nansum(1/6*pi.*parDiam2.^3)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        %         if isnan(anDataAll.LWContentRaw(cnt))
        %             anDataAll.LWContentRaw(cnt) = 0;
        %         end
        anDataAll.LWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        
        anDataAll.LWContent2(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist2./corr)...
            / anDataAll.sample.VolumeReal(cnt)*1e6;
        %         if isnan(anDataAll.LWContent(cnt))
        %             anDataAll.LWContent(cnt)  = 0;
        %         end
        clear parDiam
        clear hist
        clear corr
    end
end

