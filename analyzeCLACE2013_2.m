%% Start up
%new
%1 Number Size Spectra Comparision
anParameter.plotShowNumbSpectrum = 1;
%2 Volume Size Spectra Comparision
anParameter.plotShowVolSpectrum = 1;
%3 Spatial Distribution Check
anParameter.plotShowSpatDist = 0;
anParameter.spatialDisCase = 12;
%4 Correction Check
anParameter.plotCorrectionCheck = 0;
anParameter.correctionCheckCase = 12;

anParameter.intervall = datenum([0 0 0 .5 0 0]);
anParameter.choosenDay = 7;

anParameter.lowSize = 6;
anParameter.maxSize = 250;
anParameter.divideSize = 34;

set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);
anParameter.plotColors = {'k','b','r','g','c','m','y'};
anParameter.plotLineStyle = {'-','--',':','-.','-','--',':','-.','-','--',':','-.','-','--',':','-.'};
anParameter.ParInfoFolder = 'F:\CLACE2013\Overview';
cd(anParameter.ParInfoFolder);
anParameter.ParInfoFiles = dir('*.mat');
anParameter.ParInfoFiles = {anParameter.ParInfoFiles.name};

anParameter.cfg = config(fullfile(anParameter.ParInfoFolder, 'holoviewer.cfg'));
[anParameter.histBinBorder anParameter.histBinSizes anParameter.histBinMiddle] ...
    = getHistBorder(anParameter.divideSize, anParameter.maxSize, anParameter.cfg, 1);
[anParameter.histBinBorderOldSizes anParameter.histBinSizesOldSizes anParameter.histBinMiddleOldSizes] ...
    = getHistBorder(anParameter.divideSize, anParameter.maxSize, anParameter.cfg, 0);

%Holo Data input
if ~exist('dataAll','var');
    for cnt = 1:numel(anParameter.ParInfoFiles);
        tmp = load(anParameter.ParInfoFiles{cnt}, 'data');
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
            dataAll = tmp;
            dataAll.nPart = {dataAll.nPart};
            dataAll.folderPartStats = {dataAll.folderPartStats};
            dataAll.psfilesnames    = {dataAll.psfilenames};
            dataAll.indHoloAll      = {dataAll.indHolo};
            dataAll.blackListInd    = {dataAll.blackListInd};
            clear dataAll.sampleNumberReal
            clear dataAll.sampleVolumeReal
            clear realInd
        else
            dataAll.partIsBorder    = [dataAll.partIsBorder tmp.partIsBorder];
            dataAll.partIsSatelite  = [dataAll.partIsSatelite tmp.partIsSatelite];
            dataAll.maxPh           = [dataAll.maxPh tmp.maxPh];
            dataAll.minPh           = [dataAll.minPh tmp.minPh];
            dataAll.pDiam           = [dataAll.pDiam tmp.pDiam];
            dataAll.pDiamOldSizes   = [dataAll.pDiamOldSizes tmp.pDiamOldSizes];
            dataAll.pDiamFilled     = [dataAll.pDiamFilled  tmp.pDiamFilled];
            dataAll.pEssent         = [dataAll.pEssent tmp.pEssent];
            dataAll.xPos            = [dataAll.xPos tmp.xPos];
            dataAll.yPos            = [dataAll.yPos tmp.yPos];
            dataAll.zPos            = [dataAll.zPos tmp.zPos];
            dataAll.xyExtend        = [dataAll.xyExtend tmp.xyExtend];
            dataAll.zExtend         = [dataAll.zExtend tmp.zExtend];
            dataAll.timeHolo        = [dataAll.timeHolo tmp.timeHolo];
            dataAll.timeVec         = [dataAll.timeVec; tmp.timeVec];
            dataAll.timeNum        = [dataAll.timeNum tmp.timeNum];
            tmp2 = cell2mat(dataAll.indHoloAll);
            dataAll.indHoloAll      = [dataAll.indHoloAll tmp.indHolo + tmp2(end)];
            clear tmp2;
            dataAll.indHolo         = [dataAll.indHolo tmp.indHolo];
            dataAll.indPart         = [dataAll.indPart tmp.indPart];
            dataAll.indFileNr       = [dataAll.indFileNr tmp.indFileNr];
            dataAll.partIsOnBlackList = [dataAll.partIsOnBlackList tmp.partIsOnBlackList];
            dataAll.partIsRealAll   = [dataAll.partIsRealAll tmp.partIsRealAll];
            dataAll.partIsReal      = [dataAll.partIsReal tmp.partIsReal];
            
            dataAll.nPart{cnt}      = tmp.nPart;
            dataAll.folderPartStats{cnt} = tmp.folderPartStats;
            dataAll.psfilesnames{cnt}    = tmp.psfilenames;
            dataAll.blackListInd{cnt} = tmp.blackListInd;         
          
        end
    end
    clear cnt
    dataAll.indHoloAll = cell2mat(dataAll.indHoloAll);
    
    dataAll.timeStart = dataAll.timeNum(1);
    dataAll.timeEnd = dataAll.timeNum(end);
    
    dataAll.timeVecStart = dataAll.timeVec(1,:);
    dataAll.timeVecEnd = dataAll.timeVec(end,:);
    
    dataAll.meanD   = nanmean(dataAll.pDiam(dataAll.partIsReal & dataAll.pDiam > anParameter.lowSize*1e-6));
    dataAll.totalCount = nansum(dataAll.partIsReal & dataAll.pDiam > anParameter.lowSize*1e-6);
