%% Start up
%new
%1 Number Size Spectra Comparision
anParameterRec.plotShowNumbSpectrum = 1;
%2 Volume Size Spectra Comparision
anParameterRec.plotShowVolSpectrum = 1;
%3 Spatial Distribution Check
anParameterRec.plotShowSpatDist = 0;
anParameterRec.spatialDisCase = 12;
%4 Correction Check
anParameterRec.plotCorrectionCheck = 0;
anParameterRec.correctionCheckCase = 12;

anParameterRec.intervall = datenum([0 0 0 0 10 0]);
anParameterRec.choosenDay = 0;

anParameterRec.lowSize = 6;
anParameterRec.maxSize = 250;
anParameterRec.divideSize = 34;

set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);
anParameterRec.plotColors = {'k','b','r','g','c','m','y'};
anParameterRec.plotLineStyle = {'-','--',':','-.','-','--',':','-.','-','--',':','-.','-','--',':','-.'};
anParameterRec.ParInfoFolder = 'F:\CLACE2013\Overview';
cd(anParameterRec.ParInfoFolder);
anParameterRec.ParInfoFiles = dir('*.mat');
anParameterRec.ParInfoFiles = {anParameterRec.ParInfoFiles.name};

anParameterRec.cfg = config(fullfile(anParameterRec.ParInfoFolder, 'holoviewer.cfg'));
[anParameterRec.histBinBorder, anParameterRec.histBinSizes, anParameterRec.histBinMiddle] ...
    = getHistBorder(anParameterRec.divideSize, anParameterRec.maxSize, anParameterRec.cfg, 1);
[anParameterRec.histBinBorderOldSizes, anParameterRec.histBinSizesOldSizes, anParameterRec.histBinMiddleOldSizes] ...
    = getHistBorder(anParameterRec.divideSize, anParameterRec.maxSize, anParameterRec.cfg, 0);

%Holo Data input
if ~exist('dataRec','var');
    for cnt = 1:numel(anParameterRec.ParInfoFiles);
        tmp = load(anParameterRec.ParInfoFiles{cnt}, 'data');
        tmp = tmp.data;
        
        %add year and month to timeHolo
        year = 2013;
        if tmp.timeVec(1,1) > 20
            month = 1;
        else month = 2;
        end
        
        tmp.timeVec = [ones(1,numel(tmp.timeHolo))*year; ...
            ones(1,numel(tmp.timeHolo))*month; tmp.timeVec]';
        tmp.timeNum = datenum(tmp.timeVec(:,1:6))';
        clear year
        clear month
        
        if cnt == 1
            dataRec = tmp;
            dataRec.nPart = {dataRec.nPart};
            dataRec.folderPartStats = {dataRec.folderPartStats};
            dataRec.psfilesnames    = {dataRec.psfilenames};
            dataRec.indHoloAll      = {dataRec.indHolo};
            dataRec.blackListInd    = {dataRec.blackListInd};
            clear dataRec.sampleNumberReal
            clear dataRec.sampleVolumeReal
            clear realInd
        else
            dataRec.partIsBorder    = [dataRec.partIsBorder tmp.partIsBorder];
            dataRec.partIsSatelite  = [dataRec.partIsSatelite tmp.partIsSatelite];
            dataRec.maxPh           = [dataRec.maxPh tmp.maxPh];
            dataRec.minPh           = [dataRec.minPh tmp.minPh];
            dataRec.pDiam           = [dataRec.pDiam tmp.pDiam];
            dataRec.pDiamOldSizes   = [dataRec.pDiamOldSizes tmp.pDiamOldSizes];
            dataRec.pDiamFilled     = [dataRec.pDiamFilled  tmp.pDiamFilled];
            dataRec.pEssent         = [dataRec.pEssent tmp.pEssent];
            dataRec.xPos            = [dataRec.xPos tmp.xPos];
            dataRec.yPos            = [dataRec.yPos tmp.yPos];
            dataRec.zPos            = [dataRec.zPos tmp.zPos];
            dataRec.xyExtend        = [dataRec.xyExtend tmp.xyExtend];
            dataRec.zExtend         = [dataRec.zExtend tmp.zExtend];
            dataRec.timeHolo        = [dataRec.timeHolo tmp.timeHolo];
            dataRec.timeVec         = [dataRec.timeVec; tmp.timeVec];
            dataRec.timeNum        = [dataRec.timeNum tmp.timeNum];
            tmp2 = cell2mat(dataRec.indHoloAll);
            dataRec.indHoloAll      = [dataRec.indHoloAll tmp.indHolo + tmp2(end)];
            clear tmp2;
            dataRec.indHolo         = [dataRec.indHolo tmp.indHolo];
            dataRec.indPart         = [dataRec.indPart tmp.indPart];
            dataRec.indFileNr       = [dataRec.indFileNr tmp.indFileNr];
            dataRec.partIsOnBlackList = [dataRec.partIsOnBlackList tmp.partIsOnBlackList];
            dataRec.partIsRealAll   = [dataRec.partIsRealAll tmp.partIsRealAll];
            dataRec.partIsReal      = [dataRec.partIsReal tmp.partIsReal];
            
            dataRec.nPart{cnt}      = tmp.nPart;
            dataRec.folderPartStats{cnt} = tmp.folderPartStats;
            dataRec.psfilesnames{cnt}    = tmp.psfilenames;
            dataRec.blackListInd{cnt} = tmp.blackListInd;         
          
        end
    end
    clear cnt
    dataRec.indHoloAll = cell2mat(dataRec.indHoloAll);
    
    dataRec.timeStart = dataRec.timeNum(1);
    dataRec.timeEnd = dataRec.timeNum(end);
    
    dataRec.timeVecStart = dataRec.timeVec(1,:);
    dataRec.timeVecEnd = dataRec.timeVec(end,:);
    
    dataRec.meanD   = nanmean(dataRec.pDiam(dataRec.partIsReal & dataRec.pDiam > anParameterRec.lowSize*1e-6));
    dataRec.totalCount = nansum(dataRec.partIsReal & dataRec.pDiam > anParameterRec.lowSize*1e-6);
