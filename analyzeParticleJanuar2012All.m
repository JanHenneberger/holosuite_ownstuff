
%% Start up
choosePlots = [5 7];
%1 Spatial analysis
%2 Frequenzy of Occurance
%3 Time Serie Water Content
%4 TimeSerie Histogram
%5 Histogram Compare to Fog Monitor
%6 TimeSerie Mean D / Number compare to Fog Monitor
%7 Histogram Volume Density
%8 TimeSerie Fraction
intervall =5;
maxSizeHol = 250;
bigInd = 20;
maxSize = 250;
divideSize = 34;

set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);

if ~exist('dataAll','var');
    for Case = 1:4;  
        clear data
        if Case == 1
            data.chooseDay                    = 27;
            data.measurementTime              = 'Case warm 2012-01-27 13:35';
            data.measurementNumber            = 6;
            data.constInletCorr.windSpeed     = 2.65;
            data.airTemperature               = -12.23;
            data.HOLDirStats                  = 'F:\2012-01-27\13-35\ParticleStats_part2';
        elseif Case == 2
            data.chooseDay                    = 28;
            data.measurementTime              = 'Case cold 2012-01-28 12:17';
            data.measurementNumber            = 16;
            data.constInletCorr.windSpeed     = 9.86;
            data.airTemperature               = -15.87;
            data.HOLDirStats                  = 'F:\2012-01-28\12-17\ParticleStats_part';
        elseif Case == 3
            data.chooseDay                    = 29;
            data.measurementTime              = '2012-01-29 16:04';
            data.measurementNumber            = 23;
            data.constInletCorr.windSpeed     = 15.6;
            data.airTemperature               = -16.81;
            data.HOLDirStats                  = 'F:\2012-01-29\16-04\ParticleStats_part2';
        elseif Case == 4
            data.chooseDay                    = 27;
            data.measurementTime              = 'Case warm 2012-01-27 13:35 2';
            data.measurementNumber            = 6;
            data.constInletCorr.windSpeed     = 2.65;
            data.airTemperature               = -12.23;
            data.HOLDirStats                  = 'F:\2012-01-27\13-35\ParticleStats';
        else
            data.measurementTime              = 'unkown';
            data.measurementNumber            = 23;
            data.constInletCorr.windSpeed     = 5;
            data.airTemperature               = -10;
            data.HOLDirStats                  = '';
        end
        
        data.constInletCorr.pressure      = 656;    %[hPa]
        data.constInletCorr.temperature   = 273.15 + data.airTemperature; %[K]
        data.constInletCorr.massflow      = 59.0/2;  %[l/min]
        data.constInletCorr.dPipe         = 0.05;    %[m]
    
        data.psfilenames = dir(fullfile(data.HOLDirStats,'*_ps.mat'));
        data.psfilenames = {data.psfilenames.name};
        
        %load the file and merge them together
        for cnt = 1:numel(data.psfilenames)
            cnt
            tmp = load(fullfile(data.HOLDirStats,data.psfilenames{cnt}));
            if cnt == 1
                data=catstruct(data,tmp.dataParticle);
            else
                tmp = tmp.dataParticle;
                data.nPart           = [data.nPart tmp.nPart];
                data.partIsBorder    = [data.partIsBorder tmp.partIsBorder];
                data.partIsSatelite  = [data.partIsSatelite tmp.partIsSatelite];
                data.maxPh           = [data.maxPh tmp.maxPh];
                data.minPh           = [data.minPh tmp.minPh];
                data.pDiam           = [data.pDiam tmp.pDiam];
                data.pDiamFilled     = [data.pDiamFilled  tmp.pDiamFilled];
                data.pEssent           = [data.pEssent tmp.pEssent];
                data.xPos           = [data.xPos tmp.xPos];
                data.yPos           = [data.yPos tmp.yPos];
                data.zPos           = [data.zPos tmp.zPos];
                data.xyExtend          = [data.xyExtend tmp.xyExtend];
                data.zExtend          = [data.zExtend tmp.zExtend];
                data.timeHolo         = [data.timeHolo tmp.timeHolo];
                data.indHolo         = [data.indHolo tmp.indHolo+data.indHolo(end)];
            end
        end
        data.pDiamOldSizes = data.pDiam;
        data.pDiam = correction_diameter(data.pDiam);
        
        data.sampleSize.x      = (data.Nx - data.parameter.borderPixel)*data.cfg.dx;
        data.sampleSize.y      = (data.Ny - data.parameter.borderPixel)*data.cfg.dy;
        data.sampleSize.z      = data.parameter.lmaxZ - data.parameter.lminZ;
        data.sampleVolumeHolo  = data.sampleSize.x * data.sampleSize.y * data.sampleSize.z;
        data.sampleNumber      = data.indHolo(end);
        data.sampleVolumeAll   = data.sampleVolumeHolo * data.sampleNumber;
        
        data.blackListInd = unique(data.indHolo(data.pDiam >maxSizeHol*1e-06));
        data.partIsOnBlackList = false(1, numel(data.indHolo));
        for i = 1:numel(data.blackListInd)
            data.partIsOnBlackList = data.partIsOnBlackList | data.indHolo == data.blackListInd(i);
        end
        
        nanParticleInd = find(isnan(data.partIsSatelite));
        data.partIsSatelite(nanParticleInd) = 1;
        data.partIsBorder(nanParticleInd) = 1;
        
        data.partIsReal     = ~data.partIsSatelite & ~data.partIsBorder & ~data.partIsOnBlackList;
        data.partIsRealAll  = ~data.partIsSatelite & ~data.partIsBorder;
        data.realInd = find(data.partIsReal);
        
            
        % %old
        % divideSize = 20;
        % maxSize = 250;
        
        % bigInd = 20;
        % smallBorder = (( 0.5 : 2389.5)*data.cfg.dx*data.cfg.dy*4/pi).^(1/2)*1000000;
        % divideInd = find(smallBorder > divideSize, 1 ,'first');
        % bigBorder = logspace(log10(smallBorder(divideInd)),log10(maxSize),bigInd);
        % partBorder = [smallBorder(1:(divideInd-1)) bigBorder];
        
        maxBin = pi/4*(maxSize./1e6)^2./data.cfg.dx./data.cfg.dy;
        cnt = 1;        
        while floor(exp(cnt*0.25)) <= maxBin
            numberBin(cnt) = floor(exp(cnt*0.25));
            cnt = cnt+1;
        end
        numberBin = [5 numberBin];
        partBorder = 0.5;
        for i = 1:numel(numberBin)
            partBorder(i+1) = partBorder(i)+ numberBin(i);
        end
        partBorder = (partBorder*data.cfg.dx*data.cfg.dy*4/pi).^(1/2)*1000000;
        %second change
        partBorderOld = partBorder;
        smallBorder = partBorder(1: find(partBorder>divideSize,1));
        bigBorder = logspace(log10(smallBorder(end)),log10(1000),10);
        partBorder = [smallBorder bigBorder(2:end)];
        
        %size correction of partBorder
        partBorderOld = partBorder;
        partBorder = correction_diameter(partBorder*1e-6)*1e6;
        
        tmp = partBorder;
        tmp(1) = [];
        partBorder(end) = [];
        edgesSize = tmp - partBorder;
        middle = (tmp + partBorder)/2;
        
        %data.histAll = histogram(data.pDiam*1000000, data.sampleVolumeAll, partBorder);
        [data.histReal, data.edges, data.middle, data.limit, data.histRealError] = ...
            histogram(data.pDiam(data.partIsReal)*1000000, data.sampleVolumeAll, partBorder);
        [data.histRealOldSizes data.edgesOld, data.middleOld, data.limitOld, data.histRealErrorOld] = ...
            histogram(data.pDiamOldSizes(data.partIsReal)*1000000, data.sampleVolumeAll, partBorderOld);
        %data.histRealAll = histogram(data.pDiam(data.partIsRealAll)*1000000, data.sampleVolumeAll, partBorder);
        data.histRealCor = data.histReal./Paik_inert(data.middle/1000000, data.constInletCorr);
        data.histRealCorOldSizes = data.histRealOldSizes./Paik_inert(data.middleOld/1000000, data.constInletCorr);
        data.histRealErrorCor =  data.histRealError./Paik_inert(data.middle/1000000, data.constInletCorr);
        data.histRealErrorCorOld = data.histRealErrorOld./Paik_inert(data.middleOld/1000000, data.constInletCorr);
        data.histRealCount =  histc(data.pDiam(data.partIsReal)*1000000, partBorder(1:end-1));
        data.histRealCountCor = data.histRealCount./Paik_inert(data.middle/1000000, data.constInletCorr);
        
        dataAll{Case}=data;
    end
