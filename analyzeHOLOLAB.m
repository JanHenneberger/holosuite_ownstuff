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
anParameter.lowSize = 6;
anParameter.maxSize = 250;
anParameter.divideSize = 34;

%length of intervall [s]
anParameter.intervallVec = [1 0 0 0 0 1];
anParameter.intervall = datenum(anParameter.intervallVec);

%find as-files information
anParameter.ParInfoFolder = 'D:\HOLOLAB';
%anParameter.ParInfoFolder = 'D:\TestCase2014\ParticleStats';
%anParameter.ParInfoFolder = 'F:\ParticleStatsWS\CLACE2013-10-as\';
%anParameter.ParInfoFolder = 'F:\CLACE2013\All\asFiles\';
%anParameter.ParInfoFolder = 'F:\CLACE2013\Background\';

cd(anParameter.ParInfoFolder);
anParameter.asSearch = '';
anParameter.ParInfoFiles = dir(['H-' anParameter.asSearch '*_as.mat']);
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
    dataAll.pStats = predictClass(dataAll.pStats);
    
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

%Sonic data input
if ~exist('dataSonic','var');
    dataSonic = inputSonicData('F:\CLACE2013\Labview');
end

%Manchester data input
if ~exist('dataManchester', 'var');
    dataManchester.cdp = load(fullfile('F:\CLACE2013\Manchester','cdp10secs'));
    dataManchester.cdp = dataManchester.cdp.cdp;
    dataManchester.pvm = load(fullfile('F:\CLACE2013\Manchester','pvm10secs'));
    dataManchester.pvm = dataManchester.pvm.pvm;
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
        anDataAll.partIsIce{cnt} = anDataAll.partIsReal{cnt} & ...
            ismember(anDataAll.predictedClass{cnt},'Ice');
        anDataAll.partIsArtefact{cnt} = ~anDataAll.partIsReal{cnt};
        
        anDataAll.sample{cnt}.NumberReal = anDataAll.sample{cnt}.Number - numel(anDataAll.blackListInd{cnt});
        anDataAll.sample{cnt}.VolumeReal   = dataAll.sample.VolumeHolo * anDataAll.sample{cnt}.NumberReal;
        anDataAll.realInd{cnt} = find(anDataAll.partIsReal{cnt});
    end
end