end

%Sonic data input
if ~exist('dataSonic','var');
    dataSonic = inputSonicData('F:\CLACE2013\Labview');
end

%find Intervall
if ~exist('dataRec.inntervall','var');
    time = dataRec.timeStart;
    
    if anParameterRec.choosenDay == 0;
        dataRec.day = ones(1,numel(dataRec.timeNum));
    else
        dataRec.day = zeros(1,numel(dataRec.timeNum));
        dataRec.day(dataRec.timeVec(:,3) == anParameterRec.choosenDay) = 1;
    end    
    dataRec.anParameterRec.intervall = zeros(1,numel(dataRec.timeNum));
    
    for cnt = 1:numel(anDataAll.timeStart)
        tmp = dataRec.timeNum >= anDataAll.timeStart(cnt) & dataRec.timeNum < anDataAll.timeEnd(cnt) & dataRec.day;
        dataRec.anParameterRec.intervall(tmp) = cnt;
    end
%     cnt = 1;
%     while time < dataRec.timeEnd
%         datevec(time)
%         tmp = dataRec.timeNum >= time & dataRec.timeNum < time + anParameterRec.intervall & dataRec.day;
%         if sum(tmp~=0)
%             dataRec.anParameterRec.intervall(tmp) =  cnt;
%             cnt = cnt+1;
%             time = time + anParameterRec.intervall;
%         else
%             tmp2 = find(dataRec.timeNum > time+anParameterRec.intervall & dataRec.day,1,'first');
%             time = dataRec.timeNum(tmp2);
%         end
%         
%     end
    clear time
    clear tmp
    clear tmp2
end