end

%% Frequence of Occurance
if any(choosePlots == 2)
    figure(2);
    clf
    
    subplot(2,2,1)
    plot(middle1,histAll,middle3,histRealAll,  ...
        middle2, histReal./Paik_inert(middle2/1000000, constInletCorr),'LineWidth',2);
    
    ylabel('number density d(N)/d(log d) [cm^{-3}/\mum]');
    xlabel('diameter [\mum]')
    title('size distribution')
    legend('all Particle','real Particle','real Particle corrected');
    xlim([2 maxSize]);
    ylim([1e-6 10000]);
    set(gca,'YScale','log')
    set(gca,'XScale','log')
    
    data.allPart = [];
    data.realPart = [];
    data.bigPart = [];
    for nHolo = unique(data.indHolo)
        tmp  = data.indHolo == nHolo;
        tmp2 = tmp & data.partIsReal;
        tmp3 = tmp2 & data.pDiam > 15e-6;
        data.allPart  = [data.allPart sum(tmp)];
        data.realPart = [data.realPart sum(tmp2)];
        data.bigPart  = [data.bigPart sum(tmp3)];
    end
    
    subplot(2,2,2)
    hist(data.allPart);
    ylabel('frequency of occurance')
    xlabel('number of particles')
    title('particle number per hologramm - all Particle')
    ylim([0 nHolo]);
    
    subplot(2,2,3)
    hist(data.realPart);
    ylabel('frequency of occurance')
    xlabel('number of particles')
    title('particle number per hologramm - real Particle')
    ylim([0 nHolo]);
    
    subplot(2,2,4)
    hist(data.bigPart);
    ylabel('frequency of occurance')
    xlabel('number of particles')
    title('particle number per hologramm - real Particle > 15 \mum')
    ylim([0 nHolo]);
    
    mtit(measurementTime);
