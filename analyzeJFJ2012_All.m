
anParameter.asSearch = '';

anParameter.intervallVec = [0 0 0 0 0 100];
anParameter.intervall = datenum(anParameter.intervallVec);

anParameter.lowSize = 6;
anParameter.maxSize = 250;
anParameter.divideSize = 34;

% anParameter.ParInfoFolder = 'Z:\5_ParticleStats\JFJ2012-15-as-new';
anParameter.ParInfoFolder = 'Z:\5_ParticleStats\JFJ2012-5-as';
cd(anParameter.ParInfoFolder);
anParameter.ParInfoFiles = dir([anParameter.asSearch '*_as.mat']);
anParameter.ParInfoFiles = {anParameter.ParInfoFiles.name};

anParameter.cfg = config(fullfile(anParameter.ParInfoFolder, 'holoviewer.cfg'));
[anParameter.histBinBorder, anParameter.histBinSizes, anParameter.histBinMiddle] ...
    = getHistBorder(anParameter.divideSize, anParameter.maxSize, anParameter.cfg, 1);
[anParameter.histBinBorderOldSizes, anParameter.histBinSizesOldSizes, anParameter.histBinMiddleOldSizes] ...
    = getHistBorder(anParameter.divideSize, anParameter.maxSize, anParameter.cfg, 0);

%Holo Data input
if ~exist('dataAll','var');     
    %load the file and merge them together
    for cnt = 1:numel(anParameter.ParInfoFiles)
        fprintf('Merge Particle Statistik File: %04u / %04u\n',cnt, numel(anParameter.ParInfoFiles) );
        temp = load(anParameter.ParInfoFiles{cnt});
        temp = temp.outFile;
        
        %Correct Time for short file names
        for cnt2 = 1:numel(temp.pStats.dateNumPar)
            if temp.pStats.dateNumPar(cnt2) < 4e5
                timeStamp = anParameter.ParInfoFiles{cnt}(3:end-4);
                timeStamp = regexprep(timeStamp, '\.' , '-');
                timeStamp = textscan(timeStamp, '%u','delimiter','-');
                timeStamp =double(timeStamp{1}(1:3));
                timeStamp = timeStamp';
                temp.pStats.dateNumPar(cnt2) = datenum([timeStamp 0 0 temp.pStats.dateNumPar(cnt2)]);
            end
        end
        %Correct Time for short file names
        for cnt2 = 1:numel(temp.dateNumHolo)
            if temp.dateNumHolo(cnt2) < 4e5
                timeStamp = anParameter.ParInfoFiles{cnt}(3:end-4);
                timeStamp = regexprep(timeStamp, '\.' , '-');
                timeStamp = textscan(timeStamp, '%u','delimiter','-');
                timeStamp =double(timeStamp{1}(1:3));
                timeStamp = timeStamp';
                temp.dateNumHolo(cnt2) = datenum([timeStamp 0 0 temp.dateNumHolo(cnt2)]);
            end
        end
        temp.dateVecHolo = datevec(temp.dateNumHolo)';
        
        if  isfield(temp, 'pStats') && sum(~isnan(temp.pStats.zPos))
            if ~exist('dataAll','var')
                cntOutFile = 1;
                
                dataAll = temp;
                
                dataAll.folderPSFile = {dataAll.folderPSFile} ;
                copyFields              = fieldnames(dataAll.pStats);
                
                dataAll.pStats.nHoloAllAll = dataAll.pStats.nHoloAll;
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
 
     dataAll.pStats.isBorderOld2 = logical(dataAll.pStats.isBorder);
     dataAll.pStats.isBorder = logical(isBorderParticle2(dataAll.pStats.xPos, ...
            dataAll.pStats.yPos, dataAll.pStats.zPos, dataAll.zs ,dataAll.Nx, dataAll.Ny,...
            dataAll.dx, dataAll.dy, dataAll.dz));
    
   %first calculations
   dataAll.pStats.partIsRealAll = dataAll.pStats.isInVolume & ...
       ~dataAll.pStats.isBorder & ...
       ~ismember(dataAll.pStats.predictedHClass,'Artefact');
  dataAll.pStats.partIsReal = dataAll.pStats.partIsRealAll & ...
       ~dataAll.pStats.partIsOnBlackList;
    dataAll.meanD   = nanmean(dataAll.pStats.imEquivDiaOldSizes(dataAll.pStats.partIsReal & ...
        dataAll.pStats.pDiamOldSizesOldThresh > anParameter.lowSize*1e-6 &...
        dataAll.pStats.pDiamOldSizesOldThresh < anParameter.maxSize*1e-6));
    dataAll.totalCount = nansum(dataAll.pStats.partIsReal & ...
        dataAll.pStats.pDiamOldSizesOldThresh > anParameter.lowSize*1e-6 &...
        dataAll.pStats.pDiamOldSizesOldThresh < anParameter.maxSize*1e-6);