end

%Sonic data input
if ~exist('dataSonic','var');
    dataSonic = inputSonicData('F:\CLACE2013\Labview');
end

%find Intervall
if ~exist('dataAll.inntervall','var');
    time = dataAll.timeStart;
    
    if anParameter.choosenDay == 0;
        dateAll.day = ones(1,numel(dataAll.timeNum));
    else
        dateAll.day = zeros(1,numel(dataAll.timeNum));
        dateAll.day(dataAll.timeVec(:,3) == anParameter.choosenDay) = 1;
    end    
    dataAll.anParameter.intervall = zeros(1,numel(dataAll.timeNum));
    
    cnt = 1;
    while time < dataAll.timeEnd
        datevec(time)
        tmp = dataAll.timeNum >= time & dataAll.timeNum < time + anParameter.intervall & dateAll.day;
        if sum(tmp~=0)
            dataAll.anParameter.intervall(tmp) =  cnt;
            cnt = cnt+1;
            time = time + anParameter.intervall;
        else
            tmp2 = find(dataAll.timeNum > time+anParameter.intervall & dateAll.day,1,'first');
            time = dataAll.timeNum(tmp2);
        end
        
    end
    clear time
    clear tmp
    clear tmp2
end

%first calculation in intervalls
clear anDataAll
for cnt = 1:max(dataAll.anParameter.intervall)    
    tmp = dataAll.anParameter.intervall == cnt;
    anDataAll{cnt}.timeStart = min(dataAll.timeNum(tmp));
    anDataAll{cnt}.timeEnd = max(dataAll.timeNum(tmp));
    
    anDataAll{cnt}.timeVecStart = min(dataAll.timeVec(tmp,:));
    anDataAll{cnt}.timeVecEnd = max(dataAll.timeVec(tmp,:));
    
    anDataAll{cnt}.meanD   = nanmean(dataAll.pDiam(tmp & dataAll.partIsReal & dataAll.pDiam > anParameter.lowSize*1e-6));
    anDataAll{cnt}.totalCount = nansum(tmp & dataAll.partIsReal & dataAll.pDiam > anParameter.lowSize*1e-6);

    anDataAll{cnt}.timeVec = dataAll.timeVec(tmp,:);
    anDataAll{cnt}.partIsReal = dataAll.partIsReal(tmp);
    anDataAll{cnt}.partIsBorder = dataAll.partIsBorder(tmp);
    anDataAll{cnt}.partIsSatelite = dataAll.partIsSatelite(tmp);
    anDataAll{cnt}.pDiam = dataAll.pDiam(tmp);
    anDataAll{cnt}.pDiamOldSizes = dataAll.pDiamOldSizes(tmp);
    anDataAll{cnt}.xPos = dataAll.xPos(tmp);
    anDataAll{cnt}.yPos = dataAll.yPos(tmp);
    anDataAll{cnt}.zPos = dataAll.zPos(tmp);
    anDataAll{cnt}.indHoloAll = dataAll.indHoloAll(tmp);
    anDataAll{cnt}.indHolo = anDataAll{cnt}.indHoloAll - anDataAll{cnt}.indHoloAll(1)+1;
    
    anDataAll{cnt}.sampleNumber      = dataAll.indHoloAll(end) - dataAll.indHoloAll(1);
    anDataAll{cnt}.sampleVolumeAll   = dataAll.sampleVolumeHolo * anDataAll{cnt}.sampleNumber ;    
    
    anDataAll{cnt}.blackListInd = unique(anDataAll{cnt}.indHoloAll(anDataAll{cnt}.pDiam >0.00025));
    anDataAll{cnt}.partIsOnBlackList = false(1, numel(anDataAll{cnt}.indHoloAll));
    for i = 1:numel(anDataAll{cnt}.blackListInd)
        anDataAll{cnt}.partIsOnBlackList =  anDataAll{cnt}.indHoloAll == anDataAll{cnt}.blackListInd(i);
    end
    nanParticleInd = find(isnan(anDataAll{cnt}.partIsSatelite));
    anDataAll{cnt}.partIsSatelite(nanParticleInd) = 1;
    anDataAll{cnt}.partIsBorder(nanParticleInd) = 1;
    
    anDataAll{cnt}.partIsRealAll  = ~anDataAll{cnt}.partIsSatelite & ~anDataAll{cnt}.partIsBorder;
    anDataAll{cnt}.partIsReal     = ~anDataAll{cnt}.partIsSatelite & ~anDataAll{cnt}.partIsBorder & ~anDataAll{cnt}.partIsOnBlackList;
    anDataAll{cnt}.sampleNumberReal = anDataAll{cnt}.sampleNumber - numel(anDataAll{cnt}.blackListInd);
    anDataAll{cnt}.sampleVolumeReal   = dataAll.sampleVolumeHolo * anDataAll{cnt}.sampleNumberReal;
    anDataAll{cnt}.realInd = find(anDataAll{cnt}.partIsReal);