end

if any(choosePlots == 3 | choosePlots == 4 | choosePlots == 6  | choosePlots == 8)
    
    %tsAll  = timeSerieAnalysis(data, intervall, constInletCorr);
    tsReal    = timeSerieAnalysis(data, intervall, constInletCorr, data.partIsReal);
    %tsRealAll = timeSerieAnalysis(data, intervall, constInletCorr, data.partIsRealAll);
    
end

%% Time Serie Water Content
if any(choosePlots == 3)
    figure(3)
    clf
    
    ymax = 0.4;
    ymaxCount = 4;
    if exist('tsReal.IWC')
        xIce = find(tsReal.IWC > max(tsReal.IWC)*0.5);
        xIce = (xIce-1)*intervall;
        yIce = ones(1,numel(xIce))*ymax;
        yIce2 = ones(1,numel(xIce))*ymaxCount;
    else
        xIce = 0;
        yIce = 0;
        yIce2 = 0;
    end
    
    subplot(4,1,1);
    hold on;
    stem(xIce,yIce,'r','marker','none');
    hold on;
    plot((tsReal.Intervall-1)*intervall, tsReal.TWC, 'LineWidth',2);
    
    title('Total Water Content');
    %xlim([0 600]);
    %ylim([0 ymax]);
    ylabel('WC [g/m^3]');
    xlabel('Measurement time [s]');
    
    
    
    subplot(4,1,2);
    hold on;
    stem(xIce,yIce,'r','marker','none');
    hold on;
    plot((tsReal.Intervall-1)*intervall, tsReal.LWC, 'LineWidth',2);
    
    title('Water Content d < 15 \mum');
    %xlim([0 600]);
    %ylim([0 ymax]);
    ylabel('WC [g/m^3]');
    xlabel('Measurement time [s]');
    
    subplot(4,1,3);
    hold on;
    stem(xIce,yIce,'r','marker','none');
    hold on;
    plot((tsReal.Intervall-1)*intervall, tsReal.IWC, 'LineWidth',2);
    
    ylabel('WC [g/m^3]');
    xlabel('Measurement time [s]');
    title('Water Content d > 15 \mum');
    %xlim([0 600]);
    %ylim([0 0.1]);
    xlabel('Measurement time [s]');
    
    subplot(4,1,4);
    hold on;
    stem(xIce,yIce2,'r','marker','none');
    hold on;
    plot((tsReal.Intervall-1)*intervall, tsReal.IWCCount, 'LineWidth',2);
    
    ylabel('Number Count');
    xlabel('Measurement time [s]');
    title('Particle d > 15 \mum');
    %xlim([0 600]);
    %ylim([0 ymaxCount]);
    xlabel('Measurement time [s]');
    
    
    mtit(measurementTime);