%first calculation in intervalls
clear anDataRec
for cnt = 1:max(dataRec.anParameterRec.intervall)    
    tmp = dataRec.anParameterRec.intervall == cnt;
    anDataRec.timeStart(cnt) = min(dataRec.timeNum(tmp));
    anDataRec.timeEnd(cnt) = max(dataRec.timeNum(tmp));
    
    anDataRec.timeVecStart(:,cnt) = min(dataRec.timeVec(tmp,:));
    anDataRec.timeVecEnd(:,cnt) = max(dataRec.timeVec(tmp,:));
    
    anDataRec.meanD(cnt)   = nanmean(dataRec.pDiam(tmp & dataRec.partIsReal & dataRec.pDiam > anParameterRec.lowSize*1e-6));
    anDataRec.totalCount(cnt) = nansum(tmp & dataRec.partIsReal & dataRec.pDiam > anParameterRec.lowSize*1e-6);

    anDataRec.timeVec{cnt} = dataRec.timeVec(tmp,:);
    anDataRec.partIsReal{cnt} = dataRec.partIsReal(tmp);
    anDataRec.partIsBorder{cnt} = dataRec.partIsBorder(tmp);
    anDataRec.partIsSatelite{cnt} = dataRec.partIsSatelite(tmp);
    anDataRec.pDiam{cnt} = dataRec.pDiam(tmp);
    anDataRec.pDiamOldSizes{cnt} = dataRec.pDiamOldSizes(tmp);
    anDataRec.xPos{cnt} = dataRec.xPos(tmp);
    anDataRec.yPos{cnt} = dataRec.yPos(tmp);
    anDataRec.zPos{cnt} = dataRec.zPos(tmp);
    anDataRec.indHoloAll{cnt}= dataRec.indHoloAll(tmp);
    anDataRec.indHolo{cnt} = anDataRec.indHoloAll{cnt} - anDataRec.indHoloAll{cnt}(1)+1;
    
    anDataRec.sample{cnt}.Number      = anDataRec.indHoloAll{cnt}(end) - anDataRec.indHoloAll{cnt}(1);
    anDataRec.sample{cnt}.VolumeAll   = dataRec.sampleVolumeHolo * anDataRec.sample{cnt}.Number  ;    
    
    anDataRec.blackListInd{cnt} = unique(anDataRec.indHoloAll{cnt}(anDataRec.pDiam{cnt} >0.00025));
    anDataRec.partIsOnBlackList{cnt} = false(1, numel(anDataRec.indHoloAll{cnt}));
    for i = 1:numel(anDataRec.blackListInd{cnt})
        anDataRec.partIsOnBlackList{cnt} =  anDataRec.indHoloAll{cnt} == anDataRec.blackListInd{cnt}(i);
    end
    nanParticleInd = find(isnan(anDataRec.partIsSatelite{cnt}));
    anDataRec.partIsSatelite{cnt}(nanParticleInd) = 1;
    anDataRec.partIsBorder{cnt}(nanParticleInd) = 1;
    
    anDataRec.partIsRealAll{cnt}  = ~anDataRec.partIsSatelite{cnt} & ~anDataRec.partIsBorder{cnt};
    anDataRec.partIsReal{cnt}     = ~anDataRec.partIsSatelite{cnt} & ~anDataRec.partIsBorder{cnt} & ~anDataRec.partIsOnBlackList{cnt};
    anDataRec.sample{cnt}.NumberReal = anDataRec.sample{cnt}.Number - numel(anDataRec.blackListInd{cnt});
    anDataRec.sample{cnt}.VolumeReal   = dataRec.sampleVolumeHolo * anDataRec.sample{cnt}.NumberReal;
    anDataRec.realInd{cnt} = find(anDataRec.partIsReal{cnt});

end