end

%Sonic data input
if ~exist('dataSonic','var');
    dataSonic = inputSonicData('Z:\3_Data\JFJ2012\Labview');
    %Correction for wrongly calibrated MassflowMeter
    dataSonic.Flowmeter_massflow = dataSonic.Flowmeter_massflow/2;
end

% %Manchester data input
% if ~exist('dataManchester', 'var');    
%     dataManchester.cdp = load(fullfile('E:\CLACE2013\Manchester','cdp10secs'));
%     dataManchester.cdp = dataManchester.cdp.cdp;
%     dataManchester.pvm = load(fullfile('E:\CLACE2013\Manchester','pvm10secs'));
%     dataManchester.pvm = dataManchester.pvm.pvm;
% end

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
%             tmp2 = find(dataAll.dateNumHolo > time+anParameter.intervall,1,'first');
%             time = dataAll.dateNumHolo(tmp2);
            time = time + anParameter.intervall;
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
        
        anDataAll.meanD(cnt)   = nanmean(dataAll.pStats.imEquivDiaOldSizes(tmp & dataAll.pStats.partIsReal & dataAll.pStats.imEquivDiaOldSizes > anParameter.lowSize*1e-6 &...
        dataAll.pStats.imEquivDiaOldSizes < anParameter.maxSize*1e-6));
        anDataAll.totalCount(cnt) = nansum(tmp & dataAll.pStats.partIsReal & dataAll.pStats.imEquivDiaOldSizes > anParameter.lowSize*1e-6 &...
        dataAll.pStats.imEquivDiaOldSizes < anParameter.maxSize*1e-6);
        
        anDataAll.isInVolume{cnt} = dataAll.pStats.isInVolume(tmp);
        anDataAll.isBorder{cnt} = dataAll.pStats.isBorder(tmp);
        anDataAll.partIsReal{cnt} = dataAll.pStats.partIsReal(tmp);
        anDataAll.partIsRealAll{cnt} = dataAll.pStats.partIsRealAll(tmp);
        
        anDataAll.predictedClass{cnt} = dataAll.pStats.predictedHClass(tmp);
        
        
        
        %2014/10/13 change the particle sizing from pDiamOldSizesOldThresh
        %to imEquivDiaOldSizes
        
        %         %old-start
        %         anDataAll.pDiam{cnt} = dataAll.pStats.pDiamOldSizesOldThresh(tmp);
        %         anDataAll.pDiamMean{cnt} = dataAll.pStats.pDiamMean(tmp);
        %         anDataAll.pDiamOldSizes{cnt} = dataAll.pStats.pDiamOldSizesOldThresh(tmp);
        %         anDataAll.pDiamOldThresh{cnt} = dataAll.pStats.pDiamOldSizesOldThresh(tmp);
        %         anDataAll.imEquivDiaOldSizes{cnt} = dataAll.pStats.imEquivDiaOldSizes(tmp);
        %         %old-end
        
        %new-start
        anDataAll.pDiam{cnt} = dataAll.pStats.imEquivDiaOldSizes(tmp);
        anDataAll.pDiamMean{cnt} = dataAll.pStats.pDiamMean(tmp);
        
        anDataAll.pDiamOldThresh{cnt} = dataAll.pStats.pDiamOldThresh(tmp);
        anDataAll.pDiamOldSizes{cnt} = dataAll.pStats.pDiamOldSizes(tmp);
        anDataAll.pDiamOldSizesOldThresh{cnt} = dataAll.pStats.pDiamOldSizesOldThresh(tmp);
        
        anDataAll.pDiamOMean{cnt} = dataAll.pStats.pDiamMean(tmp);
        anDataAll.imDiamMean{cnt} = dataAll.pStats.imDiamMean(tmp);
        anDataAll.imDiamMeanOldSizes{cnt} = dataAll.pStats.imDiamMeanOldSizes(tmp);
        
        anDataAll.imEquivDia{cnt} = dataAll.pStats.imEquivDia(tmp);
        anDataAll.imEquivDiaOldSizes{cnt} = dataAll.pStats.imEquivDiaOldSizes(tmp);
        
        anDataAll.rtDp{cnt} = dataAll.pStats.rtDp(tmp);
        anDataAll.imMeanRadii{cnt} = dataAll.pStats.imMeanRadii(tmp);
        anDataAll.majorAxisLength{cnt} = dataAll.pStats.imEquivDiaOldSizes(tmp)...
            ./((1-dataAll.pStats.imEccentricity(tmp).^2).^(1/4)); 
        %new-end
        
        anDataAll.xPos{cnt} = dataAll.pStats.xPos(tmp);
        anDataAll.yPos{cnt} = dataAll.pStats.yPos(tmp);
        anDataAll.zPos{cnt} = dataAll.pStats.zPos(tmp);
        
        anDataAll.indHoloAll{cnt} = dataAll.pStats.nHoloAllAll(tmp);
        anDataAll.indHolo{cnt} = anDataAll.indHoloAll{cnt} - anDataAll.indHoloAll{cnt}(1)+1;
        
        anDataAll.sample.VolumeHolo       = dataAll.sample.VolumeHolo;
        anDataAll.sample.Number(cnt)      = anDataAll.indHolo{cnt}(end) - anDataAll.indHolo{cnt}(1);
        anDataAll.sample.VolumeAll(cnt)   = dataAll.sample.VolumeHolo * anDataAll.sample.Number(cnt) ;
        
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
        
        anDataAll.sample.NumberReal(cnt) = anDataAll.sample.Number(cnt) - numel(anDataAll.blackListInd{cnt});
        anDataAll.sample.VolumeReal(cnt)   = dataAll.sample.VolumeHolo * anDataAll.sample.NumberReal(cnt);
        anDataAll.realInd{cnt} = find(anDataAll.partIsReal{cnt});
    end