end

%Find Sonic Date Indices for Measurements Periods
for cnt = 1:numel(anDataAll)
    anDataAll{cnt}.sonicIndice = [find(dataSonic.Date_Num> anDataAll{cnt}.timeStart,1,'first') ...
        find(dataSonic.Date_Num> anDataAll{cnt}.timeEnd,1,'first')];
    [anDataAll{cnt}.measMeanV anDataAll{cnt}.measStdV] = ...
        mean_data(dataSonic.V_total,anDataAll{cnt}.sonicIndice);
    [anDataAll{cnt}.measMeanT anDataAll{cnt}.measStdT] = ...
        mean_data(dataSonic.T_acoustic,anDataAll{cnt}.sonicIndice);
    [anDataAll{cnt}.measMeanFlow anDataAll{cnt}.measStdFlow] = ...
        mean_data(dataSonic.Flowmeter_massflow,anDataAll{cnt}.sonicIndice);
    [anDataAll{cnt}.meanElevSonic anDataAll{cnt}.stdElevSonic] = ...
        mean_data(dataSonic.WD_elevation,anDataAll{cnt}.sonicIndice);
    [anDataAll{cnt}.meanElevRotor anDataAll{cnt}.stdElevRotor] = ...
        mean_data(dataSonic.WD_rotor_elevation,anDataAll{cnt}.sonicIndice);
    meanx = mean_data(dataSonic.Mean_Vx,anDataAll{cnt}.sonicIndice);
    meany = mean_data(dataSonic.Mean_Vy,anDataAll{cnt}.sonicIndice);
    anDataAll{cnt}.measMeanAzimutSonic = conWindXY2Deg(meanx, meany);
    clear meanx
    clear meany
    %% Rotor not on in CLACE 2013
    %     meanroty = mean_data(-cosd(dataSonic.WD_rotor_azimut_sonic),anDataAll{cnt}.sonicIndice);
    %     meanrotx = mean_data(-sind(dataSonic.WD_rotor_azimut_sonic),anDataAll{cnt}.sonicIndice);
    %     anDataAll{cnt}.measMeanAzimutRotor = conWindXY2Deg(meanrotx, meanroty);
    %     clear meanroty
    %     clear meanrotx
    %     diff_azimut = min([abs(dataSonic.WD_azimut-dataSonic.WD_rotor_azimut_sonic) ...
    %         abs(abs(dataSonic.WD_azimut-dataSonic.WD_rotor_azimut_sonic)-360)],[],2);
    %     anDataAll{cnt}.measMeanDiffAzimutSingle = mean_data(diff_azimut,anDataAll{cnt}.sonicIndice);
    %     anDataAll{cnt}.measMeanDiffAzimutMean = ...
    %         abs( anDataAll{cnt}.measMeanAzimutSonic-anDataAll{cnt}.measMeanAzimutRotor);