%Find Sonic Date Indices for Measurements Periods
for cnt = 1:numel(anDataRec.timeStart)
    anDataRec.sonicIndice{cnt} = [find(dataSonic.Date_Num> anDataRec.timeStart(cnt),1,'first') ...
        find(dataSonic.Date_Num> anDataRec.timeEnd(cnt),1,'first')];
    [anDataRec.measMeanV(cnt), anDataRec.measStdV(cnt)] = ...
        mean_data(dataSonic.V_total,anDataRec.sonicIndice{cnt});
    [anDataRec.measMeanT(cnt), anDataRec.measStdT(cnt)] = ...
        mean_data(dataSonic.T_acoustic,anDataRec.sonicIndice{cnt});
    [anDataRec.measMeanFlow(cnt), anDataRec.measStdFlow(cnt)] = ...
        mean_data(dataSonic.Flowmeter_massflow,anDataRec.sonicIndice{cnt});
    [anDataRec.meanElevSonic(cnt), anDataRec.stdElevSonic(cnt)] = ...
        mean_data(dataSonic.WD_elevation,anDataRec.sonicIndice{cnt});
    [anDataRec.meanElevRotor(cnt), anDataRec.stdElevRotor(cnt)] = ...
        mean_data(dataSonic.WD_rotor_elevation,anDataRec.sonicIndice{cnt});
    meanx = mean_data(dataSonic.Mean_Vx,anDataRec.sonicIndice{cnt});
    meany = mean_data(dataSonic.Mean_Vy,anDataRec.sonicIndice{cnt});
    anDataRec.measMeanAzimutSonic(cnt) = conWindXY2Deg(meanx, meany);
    clear meanx
    clear meany
    %% Rotor not on in CLACE 2013
    %     meanroty = mean_data(-cosd(dataSonic.WD_rotor_azimut_sonic),anDataRec{cnt}.sonicIndice);
    %     meanrotx = mean_data(-sind(dataSonic.WD_rotor_azimut_sonic),anDataRec{cnt}.sonicIndice);
    %     anDataRec{cnt}.measMeanAzimutRotor = conWindXY2Deg(meanrotx, meanroty);
    %     clear meanroty
    %     clear meanrotx
    %     diff_azimut = min([abs(dataSonic.WD_azimut-dataSonic.WD_rotor_azimut_sonic) ...
    %         abs(abs(dataSonic.WD_azimut-dataSonic.WD_rotor_azimut_sonic)-360)],[],2);
    %     anDataRec{cnt}.measMeanDiffAzimutSingle = mean_data(diff_azimut,anDataRec{cnt}.sonicIndice);
    %     anDataRec{cnt}.measMeanDiffAzimutMean = ...
    %         abs( anDataRec{cnt}.measMeanAzimutSonic-anDataRec{cnt}.measMeanAzimutRotor);
end