end

%Find Sonic Date Indices for Measurements Periods
if ~isfield('anDataAll','measMeanV');
    for cnt = 1:numel(anDataAll.timeStart)
        anDataAll.sonicIndice{cnt} = [find(dataSonic.Date_Num> anDataAll.timeStart(cnt),1,'first') ...
            find(dataSonic.Date_Num> anDataAll.timeEnd(cnt),1,'first')];
        [anDataAll.measMeanV(cnt), anDataAll.measStdV(cnt)] = ...
            mean_data(dataSonic.V_total,anDataAll.sonicIndice{cnt});        
        [anDataAll.measMeanVAzimut(cnt), anDataAll.measStdVAzimut(cnt)] = ...
            mean_data(dataSonic.V_azimut,anDataAll.sonicIndice{cnt});        
        [anDataAll.measMeanT(cnt), anDataAll.measStdT(cnt)] = ...
            mean_data(dataSonic.T_acoustic,anDataAll.sonicIndice{cnt});
        [anDataAll.measMeanFlow(cnt), anDataAll.measStdFlow(cnt)] = ...
            mean_data(dataSonic.Flowmeter_massflow,anDataAll.sonicIndice{cnt});
        [anDataAll.meanElevSonic(cnt), anDataAll.stdElevSonic(cnt)] = ...
            mean_data(dataSonic.WD_elevation,anDataAll.sonicIndice{cnt});
        [anDataAll.meanElevRotor(cnt), anDataAll.stdElevRotor(cnt)] = ...
            mean_data(dataSonic.WD_rotor_elevation,anDataAll.sonicIndice{cnt});
        meanx = mean_data(dataSonic.Mean_Vx,anDataAll.sonicIndice{cnt});
        meany = mean_data(dataSonic.Mean_Vy,anDataAll.sonicIndice{cnt});
        anDataAll.measMeanAzimutSonic(cnt) = conWindXY2Deg(meanx, meany);
        clear meanx
        clear meany
        
            meanroty = mean_data(-cosd(dataSonic.WD_rotor_azimut_sonic),anDataAll.sonicIndice{cnt});
            meanrotx = mean_data(-sind(dataSonic.WD_rotor_azimut_sonic),anDataAll.sonicIndice{cnt});
            anDataAll.measMeanAzimutRotor(cnt) = conWindXY2Deg(meanrotx, meanroty);
            clear meanroty
            clear meanrotx
            diff_azimut = min([abs(dataSonic.WD_azimut-dataSonic.WD_rotor_azimut_sonic) ...
                abs(abs(dataSonic.WD_azimut-dataSonic.WD_rotor_azimut_sonic)-360)],[],2);
            anDataAll.measMeanDiffAzimutSingle(cnt) = mean_data(diff_azimut,anDataAll.sonicIndice{cnt});
            anDataAll.measMeanDiffAzimutMean(cnt) = ...
                abs( anDataAll.measMeanAzimutSonic(cnt)-anDataAll.measMeanAzimutRotor(cnt));
    end