end

%Calculation of Histograms
if true
    for cnt = 1:numel(anDataAll);
        tmp = dataAll.anParameter.intervall == cnt;        
        
        anDataAll{cnt}.constInletCorr.pressure      = 656;    %[hPa]
        anDataAll{cnt}.constInletCorr.temperature   = 273.15 + anDataAll{cnt}.measMeanT; %[K]
        anDataAll{cnt}.constInletCorr.massflow      = anDataAll{cnt}.measMeanFlow;  %[l/min]
        anDataAll{cnt}.constInletCorr.dPipe         = 0.05;    %[m]
        anDataAll{cnt}.constInletCorr.windSpeed     = anDataAll{cnt}.measMeanAzimutSonic;
        
        anDataAll{cnt}.timeString = [num2str(anDataAll{cnt}.timeVec(1,3),'%02u') 'th, ' ...
            num2str(anDataAll{cnt}.timeVec(1,4),'%02u') ':' num2str(anDataAll{cnt}.timeVec(1,5),'%02u') '-'...
            num2str(anDataAll{cnt}.timeVec(end,4),'%02u') ':' num2str(anDataAll{cnt}.timeVec(end,5),'%02u')];
        
        [anDataAll{cnt}.histReal, ~, ~, anDataAll{cnt}.limit, anDataAll{cnt}.histRealError] = ...
            histogram(anDataAll{cnt}.pDiam(anDataAll{cnt}.partIsReal)*1e6, anDataAll{cnt}.sampleVolumeAll, anParameter.histBinBorder);
        [anDataAll{cnt}.histRealOldSizes, ~, ~, anDataAll{cnt}.limitOldSizes, anDataAll{cnt}.histRealErrorOldSizes] = ...
            histogram(anDataAll{cnt}.pDiamOldSizes(anDataAll{cnt}.partIsReal)*1e6, anDataAll{cnt}.sampleVolumeAll, anParameter.histBinBorderOldSizes);
        
        anDataAll{cnt}.histRealCor = anDataAll{cnt}.histReal./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll{cnt}.constInletCorr);
        anDataAll{cnt}.histRealCorOldSizes = anDataAll{cnt}.histRealOldSizes./Paik_inert(anParameter.histBinMiddleOldSizes*1e-6, anDataAll{cnt}.constInletCorr);
        anDataAll{cnt}.histRealErrorCor =  anDataAll{cnt}.histRealError./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll{cnt}.constInletCorr);
        anDataAll{cnt}.histRealErrorCorOld = anDataAll{cnt}.histRealErrorOldSizes./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll{cnt}.constInletCorr);
        anDataAll{cnt}.histRealCount =  histc(anDataAll{cnt}.pDiam(anDataAll{cnt}.partIsReal)*1e6, anParameter.histBinBorder(1:end-1));
        anDataAll{cnt}.histRealCountCor = anDataAll{cnt}.histRealCount./Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll{cnt}.constInletCorr);
        
        %Total Water calculations
        parDiam = anDataAll{cnt}.pDiam(anDataAll{cnt}.partIsReal & anDataAll{cnt}.pDiam > anParameter.lowSize*1e-6);
        hist = histc(parDiam, anParameter.histBinBorder*1e-6);
        hist = hist(1:end-1);
        corr = Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll{cnt}.constInletCorr);
        
        anDataAll{cnt}.TWCount = sum(hist./corr);
        anDataAll{cnt}.TWConcentraction = anDataAll{cnt}.TWCount/ anDataAll{cnt}.sampleVolumeReal*1e-6;
        anDataAll{cnt}.TWContentRaw     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll{cnt}.sampleVolumeReal*1e-6;
        anDataAll{cnt}.TWContent = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll{cnt}.sampleVolumeReal*1e6;
        clear parDiam
        clear hist
        clear corr
        
        %Ice Water calculations
        parDiam = anDataAll{cnt}.pDiam(anDataAll{cnt}.partIsReal ...
            & anDataAll{cnt}.pDiam > anParameter.lowSize*1e-6 ...
            & anDataAll{cnt}.pDiam > anParameter.divideSize*1e-6);
        hist = histc(parDiam, anParameter.histBinBorder*1e-6);
        hist = hist(1:end-1);
        corr = Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll{cnt}.constInletCorr);
        
        anDataAll{cnt}.IWCount = sum(hist./corr);
        anDataAll{cnt}.IWConcentraction = anDataAll{cnt}.IWCount/ anDataAll{cnt}.sampleVolumeReal*1e-6;
        anDataAll{cnt}.IWContentRaw     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll{cnt}.sampleVolumeReal * 1000000;
        anDataAll{cnt}.IWContent = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll{cnt}.sampleVolumeReal*1e6;
        clear parDiam
        clear hist
        clear corr
        
        %Liquid Water calculations
        parDiam = anDataAll{cnt}.pDiam(anDataAll{cnt}.partIsReal ...
            & anDataAll{cnt}.pDiam > anParameter.lowSize*1e-6 ...
            & anDataAll{cnt}.pDiam <= anParameter.divideSize*1e-6);
        hist = histc(parDiam, anParameter.histBinBorder*1e-6);
        hist = hist(1:end-1);
        corr = Paik_inert(anParameter.histBinMiddle*1e-6, anDataAll{cnt}.constInletCorr);
        
        anDataAll{cnt}.LWCount = sum(hist./corr);
        anDataAll{cnt}.LWConcentraction = anDataAll{cnt}.LWCount/ anDataAll{cnt}.sampleVolumeReal*1e-6;
        anDataAll{cnt}.LWContentRaw     = nansum(1/6*pi.*parDiam.^3)...
            / anDataAll{cnt}.sampleVolumeReal*1e-6;
        anDataAll{cnt}.LWContent = nansum((1/6*pi.*(anParameter.histBinMiddle*1e-6).^3).*hist./corr)...
            / anDataAll{cnt}.sampleVolumeReal*1e6;
        clear parDiam
        clear hist
        clear corr
    end