%Calculation of Histograms
if true        
    for cnt = 1:numel(anDataRec.timeStart);   
        
        anDataRec.constInletCorr{cnt}.pressure      = 656;    %[hPa]
        anDataRec.constInletCorr{cnt}.temperature   = 273.15 + anDataRec.measMeanT(cnt); %[K]
        anDataRec.constInletCorr{cnt}.massflow      = anDataRec.measMeanFlow(cnt);  %[l/min]
        anDataRec.constInletCorr{cnt}.dPipe         = 0.05;    %[m]
        anDataRec.constInletCorr{cnt}.windSpeed     = anDataRec.measMeanV(cnt);
        
       anDataRec.timeString{cnt} = [num2str(anDataRec.timeVecStart(3,cnt),'%02u') 'th, ' ...
            num2str(anDataRec.timeVecStart(4, cnt),'%02u') ':' num2str(anDataRec.timeVecStart(5,cnt),'%02u') '-'...
            num2str(anDataRec.timeVecEnd(4,cnt),'%02u') ':' num2str(anDataRec.timeVecEnd(5,cnt),'%02u')];
        
        [anDataRec.histReal(:,cnt), ~, ~, anDataRec.limit(:,cnt), anDataRec.histRealError(:,cnt)] = ...
            histogram(anDataRec.pDiam{cnt}(anDataRec.partIsReal{cnt})*1e6, anDataRec.sample{cnt}.VolumeAll, anParameter.histBinBorder);
        [anDataRec.histRealOldSizes(:,cnt), ~, ~, anDataRec.limitOldSizes(:,cnt), anDataRec.histRealErrorOldSizes(:,cnt)] = ...
            histogram(anDataRec.pDiamOldSizes{cnt}(anDataRec.partIsReal{cnt})*1e6, anDataRec.sample{cnt}.VolumeAll, anParameter.histBinBorderOldSizes);
        
        anDataRec.histRealCor(:,cnt) = anDataRec.histReal(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataRec.constInletCorr{cnt})';
        anDataRec.histRealCorOldSizes(:,cnt) = anDataRec.histRealOldSizes(:,cnt)./Paik_inert(anParameter.histBinMiddleOldSizes*1e-6, anDataRec.constInletCorr{cnt})';
        anDataRec.histRealErrorCor(:,cnt) =  anDataRec.histRealError(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataRec.constInletCorr{cnt})';
        anDataRec.histRealErrorCorOld(:,cnt) = anDataRec.histRealErrorOldSizes(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataRec.constInletCorr{cnt})';
        anDataRec.histRealCount(:,cnt) =  histc(anDataRec.pDiam{cnt}(anDataRec.partIsReal{cnt})*1e6, anParameter.histBinBorder(1:end-1))';
        anDataRec.histRealCountCor(:,cnt) = anDataRec.histRealCount(:,cnt)./Paik_inert(anParameter.histBinMiddle*1e-6, anDataRec.constInletCorr{cnt})';
        
      %Total Water calculations
        parDiam = anDataRec.pDiam{cnt}(anDataRec.partIsReal{cnt} & anDataRec.pDiam{cnt} > anParameter.lowSize*1e-6);
        hist = histc(parDiam, anParameter.histBinBorder*1e-6);
        hist = hist(1:end-1);
        corr = Paik_inert(anParameter.histBinMiddle*1e-6, anDataRec.constInletCorr{cnt});
        
        anDataRec.TWCount(cnt) = sum(hist./corr);
        anDataRec.TWConcentraction(cnt) = anDataRec.TWCount(cnt)/ anDataRec.sample{cnt}.VolumeReal*1e-6;
        anDataRec.TWContentRaw(cnt)    = nansum(1/6*pi.*parDiam.^3)...
            / anDataRec.sample{cnt}.VolumeReal*1e-6;
        anDataRec.TWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataRec.sample{cnt}.VolumeReal*1e6;
        clear parDiam
        clear hist
        clear corr
        
        %Ice Water calculations
        parDiam = anDataRec.pDiam{cnt}(anDataRec.partIsReal{cnt} ...
            & anDataRec.pDiam{cnt} > anParameter.lowSize*1e-6 ...
            & anDataRec.pDiam{cnt} > anParameter.divideSize*1e-6);
        hist = histc(parDiam, anParameter.histBinBorder*1e-6);
        hist = hist(1:end-1);
        corr = Paik_inert(anParameter.histBinMiddle*1e-6, anDataRec.constInletCorr{cnt});
        
        anDataRec.IWCount(cnt) = sum(hist./corr);
        anDataRec.IWConcentraction(cnt) = anDataRec.IWCount(cnt)/ anDataRec.sample{cnt}.VolumeReal*1e-6;
        anDataRec.IWContentRaw(cnt)    = nansum(1/6*pi.*parDiam.^3)...
            / anDataRec.sample{cnt}.VolumeReal * 1000000;
        anDataRec.IWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataRec.sample{cnt}.VolumeReal*1e6;
        clear parDiam
        clear hist
        clear corr
        
        %Liquid Water calculations
        parDiam = anDataRec.pDiam{cnt}(anDataRec.partIsReal{cnt} ...
                    & anDataRec.pDiam{cnt} > anParameter.lowSize*1e-6 ...
                    & anDataRec.pDiam{cnt} <= anParameter.divideSize*1e-6);
        hist = histc(parDiam, anParameter.histBinBorder*1e-6);
        hist = hist(1:end-1);
        corr = Paik_inert(anParameter.histBinMiddle*1e-6, anDataRec.constInletCorr{cnt});
        
        anDataRec.LWCount(cnt) = sum(hist./corr);
        anDataRec.LWConcentraction(cnt) = anDataRec.LWCount(cnt)/ anDataRec.sample{cnt}.VolumeReal*1e-6;
        anDataRec.LWContentRaw(cnt)     = nansum(1/6*pi.*parDiam.^3)...
            / anDataRec.sample{cnt}.VolumeReal*1e-6;
        anDataRec.LWContent(cnt) = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataRec.sample{cnt}.VolumeReal*1e6;
        clear parDiam
        clear hist
        clear corr

    end