end
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
        
        anDataAll.constInletCorr{cnt}.pressure      = 656;    %[hPa]
        anDataAll.constInletCorr{cnt}.temperature   = 273.15 + anDataAll.measMeanT(cnt); %[K]
        anDataAll.constInletCorr{cnt}.massflow      = anDataAll.measMeanFlow(cnt);  %[l/min]
        anDataAll.constInletCorr{cnt}.dPipe         = 0.05;    %[m]
        anDataAll.constInletCorr{cnt}.windSpeed     = anDataAll.measMeanV(cnt);
        
        
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
                histogram(anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt), anParameter.histBinBorder);
            [anDataAll.histRealOldSizes(:,cnt), ~, ~, anDataAll.limitOldSizes(:,cnt), anDataAll.histRealErrorOldSizes(:,cnt)] = ...
                histogram(anDataAll.pDiamOldSizes{cnt}(anDataAll.partIsReal{cnt})*1e6, anDataAll.sample.VolumeReal(cnt), anParameter.histBinBorderOldSizes);
            anDataAll.histRealCor(:,cnt) = anDataAll.histReal(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt})';
            anDataAll.histRealCorOldSizes(:,cnt) = anDataAll.histRealOldSizes(:,cnt)./Paik_inert(anParameter.histBinMiddleOldSizes*1e-6, anDataAll.constInletCorr{cnt})';
            anDataAll.histRealErrorCor(:,cnt) =  anDataAll.histRealError(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt})';
            anDataAll.histRealErrorCorOld(:,cnt) = anDataAll.histRealErrorOldSizes(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt})';
            anDataAll.histRealCount(:,cnt) =  histc(anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt})*1e6, anParameter.histBinBorder(1:end-1))';
            anDataAll.histRealCountCor(:,cnt) = anDataAll.histRealCount(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt})';
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
            anDataAll.water.histRealCor(:,cnt) = anDataAll.water.histReal(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt})';
            anDataAll.water.histRealErrorCor(:,cnt) =  anDataAll.water.histRealError(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt})';
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
            anDataAll.ice.histRealCor(:,cnt) = anDataAll.ice.histReal(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt})';
            anDataAll.ice.histRealErrorCor(:,cnt) =  anDataAll.ice.histRealError(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt})';
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
            anDataAll.artefact.histRealCor(:,cnt) = anDataAll.artefact.histReal(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt})';
            anDataAll.artefact.histRealErrorCor(:,cnt) =  anDataAll.artefact.histRealError(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt})';
        end
        
        
        %Ice Water calculations   
        indIce = anDataAll.partIsIce{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
            anDataAll.pDiam{cnt} < anParameter.maxSize*1e-6;
        parDiam = anDataAll.pDiam{cnt}(indIce);
        parMaxDia = anDataAll.majorAxisLength{cnt}(indIce);

        if isempty(parDiam)
            hist = zeros(1,numel(anParameter.histBinMiddle));            
        else
            hist = histc(parDiam, anParameter.histBinBorder*1e-6);
            hist = hist(1:end-1);
        end
        if isempty(parMaxDia)
            histMaxDia = zeros(1,numel(anParameter.histBinMiddle));
        else
            histMaxDia = histc(parMaxDia, anParameter.histBinBorder*1e-6);
            histMaxDia = histMaxDia(1:end-1);
        end
        corrConstIce = anDataAll.constInletCorr{cnt};
        corrConstIce.ice = 1;
        corr = Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt});
        corr_ice = Paik_inert(anParameter.histBinMiddle*1e-6, corrConstIce);
        
        anDataAll.IWMeanDRaw(cnt) = nanmean(parDiam);
        anDataAll.IWMeanMaxDRaw(cnt) = nanmean(parMaxDia);
        
        if isnan(anDataAll.IWMeanDRaw(cnt))
            anDataAll.IWMeanD(cnt) = nan;
        else
            anDataAll.IWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*...
                hist./corr/nansum(hist./corr));
        end
        if isnan(anDataAll.IWMeanMaxDRaw(cnt))
            anDataAll.IWMeanMaxD(cnt) = nan;
        else
            anDataAll.IWMeanMaxD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*...
                histMaxDia./corr_ice/nansum(histMaxDia./corr_ice));
        end
        
        anDataAll.IWCountRaw(cnt) = nansum(hist);
        anDataAll.IWCount(cnt) = nansum(hist./corr);
         anDataAll.IWConcentraction(cnt) = anDataAll.IWCount(cnt)/ anDataAll.sample.VolumeReal(cnt)*1e-6; 
 
        
        anDataAll.IWCountRawMaxDia(cnt) = nansum(histMaxDia);
        anDataAll.IWCountMaxDia(cnt) = nansum(histMaxDia./corr_ice);
        anDataAll.IWConcentractionMaxDia(cnt) = anDataAll.IWCountMaxDia(cnt)/ anDataAll.sample.VolumeReal(cnt)*1e-6;
        
        
       anDataAll.IWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
                / anDataAll.sample.VolumeReal(cnt)*1e6;
        anDataAll.IWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
                / anDataAll.sample.VolumeReal(cnt)*1e6;
        %new d-mass relation
        anDataAll.IWContentRawCotton(cnt) = nansum(mD_RelationCotton(parMaxDia))...
            / anDataAll.sample.VolumeReal(cnt)*1e3;
        anDataAll.IWContentCotton(cnt) = nansum(mD_RelationCotton(anParameter.histBinMiddle*1e-6).*histMaxDia./corr_ice)...
            / anDataAll.sample.VolumeReal(cnt)*1e3;
        %end new d-mass relation
        clear parDiam
        clear hist
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
        corr = Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt});
        
        anDataAll.LWMeanDRaw(cnt) = nanmean(parDiam);
        if isnan(anDataAll.LWMeanDRaw(cnt))
            anDataAll.LWMeanD(cnt) = nan;
        else
            anDataAll.LWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*hist./corr/nansum(hist./corr));
        end
        anDataAll.LWCountRaw(cnt) = nansum(hist);
        anDataAll.LWCount(cnt) = nansum(hist./corr);
        anDataAll.LWConcentraction(cnt) = anDataAll.LWCount(cnt)/ anDataAll.sample.VolumeReal(cnt)*1e-6;

        anDataAll.LWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
                / anDataAll.sample.VolumeReal(cnt)*1e6;

        anDataAll.LWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
                / anDataAll.sample.VolumeReal(cnt)*1e6;

        clear parDiam
        clear hist
        clear corr
  