end

%% TimeSerie Fraction
if any(choosePlots == 8)
    figure(8)
    clf
    
    ymax = 0.5;
    ymaxCount = 10;
    if exist('tsReal.IWC')
        xIce = find(tsReal.IWC > max(tsReal.IWC)*0.5);
        xIce = (xIce-1)*intervall;
        yIce = ones(1,numel(xIce))*ymax;
        yIce2 = ones(1,numel(xIce))*ymaxCount;
    else
        xIce = 0;
        yIce = 0;
        yIce2 = 0;
    end
    
    s(1)=axes('position',[.17 .71 .80 .27]);
    hold on;
    stem(xIce,yIce,'r','marker','none');
    hold on;
    plot((tsReal.Intervall-1)*intervall, tsReal.TWC, 'LineWidth',2);
    box on
    %xlim([0 600]);
    %ylim([0 ymax]);
    set(gca,'XTickLabel',[]);
    ylabel({'Total water','content [g/m^3]'},'FontSize',18);
    set(gca,'XTickLabel',[]);
    
    
    s(2)=axes('position',[.17 .41 .80 .27]);
    hold on;
    stem(xIce,yIce,'r','marker','none');
    hold on;
    plot((tsReal.Intervall-1)*intervall, tsReal.IWC./tsReal.TWC, 'LineWidth',2);
    box on
    %xlim([0 600]);
    %ylim([0 1]);
    set(gca,'XTickLabel',[]);
    ylabel({'Volume fraction','ice/total'},'FontSize',18);
    
    
    s(3)=axes('position',[.17 .09 .80 .27]);
    hold on;
    stem(xIce,yIce,'r','marker','none');
    hold on;
    plot((tsReal.Intervall-1)*intervall, tsReal.IWCCount./tsReal.TWCCount, 'LineWidth',2);
    box on
    ylabel({'Number fraction', 'ice/total'},'FontSize',18);
    %xlim([0 600]);
    %ylim([0 4e-3]);
    xlabel('Measurement time [s]','FontSize',18);
    
    
    % subplot(3,1,3);
    % hold on;
    % stem(xIce,yIce,'r','marker','none');
    % hold on;
    % [AX,H1,H2] = plotyy((tsReal.Intervall-1)*intervall, tsReal.IWC,...
    %     (tsReal.Intervall-1)*intervall, tsReal.IWCCount);
    %
    % set(get(AX(1),'Ylabel'),'String','Water Content [g/m^3]')
    % set(get(AX(2),'Ylabel'),'String','Number')
    % title('Water Content d > 15 \mum');
    % %xlim([0 600]);
    % %ylim([0 ymax]);
    % set(H1,'LineWidth',2)
    % set(H2,'LineWidth',2)
    % xlabel('Measurement time [s]');
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 15 19]);
    set(gcf, 'PaperSize', [2 10]);
    print('-dpng','-r600', [num2str(chooseDay) '_08_TimeSerieFraction'])
    
end

%% TimeSerie Histogram
if any(choosePlots == 4)
    figure(4)
    clf
    % wf = mesh(tsAll.Histogram);
    % set(wf, 'LineWidth', 2);
    % set(gca,'ZScale','log')
    % set(gca,'XScale','log')
    % hold on
    % wf2 = mesh(tsRealNeu.HistogramCorr);
    % set(wf2, 'LineWidth', 2);
    % set(gca,'ZScale','log')
    % set(gca,'XScale','log')
    % hold on
    wf3 = surf(tsReal.middle, tsReal.MeasTime, tsReal.HistogramCorr);
    set(wf3, 'LineWidth', 2);
    set(gca,'ZScale','log')
    set(gca,'XScale','log')
    zlabel('number density d(N)/d(log d) [cm^{-3}/\mum]');
    ylabel('measurment time [s]');
    xlabel('diameter [\mum]')
    xlim([2 maxSize])
    title([measurementTime ' Time serie of particle number density'])