end

anParameterRec.plotColorNew = cool(numel(anDataRec.timeStart));
%% Number Size Spectra Comparision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 01
if anParameterRec.plotShowNumbSpectrum
    figure(11)
    clf
    
    legendString = 'legend(';
    for cnt = 1:numel(anDataRec.timeStart)
        plot(anParameterRec.histBinMiddle, anDataRec.histRealCor(:,cnt), ...
            'color', anParameterRec.plotColorNew(cnt,:),...
            'LineWidth',2);
        %anParameterRec.histBinMiddleOldSizes, anDataRec{cnt}.histRealCorOldSizes, ...
        %['--' anParameterRec.plotColors(rem(cnt,numel(anParameterRec.plotColors)))],...
        hold on
        legendString = [legendString '''' ...
            num2str(cnt,'%02u')...
            ': ' anDataRec.timeString{cnt} ...
            ', T=' num2str(anDataRec.measMeanT(cnt),'%4.1f') '\pm' ...
            num2str(anDataRec.measStdT(cnt),'%4.1f') '°C'...
            ', v=' num2str(anDataRec.measMeanV(cnt),'%4.1f') '\pm' ...
            num2str(anDataRec.measStdV(cnt),'%4.1f') ' m/s'...
            ', Azi=' num2str(anDataRec.measMeanAzimutSonic(cnt),'%3.0f') '°'...
            ', Elev=' num2str(anDataRec.meanElevSonic(cnt),'%3.0f') '°'...
            ', Flow=' num2str(anDataRec.measMeanFlow(cnt),'%2.0f') '\pm' ...
            num2str(anDataRec.measStdFlow(cnt),'%4.1f') '  l/min'...
            ''','];
    end
    legendString = ['h_legend=' legendString(1:end-1) ', ''FontSize'', 11, ''Location'', ''EastOutside'');'];
    eval(legendString);
    set(h_legend,'FontSize',9);
    ylabel('number density d(N)/d(log d) [cm^{-3}\mum^{-1}]');
    xlabel('diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    xlim(gca, [6 anParameterRec.maxSize]);
    ylim(gca, [5e-7 1e1]);
     
    set(gca,'Position',[0.08 0.13 .38 .85]);
    set(gcf, 'Units', 'centimeters', 'Position', [0 0 29 13]);
    set(gcf, 'PaperOrientation', 'landscape', 'PaperSize', [29.7 21], 'PaperPositionMode', 'auto')

end

%% Volume Size Spectra Comparision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 02
if anParameterRec.plotShowVolSpectrum
    figure(12)
    clf;
    
    legendString = 'legend(';
    for cnt = 1:numel(anDataRec.timeStart)
        plot(anParameterRec.histBinMiddle, anDataRec.histRealCor(:,cnt)'.*(1/6*pi.*anParameterRec.histBinMiddle.^3), ...
             'color', anParameterRec.plotColorNew(cnt,:),...
            'LineWidth',2);
        hold on
        legendString = [legendString '''' ...
            num2str(cnt,'%02u')...
            ': ' anDataRec.timeString{cnt} ''','];
    end
    legendString = ['h_legend=' legendString(1:end-1) ', ''Location'', ''EastOutside'');'];
    eval(legendString);
    set(h_legend,'FontSize',9);
    
    ylabel('volume density d(V)/d(log d) [cm^{-3}\mum^{-1}\mum^{3}]');
    xlabel('diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    xlim(gca,[6 anParameterRec.maxSize]);
    ylim(gca,[1e-2 1e4]);
    
    set(gca,'Position',[0.08 0.13 .38 .85]);
    set(gcf, 'Units', 'centimeters', 'Position', [0 0 29 13]);
    set(gcf, 'PaperOrientation', 'landscape', 'PaperSize', [29.7 21], 'PaperPositionMode', 'auto')
end

%% Spatial Distribution Check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 03
if anParameterRec.plotShowSpatDist
    figure(3);
    clf;
    
    cnt = anParameterRec.spatialDisCase;
    subplot(3,2,1);
    hold on;
    [a b] = hist(anDataRec.xPos{cnt}(anDataRec.partIsReal{cnt}).*1e3,30);
    a = a./(sum(a)/numel(a))-1;
    bar(b,a)
    
    xlim([-2.2 2.2]);
    ylim([-.2 .2]);
    title('Y position frequency');
    xlabel('Y Position (mm)');
    ylabel('Relative Count');
    
    subplot(3,2,3);
    hold on;
    [a, b] = hist(anDataRec.yPos{cnt}(anDataRec.partIsReal{cnt}).*1e3,30);
    a = a./(sum(a)/numel(a))-1;
    bar(b,a)
    xlim([-1.8 1.8]);
    ylim([-.2 .2]);
    title('X position frequency');
    xlabel('X Position (mm)');
    ylabel('Relative Count');
    
    subplot(3,2,5);
    hold on;
    [a, b] = hist(anDataRec.zPos{cnt}(anDataRec.partIsReal{cnt}).*1e3,30);
    a = a./(sum(a)/numel(a))-1;
    bar(b,a)
    ylim([-.6 .6]);
    title('Z position frequency');
    xlabel('Z Position (mm)');
    ylabel('Relative Count');
    
    subplot(3,2,[2 4 6]);
    bln = .1e-3;
    x = anDataRec.xPos{cnt}(anDataRec.partIsReal{cnt});
    y = anDataRec.yPos{cnt}(anDataRec.partIsReal{cnt});
    xrange = min(x):bln:max(x);
    yrange = min(y):bln:max(y);
    count = hist2([x;y]',xrange,yrange);
    count = count./(sum(count(:))/numel(count)) - 1;
    count = interp2(count,4);
    [nx, ny] = size(count);
    xrange = linspace(min(x),max(x),nx).*1e3;
    yrange = linspace(min(y),max(y),ny).*1e3;
    %xrange = (xrange(2:end) - bln/2).*1e3;
    %yrange = (yrange(2:end) - bln/2).*1e3;
    contourf(yrange,xrange,count);
    
    title('Relative Frequency of Occurance');
    xlabel('X position (mm)');
    ylabel('Y position (mm)');
    caxis([-.5 .5]);
    
    mtit([num2str(cnt,'%02u')  ': ' anDataRec{cnt}.timeString ''','], 'xoff' , -.2, 'yoff' , +.02);
    set(gcf, 'Units', 'normalized');
    set(gcf, 'OuterPosition', [.6 .3 0.7 0.7])
end

%% Number Size Spectra Comparision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 01
if anParameterRec.plotCorrectionCheck
    figure(4)
    clf
    
    plot(anParameterRec.histBinMiddleOldSizes, anDataRec.histRealCorOldSizes(:,anParameterRec.correctionCheckCase), ...
        anParameterRec.histBinMiddle, anDataRec.histReal(:,anParameterRec.correctionCheckCase), ...
        anParameterRec.histBinMiddle, anDataRec.histRealCor(:,anParameterRec.correctionCheckCase), ...
        'LineWidth',2);
    
    legend('Sizes uncorrected', 'Efficiency uncorrected', 'Corrected');
    title([num2str(cnt,'%02u')  ': ' anDataRec.timeString(:,anParameterRec.correctionCheckCase) ''',']);
    ylabel('number density d(N)/d(log d) [cm^{-3}\mum^{-1}]');
    xlabel('diameter [\mum]')
    xlim([6 anParameterRec.maxSize]);
    ylim([3e-7 1e2]);
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    
    set(gcf, 'Units', 'normalized');
    set(gcf, 'OuterPosition', [.9 0 .5 0.5])
end