%Total Water calculations
        %parDiam = anDataAll.pDiam{cnt}(anDataAll.partIsReal{cnt} & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6);
        parDiam = anDataAll.pDiam{cnt}((anDataAll.partIsIce{cnt} | anDataAll.partIsWater{cnt}) & anDataAll.pDiam{cnt} > anParameter.lowSize*1e-6 &...
        anDataAll.pDiam{cnt} < anParameter.maxSize*1e-6);
        if isempty(parDiam)
            hist = zeros(1,numel(anParameter.histBinMiddle));            
        else
            hist = histc(parDiam, anParameter.histBinBorder*1e-6);
            hist = hist(1:end-1);
        end   
        corr = Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll.constInletCorr{cnt});
        
        anDataAll.TWMeanDRaw(cnt) = nanmean(parDiam);
        if isnan(anDataAll.TWMeanDRaw(cnt))
            anDataAll.TWMeanD(cnt) = nan;
        else
            anDataAll.TWMeanD(cnt) = nansum(anParameter.histBinMiddle*1e-6.*hist./corr/nansum(hist./corr));
        end
        anDataAll.TWCountRaw(cnt) = nansum(hist);
        anDataAll.TWCount(cnt) = nansum(hist./corr);
        anDataAll.TWConcentraction(cnt) = anDataAll.TWCount(cnt)/ anDataAll.sample.VolumeReal(cnt)*1e-6;
                 
        anDataAll.TWCountRawMaxDia(cnt) = anDataAll.LWCountRaw(cnt) + anDataAll.IWCountRawMaxDia(cnt);
        anDataAll.TWCountMaxDia(cnt) = anDataAll.LWCount(cnt) + anDataAll.IWCountMaxDia(cnt);
        anDataAll.TWConcentractionMaxDia(cnt) = anDataAll.LWConcentraction(cnt) + anDataAll.IWConcentractionMaxDia(cnt);
                
        anDataAll.TWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
                / anDataAll.sample.VolumeReal(cnt)*1e6;
        anDataAll.TWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
                / anDataAll.sample.VolumeReal(cnt)*1e6;
        
        anDataAll.TWContentRawCotton(cnt) = anDataAll.LWContentRaw(cnt) + anDataAll.IWContentRawCotton(cnt);
        anDataAll.TWContentCotton(cnt) = anDataAll.LWContent(cnt) + anDataAll.IWContentCotton(cnt);
        
      
        clear parDiam
        clear hist
        clear corr
  end
end

save(['JFJ2012-5-Ice' num2str(anParameter.intervallVec(6)) 'secStat.mat'],'anDataAll');