end

%% Number Size Spectra Comparision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 01
if anParameter.plotShowNumbSpectrum
    figure(1)
    clf
    
    legendString = ['legend('];
    for cnt = 1:numel(anDataAll)
        plot(anParameter.histBinMiddle, anDataAll{cnt}.histRealCor, ...
            [anParameter.plotLineStyle{ceil(cnt/numel(anParameter.plotColors))}...
            anParameter.plotColors{rem(cnt,numel(anParameter.plotColors))+1}],...
            'LineWidth',2);
        %anParameter.histBinMiddleOldSizes, anDataAll{cnt}.histRealCorOldSizes, ...
        %['--' anParameter.plotColors(rem(cnt,numel(anParameter.plotColors)))],...
        hold on
        legendString = [legendString '''' ...
            num2str(cnt,'%02u')...
            ': ' anDataAll{cnt}.timeString ...
            ', T=' num2str(anDataAll{cnt}.measMeanT,'%4.1f') '\pm' ...
            num2str(anDataAll{cnt}.measStdT,'%4.1f') '°C'...
            ', v=' num2str(anDataAll{cnt}.measMeanV,'%4.1f') '\pm' ...
            num2str(anDataAll{cnt}.measStdV,'%4.1f') ' m/s'...
            ', Azi=' num2str(anDataAll{cnt}.measMeanAzimutSonic,'%3.0f') '°'...
            ', Elev=' num2str(anDataAll{cnt}.meanElevSonic,'%3.0f') '°'...
            ', Flow=' num2str(anDataAll{cnt}.measMeanFlow,'%2.0f') '\pm' ...
            num2str(anDataAll{cnt}.measStdFlow,'%4.1f') '  l/min'...
            ''','];
    end
    legendString = ['h_legend=' legendString(1:end-1) ', ''FontSize'', 11, ''Location'', ''EastOutside'');'];
    eval(legendString);
    set(h_legend,'FontSize',9);
    ylabel('number density d(N)/d(log d) [cm^{-3}\mum^{-1}]');
    xlabel('diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    xlim(gca, [6 anParameter.maxSize]);
    ylim(gca, [5e-7 1e1]);
     
    set(gca,'Position',[0.08 0.13 .38 .85]);
    set(gcf, 'Units', 'centimeters', 'Position', [0 0 29 13]);
    set(gcf, 'PaperOrientation', 'landscape', 'PaperSize', [29.7 21], 'PaperPositionMode', 'auto')

end

%% Volume Size Spectra Comparision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 02
if anParameter.plotShowVolSpectrum
    figure(2)
    clf;
    
    legendString = ['legend('];
    for cnt = 1:numel(anDataAll)
        plot(anParameter.histBinMiddle, anDataAll{cnt}.histRealCor.*(1/6*pi.*anParameter.histBinMiddle.^3), ...
            [anParameter.plotLineStyle{ceil(cnt/numel(anParameter.plotColors))}...
            anParameter.plotColors{rem(cnt,numel(anParameter.plotColors))+1}],...
            'LineWidth',2);
        %anParameter.histBinMiddleOldSizes, anDataAll{cnt}.histRealCorOldSizes, ...
        %['--' anParameter.plotColors(rem(cnt,numel(anParameter.plotColors)))],...
        hold on
        legendString = [legendString '''' ...
            num2str(cnt,'%02u')...
            ': ' anDataAll{cnt}.timeString ''','];
    end
    legendString = ['h_legend=' legendString(1:end-1) ', ''Location'', ''EastOutside'');'];
    eval(legendString);
    set(h_legend,'FontSize',9);
    
    ylabel('volume density d(V)/d(log d) [cm^{-3}\mum^{-1}\mum^{3}]');
    xlabel('diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    xlim(gca,[6 anParameter.maxSize]);
    ylim(gca,[1e-2 1e4]);
    
    set(gca,'Position',[0.08 0.13 .38 .85]);
    set(gcf, 'Units', 'centimeters', 'Position', [0 0 29 13]);
    set(gcf, 'PaperOrientation', 'landscape', 'PaperSize', [29.7 21], 'PaperPositionMode', 'auto')
end

%% Spatial Distribution Check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 03
if anParameter.plotShowSpatDist
    figure(3);
    clf;
    
    cnt = anParameter.spatialDisCase;
    subplot(3,2,1);
    hold on;
    [a b] = hist(anDataAll{cnt}.xPos(anDataAll{cnt}.partIsReal).*1e3,30);
    a = a./(sum(a)/numel(a))-1;
    bar(b,a)
    
    xlim([-2.2 2.2]);
    ylim([-.2 .2]);
    title('Y position frequency');
    xlabel('Y Position (mm)');
    ylabel('Relative Count');
    
    subplot(3,2,3);
    hold on;
    [a b] = hist(anDataAll{cnt}.yPos(anDataAll{cnt}.partIsReal).*1e3,30);
    a = a./(sum(a)/numel(a))-1;
    bar(b,a)
    xlim([-1.8 1.8]);
    ylim([-.2 .2]);
    title('X position frequency');
    xlabel('X Position (mm)');
    ylabel('Relative Count');
    
    subplot(3,2,5);
    hold on;
    [a b] = hist(anDataAll{cnt}.zPos(anDataAll{cnt}.partIsReal).*1e3,30);
    a = a./(sum(a)/numel(a))-1;
    bar(b,a)
    ylim([-.6 .6]);
    title('Z position frequency');
    xlabel('Z Position (mm)');
    ylabel('Relative Count');
    
    subplot(3,2,[2 4 6]);
    bln = .1e-3;
    x = anDataAll{cnt}.xPos(anDataAll{cnt}.partIsReal);
    y = anDataAll{cnt}.yPos(anDataAll{cnt}.partIsReal);
    xrange = min(x):bln:max(x);
    yrange = min(y):bln:max(y);
    count = hist2([x;y]',xrange,yrange);
    count = count./(sum(count(:))/numel(count)) - 1;
    count = interp2(count,4);
    [nx ny] = size(count);
    xrange = linspace(min(x),max(x),nx).*1e3;
    yrange = linspace(min(y),max(y),ny).*1e3;
    %xrange = (xrange(2:end) - bln/2).*1e3;
    %yrange = (yrange(2:end) - bln/2).*1e3;
    contourf(yrange,xrange,count);
    
    title('Relative Frequency of Occurance');
    xlabel('X position (mm)');
    ylabel('Y position (mm)');
    caxis([-.5 .5]);
    
    mtit([num2str(cnt,'%02u')  ': ' anDataAll{cnt}.timeString ''','], 'xoff' , -.2, 'yoff' , +.02);
    set(gcf, 'Units', 'normalized');
    set(gcf, 'OuterPosition', [.6 .3 0.7 0.7])
end

%% Number Size Spectra Comparision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 01
if anParameter.plotCorrectionCheck
    figure(4)
    clf
    
    plot(anParameter.histBinMiddleOldSizes, anDataAll{anParameter.correctionCheckCase}.histRealCorOldSizes, ...
        anParameter.histBinMiddle, anDataAll{anParameter.correctionCheckCase}.histReal, ...
        anParameter.histBinMiddle, anDataAll{anParameter.correctionCheckCase}.histRealCor, ...
        'LineWidth',2);
    
    legend('Sizes uncorrected', 'Efficiency uncorrected', 'Corrected');
    title([num2str(cnt,'%02u')  ': ' anDataAll{anParameter.correctionCheckCase}.timeString ''',']);
    ylabel('number density d(N)/d(log d) [cm^{-3}\mum^{-1}]');
    xlabel('diameter [\mum]')
    xlim([6 anParameter.maxSize]);
    ylim([3e-7 1e2]);
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    
    set(gcf, 'Units', 'normalized');
    set(gcf, 'OuterPosition', [.9 0 .5 0.5])
end