% %Find Sonic Date Indices for Measurements Periods
% if ~isfield('anDataAll','measMeanV');
%     for cnt = 1:numel(anDataAll.timeStart)
%         anDataAll.sonicIndice{cnt} = [find(dataSonic.Date_Num> anDataAll.timeStart(cnt),1,'first') ...
%             find(dataSonic.Date_Num> anDataAll.timeEnd(cnt),1,'first')];
%         [anDataAll.measMeanV(cnt), anDataAll.measStdV(cnt)] = ...
%             mean_data(dataSonic.V_total,anDataAll.sonicIndice{cnt});
%         [anDataAll.measMeanVAzimut(cnt), anDataAll.measStdVAzimut(cnt)] = ...
%             mean_data(dataSonic.V_azimut,anDataAll.sonicIndice{cnt});
%         [anDataAll.measMeanT(cnt), anDataAll.measStdT(cnt)] = ...
%             mean_data(dataSonic.T_acoustic,anDataAll.sonicIndice{cnt});
%         [anDataAll.measMeanFlow(cnt), anDataAll.measStdFlow(cnt)] = ...
%             mean_data(dataSonic.Flowmeter_massflow,anDataAll.sonicIndice{cnt});
%         [anDataAll.meanElevSonic(cnt), anDataAll.stdElevSonic(cnt)] = ...
%             mean_data(dataSonic.WD_elevation,anDataAll.sonicIndice{cnt});
%         [anDataAll.meanElevRotor(cnt), anDataAll.stdElevRotor(cnt)] = ...
%             mean_data(dataSonic.WD_rotor_elevation,anDataAll.sonicIndice{cnt});
%         meanx = mean_data(dataSonic.Mean_Vx,anDataAll.sonicIndice{cnt});
%         meany = mean_data(dataSonic.Mean_Vy,anDataAll.sonicIndice{cnt});
%         anDataAll.measMeanAzimutSonic(cnt) = conWindXY2Deg(meanx, meany);
%         clear meanx
%         clear meany
%         %% Rotor not on in CLACE 2013
%         %     meanroty = mean_data(-cosd(dataSonic.WD_rotor_azimut_sonic),anDataAll.sonicIndice{cnt});
%         %     meanrotx = mean_data(-sind(dataSonic.WD_rotor_azimut_sonic),anDataAll.sonicIndice{cnt});
%         %     anDataAll{cnt}.measMeanAzimutRotor = conWindXY2Deg(meanrotx, meanroty);
%         %     clear meanroty
%         %     clear meanrotx
%         %     diff_azimut = min([abs(dataSonic.WD_azimut-dataSonic.WD_rotor_azimut_sonic) ...
%         %         abs(abs(dataSonic.WD_azimut-dataSonic.WD_rotor_azimut_sonic)-360)],[],2);
%         %     anDataAll{cnt}.measMeanDiffAzimutSingle = mean_data(diff_azimut,anDataAll.sonicIndice{cnt});
%         %     anDataAll{cnt}.measMeanDiffAzimutMean = ...
%         %         abs( anDataAll{cnt}.measMeanAzimutSonic-anDataAll{cnt}.measMeanAzimutRotor);
%     end
% end
% %Find Manchester Date Indices for Measurements Periods
% if ~isfield('anDataAll','cdpMean');
%     for cnt = 1:numel(anDataAll.timeStart)
%         anDataAll.cdpIndice{cnt} = [find(dataManchester.cdp.dateNum> anDataAll.timeStart(cnt),1,'first') ...
%             find(dataManchester.cdp.dateNum> anDataAll.timeEnd(cnt),1,'first')];
%         anDataAll.pvmIndice{cnt} = [find(dataManchester.pvm.dateNum> anDataAll.timeStart(cnt),1,'first') ...
%             find(dataManchester.pvm.dateNum> anDataAll.timeEnd(cnt),1,'first')];
%         anDataAll.cdpMean(cnt) = nanmean(dataManchester.cdp.data(anDataAll.cdpIndice{cnt}));
%         anDataAll.cdpStd(cnt)  =  nanstd(dataManchester.cdp.data(anDataAll.cdpIndice{cnt}));
%         anDataAll.pvmMean(cnt) = nanmean(dataManchester.pvm.data(anDataAll.pvmIndice{cnt}));
%         anDataAll.pvmStd(cnt)  =  nanstd(dataManchester.pvm.data(anDataAll.pvmIndice{cnt}));
%     end
% end

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
            anDataAll.histRealCor(:,cnt) = anDataAll.histReal(:,cnt);
            anDataAll.histRealCorOldSizes(:,cnt) = anDataAll.histRealOldSizes(:,cnt);
            anDataAll.histRealErrorCor(:,cnt) =  anDataAll.histRealError(:,cnt);
            anDataAll.histRealErrorCorOld(:,cnt) = anDataAll.histRealErrorOldSizes(:,cnt);
            anDataAll.histRealCount(:,cnt) =  histc(anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt})*1e6, anParameter.histBinBorder(1:end-1))';
            anDataAll.histRealCountCor(:,cnt) = anDataAll.histRealCount(:,cnt);
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
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsIce{cnt})*1e6, anDataAll.sample{cnt}.VolumeAll, anParameter.histBinBorder);
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
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsArtefact{cnt})*1e6, anDataAll.sample{cnt}.VolumeAll, anParameter.histBinBorder);
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
        corr =1;
        
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
        %         if isnan(anDataAll.IWConcentraction(cnt))
        %             anDataAll.IWConcentraction(cnt) = 0;
        %         end
        anDataAll.IWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        anDataAll.IWContentRaw2(cnt)     = nansum(1/6*pi.*parDiam2.^3)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        %         if isnan(anDataAll.IWContentRaw(cnt))
        %             anDataAll.IWContentRaw(cnt) = 0;
        %         end
        anDataAll.IWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        anDataAll.IWContent2(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist2./corr)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
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
        %         if isnan(anDataAll.LWConcentraction(cnt))
        %             anDataAll.LWConcentraction(cnt) = 0;
        %         end
        anDataAll.LWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        anDataAll.LWContentRaw2(cnt)     = nansum(1/6*pi.*parDiam2.^3)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        %         if isnan(anDataAll.LWContentRaw(cnt))
        %             anDataAll.LWContentRaw(cnt) = 0;
        %         end
        anDataAll.LWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        
        anDataAll.LWContent2(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist2./corr)...
            / anDataAll.sample{cnt}.VolumeReal*1e6;
        %         if isnan(anDataAll.LWContent(cnt))
        %             anDataAll.LWContent(cnt)  = 0;
        %         end
        clear parDiam
        clear hist
        clear corr
    end
end

%writeData
anDataAll.Parameter = anParameter;
save(['AllN2CLACE2013_' num2str(anParameter.intervallVec(6)) 'secStat.mat'],'anDataAll');