end


%% Histogram Compare to Fog Monitor
if any(choosePlots == 5)
    a=figure(5)
    clf   
    clear plotDataHOL plotDataFM plotDataHOLCor
    for cnt =1:numel(dataAll);
        %start Data_input_all onces
        mn = dataAll{cnt}.measurementNumber;
        
        clear s;
        %Reduce Sonic Data to CCD_Duration and only use every n data point
        n = 1;
        Sonic_xlimit_all=[];
        
        for CCD_n=mn
            Sonic_xlimit_indice = [find(Sonic_Date_Num>CCD_duration_datenum(CCD_n,1),1,'first') find(Sonic_Date_Num>CCD_duration_datenum(CCD_n,2),1,'first')];
            Sonic_xlimit_all = [Sonic_xlimit_all; Sonic_xlimit_indice];
        end
        
        %Reduce Fog Monitor to CCD_Duration and only use every n data point
        n = 1;
        FM_xlimit_all=[];
        for CCD_n=mn
            FM_xlimit_indice = [find(FM_Date_Num>CCD_duration_datenum(CCD_n,1),1,'first') find(FM_Date_Num>CCD_duration_datenum(CCD_n,2),1,'first')];
            FM_xlimit_all = [FM_xlimit_all; FM_xlimit_indice];
        end
        
        %data2=thin_data2(Sonic_Date_Num,xlimit_all,n);
        x_counter=1:length(thin_data2(FM_FM_100_Bin_1,FM_xlimit_all,n));
        
        FM_Sizes=[2,4,6,8,10,12,14,16,18,20,23,26,29,32,35,38,41,44,47,50];
        binFirst = 2*FM_Sizes(1) - FM_Sizes(2);
        binLast = 2*FM_Sizes(end) - FM_Sizes(end-1);
        tmp1 = [binFirst  FM_Sizes];
        tmp2 = [FM_Sizes  binLast];
        FM_BinBorders = (tmp1+tmp2)/2;
        FM_BinSize = FM_BinBorders(2:end)-FM_BinBorders(1:end-1);
        %set(gcf,'position',[0 0 1024 1024])
        z=ones(length(x_counter),1);
        tmp2=zeros(1,20);
        for i=1:20
            tmp=['sum(thin_data2(FM_FM_100_Bin_',num2str(i),',FM_xlimit_all,n))'];
            tmp = eval(tmp);
            tmp2(1,i)=tmp;
        end
        
        FM_SampleArea = 0.24/1000000;
        FM_SampleSpeed = 11;
        FM_SampleTime = FM_Date2(FM_xlimit_all(2),6)-FM_Date2(FM_xlimit_all(1),6);
        FM_SampleVolume = FM_SampleArea*FM_SampleSpeed*FM_SampleTime;
        FM_Data{cnt}.histNumber=tmp2./FM_BinSize/FM_SampleVolume/1000000;
        FM_Data{cnt}.histNumberError=(tmp2.^(1/2))./FM_BinSize/FM_SampleVolume/1000000;
        %
        %     scatter(FM_Sizes,tmp2./FM_Sizes/FM_SampleVolume/1000000);
        %     hold on;
        plotcolors = ['g';'b';'k';'c'];
        
        
        plotDataHOL(:,1) = dataAll{cnt}.middle;
        plotDataHOL(:,1+cnt) = dataAll{cnt}.histReal;
        plotDataHOL(:,1+cnt+numel(dataAll)) = dataAll{cnt}.histRealError;    
        save('JanNumbHistHOL.mat','plotDataHOL');
      
        plotDataHOLCor(:,1) = dataAll{cnt}.middle;
        plotDataHOLCor(:,1+cnt) = dataAll{cnt}.histRealCor;
        plotDataHOLCor(:,1+cnt+numel(dataAll)) = dataAll{cnt}.histRealErrorCor;       
        save('JanNumbHistHOLCor.mat','plotDataHOLCor');
        
        plotDataHOLOld(:,1) = dataAll{cnt}.middleOld;
        plotDataHOLOld(:,1+cnt) = dataAll{cnt}.histRealOldSizes;
        plotDataHOLOld(:,1+cnt+numel(dataAll)) = dataAll{cnt}.histRealErrorOld;    
        save('JanNumbHistHOLOld.mat','plotDataHOLOld');
        
        plotDataHOLCorOld(:,1) = dataAll{cnt}.middleOld;
        plotDataHOLCorOld(:,1+cnt) = dataAll{cnt}.histRealCorOldSizes;
        plotDataHOLCorOld(:,1+cnt+numel(dataAll)) = dataAll{cnt}.histRealErrorCorOld;    
        save('JanNumbHistHOLCorOld.mat','plotDataHOLCorOld');      
        
        clear plotDataFM
        plotDataFM(:,1) = FM_Sizes;
        plotDataFM(:,1+cnt) = FM_Data{cnt}.histNumber; 
        plotDataFM(:,1+cnt+numel(dataAll)) = FM_Data{cnt}.histNumberError; 
        save('JanNumbHistFM.mat','plotDataFM');     
        
        plot(dataAll{cnt}.middle, dataAll{cnt}.histRealCor, ['-' plotcolors(cnt)],...
            dataAll{cnt}.middleOld, dataAll{cnt}.histRealCorOldSizes, ['--' plotcolors(cnt)],...
            'LineWidth',2);
            %FM_Sizes,FM_Data{cnt}.histNumber , [':' plotcolors(cnt)],...
            
        hold on
        %middle2, limit2./Paik_inert(middle2/1000000, constInletCorr),...
    end
    
    legend('HOLIMO old','HOLIMO size corrected');
    ylabel('number density d(N)/d(log d) [cm^{-3}/\mum]');
    xlabel('diameter [\mum]')
    xlim([2 maxSize]);
    ylim([3e-6 1e3]);
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    
    set(gcf, 'Units', 'centimeters');
    set(gcf, 'OuterPosition', [5 5 12 14]);
    ax = get(gcf, 'CurrentAxes');
    
    % make it tight
    ti = get(ax,'TightInset');
    set(ax,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
    
    % adjust the papersize
    set(ax,'units','centimeters');
    pos = get(ax,'Position');
    ti = get(ax,'TightInset');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition',[0 0  pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    
    print('-dpng','-r600', 'January_05_NumberConCompareFM')
end

%% Histogramm Volume Density
if any(choosePlots == 7)
    a=figure(7)
    clf   
    clear plotDataHOL plotDataFM
      for cnt =1:numel(dataAll);
        %start Data_input_all onces
        mn = dataAll{cnt}.measurementNumber;
        
        clear s;
        %Reduce Sonic Data to CCD_Duration and only use every n data point
        n = 1;
        Sonic_xlimit_all=[];
        
        for CCD_n=mn
            Sonic_xlimit_indice = [find(Sonic_Date_Num>CCD_duration_datenum(CCD_n,1),1,'first') find(Sonic_Date_Num>CCD_duration_datenum(CCD_n,2),1,'first')];
            Sonic_xlimit_all = [Sonic_xlimit_all; Sonic_xlimit_indice];
        end
        
        %Reduce Fog Monitor to CCD_Duration and only use every n data point
        n = 1;
        FM_xlimit_all=[];
        for CCD_n=mn
            FM_xlimit_indice = [find(FM_Date_Num>CCD_duration_datenum(CCD_n,1),1,'first') find(FM_Date_Num>CCD_duration_datenum(CCD_n,2),1,'first')];
            FM_xlimit_all = [FM_xlimit_all; FM_xlimit_indice];
        end
        
        %data2=thin_data2(Sonic_Date_Num,xlimit_all,n);
        x_counter=1:length(thin_data2(FM_FM_100_Bin_1,FM_xlimit_all,n));
        
        FM_Sizes=[2,4,6,8,10,12,14,16,18,20,23,26,29,32,35,38,41,44,47,50];
        binFirst = 2*FM_Sizes(1) - FM_Sizes(2);
        binLast = 2*FM_Sizes(end) - FM_Sizes(end-1);
        tmp1 = [binFirst  FM_Sizes];
        tmp2 = [FM_Sizes  binLast];
        FM_BinBorders = (tmp1+tmp2)/2;
        FM_BinSize = FM_BinBorders(2:end)-FM_BinBorders(1:end-1);
        %set(gcf,'position',[0 0 1024 1024])
        z=ones(length(x_counter),1);
        tmp2=zeros(1,20);
        for i=1:20
            tmp=['sum(thin_data2(FM_FM_100_Bin_',num2str(i),',FM_xlimit_all,n))'];
            tmp = eval(tmp);
            tmp2(1,i)=tmp;
        end
        
        FM_SampleArea = 0.24/1000000;
        FM_SampleSpeed = 11;
        FM_SampleTime = FM_Date2(FM_xlimit_all(2),6)-FM_Date2(FM_xlimit_all(1),6);
        FM_SampleVolume = FM_SampleArea*FM_SampleSpeed*FM_SampleTime;
        FM_Data{cnt}.histNumber=tmp2./FM_BinSize/FM_SampleVolume/1000000;
        FM_Data{cnt}.histNumberError=tmp2.^(1/2)./FM_BinSize/FM_SampleVolume/1000000;
        %
        %     scatter(FM_Sizes,tmp2./FM_Sizes/FM_SampleVolume/1000000);
        %     hold on;      
       
        
        plotDataHOL(:,1) = dataAll{cnt}.middle;
        plotDataHOL(:,1+cnt) = dataAll{cnt}.histReal.*(1/6*pi.*dataAll{cnt}.middle.^3);
        plotDataHOL(:,1+cnt+numel(dataAll)) = dataAll{cnt}.histRealError.*(1/6*pi.*dataAll{cnt}.middle.^3);
        save('JanVolHistHOL.mat','plotDataHOL');
        
        
        plotDataHOLCor(:,1) = dataAll{cnt}.middle;
        plotDataHOLCor(:,1+cnt) = dataAll{cnt}.histRealCor.*(1/6*pi.*dataAll{cnt}.middle.^3);
        plotDataHOLCor(:,1+cnt+numel(dataAll)) = dataAll{cnt}.histRealErrorCor.*(1/6*pi.*dataAll{cnt}.middle.^3);    
        save('JanVolHistHOLCor.mat','plotDataHOLCor');
        
        
        plotDataHOLOld(:,1) = dataAll{cnt}.middleOld;
        plotDataHOLOld(:,1+cnt) = dataAll{cnt}.histRealOldSizes.*(1/6*pi.*dataAll{cnt}.middleOld.^3);
        plotDataHOLOld(:,1+cnt+numel(dataAll)) = dataAll{cnt}.histRealErrorOld.*(1/6*pi.*dataAll{cnt}.middleOld.^3);
        save('JanVolHistHOLOld.mat','plotDataHOLOld');
        
        
        plotDataHOLCorOld(:,1) = dataAll{cnt}.middleOld;
        plotDataHOLCorOld(:,1+cnt) = dataAll{cnt}.histRealCorOldSizes.*(1/6*pi.*dataAll{cnt}.middleOld.^3);
        plotDataHOLCorOld(:,1+cnt+numel(dataAll)) = dataAll{cnt}.histRealErrorCorOld.*(1/6*pi.*dataAll{cnt}.middleOld.^3);  
        save('JanVolHistHOLCorOld.mat','plotDataHOLCorOld');      
        
        
        plotDataFM(:,1) = FM_Sizes;
        plotDataFM(:,1+cnt) = FM_Data{cnt}.histNumber.*(1/6*pi.*FM_Sizes.^3);
        plotDataFM(:,1+cnt+numel(dataAll)) = FM_Data{cnt}.histNumberError.*(1/6*pi.*FM_Sizes.^3); 
        save('JanVolHistFM.mat','plotDataFM');        
        
        plot(dataAll{cnt}.middle, plotDataHOL(:,1+cnt), ['-' plotcolors(cnt)],...
            FM_Sizes, plotDataFM(:,1+cnt) , [':' plotcolors(cnt)],...
            'LineWidth',2);
        hold on
        %middle2, limit2./Paik_inert(middle2/1000000, constInletCorr),...
    end
    
    legend('HOLIMO','Fog Monitor','Detection Limit');
    ylabel('volume density d(V)/d(log d) [cm^{-3}*\mum^2]');
    xlabel('diameter [\mum]')
    xlim([2 maxSize]);
    ylim([3e-1 1e5]);
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    
    set(gcf, 'Units', 'centimeters');
    set(gcf, 'OuterPosition', [5 5 12 14]);
    ax = get(gcf, 'CurrentAxes');
    
    % make it tight
    ti = get(ax,'TightInset');
    set(ax,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
    
    % adjust the papersize
    set(ax,'units','centimeters');
    pos = get(ax,'Position');
    ti = get(ax,'TightInset');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition',[0 0  pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    
    print('-dpng','-r600', 'January_05_VolumeConCompareFM')
end

%% TimeSerie Mean D / Number compare to Fog Monitor
if any(choosePlots == 6)
    figure(6)
    clf
    
    MeasNumber = measurementNumber;
    
    n = ceil(intervall);
    clear s;
    %Reduce Sonic Data to CCD_Duration and only use every n data point
    Sonic_xlimit_indice = [find(Sonic_Date_Num>CCD_duration_datenum(MeasNumber,1),1,'first') find(Sonic_Date_Num>CCD_duration_datenum(MeasNumber,2),1,'first')];
    Sonic_Time=thin_data2(Sonic_Date_Num,Sonic_xlimit_indice,n);
    Sonic_Intervall=[Sonic_Time(1) Sonic_Time(end)];
    x_counter_sonic=(1:length(thin_data2(T_acoustic,Sonic_xlimit_indice,n)))';
    set(gcf,'DefaultLineLineWidth',2);
    
    %Reduce Fog Monitor to CCD_Duration and only use every n data point
    FM_xlimit_indice = [find(FM_Date_Num>CCD_duration_datenum(MeasNumber,1),1,'first') find(FM_Date_Num>CCD_duration_datenum(MeasNumber,2),1,'first')];
    FM_Time=thin_data2(FM_Date_Num,FM_xlimit_indice,n);
    FM_Intervall=[FM_Time(1) FM_Time(end)];
    x_counter=(1:length(thin_data2(FM_Over_Range,FM_xlimit_indice,n)))';
    
    TimeFM   = (FM_Time - FM_Time(1))*24*3600;
    
    axnumber = 3;
    for m=1:axnumber
        axleft = 0.10;
        axright = 0.01;
        axtop = 0.01;
        axbottom = 0.08;
        axwidth = 1-axleft-axright;
        axheight = (1-axbottom-axtop)./axnumber;
        axPos(m,:) = [axleft axbottom+(m-1)*axheight axwidth axheight];
    end
    
    s(1)=axes('position',axPos(3,:));
    plot((tsReal.Intervall-1)*intervall, tsReal.MeanD * 1000000,...
        TimeFM, thin_data2(FM_ED__um_,FM_xlimit_indice,n));
    xlim([0 600]);
    ylim([0 12]);
    ylabel({'Mean diameter', '[\mum]'},'fontsize',18);
    set(gca,'XTickLabel',[]);
    %xlabel('Measurement time [s]');
    legend('HOLIMO','Fog Monitor','Location','SouthEast');
    
    s(2)=axes('position',axPos(2,:));
    plot((tsReal.Intervall-1)*intervall, tsReal.TWCCount ./ tsReal.SampleVolume / 1000000, ...
        TimeFM, thin_data2(FM_Number_Conc____cm_3_,FM_xlimit_indice,n).*thin_data2(FM_PAS__m_s_,FM_xlimit_indice,n)./11);
    xlim([0 600]);
    ylim([0 700]);
    ylabel({'Number Concentration' ,'[1/cm^3]'},'fontsize',18)
    xlabel('Measurement time [s]','fontsize',18);
    
    s(1)=axes('position',axPos(1,:));
    
    plot((tsReal.Intervall-1)*intervall, tsReal.TWC, ...
        TimeFM, thin_data2(FM_LWC__g_cm_3_,FM_xlimit_indice,n).*thin_data2(FM_PAS__m_s_,FM_xlimit_indice,n)./11);
    box on
    %xlim([0 600]);
    %ylim([0 ymax]);
    set(gca,'XTickLabel',[]);
    ylabel({'Total water','content [g/m^3]'},'FontSize',18);
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 30 20]);
    print('-dpng','-r600', [num2str(chooseDay) '_06_MeanDNumberFog'])
    
end
