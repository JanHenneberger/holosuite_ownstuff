%% Start up
choosePlots = [4 5 7 6];
savePlots = true;
%1 Spatial analysis check
%2 Frequenzy of Occurance check
%3 Time Serie Water Content
%4 Contour Plot Histogram
%5 Histogram Number Density 
%6 TimeSerie Mean D / Number 
%7 Histogram Volume Density
%8 TimeSerie Fraction

intervall =130;

measurementTime              = '2012-04-14';
constInletCorr.windSpeed     = nanmean(data.measMeanV);
constInletCorr.massflow      = 86/2;%nanmean(data.measMeanFlow)/2;
constInletCorr.temperature   = nanmean(data.measMeanT)+273.15;
constInletCorr.pressure      = 656;    %[hPa]
constInletCorr.dPipe         = 0.05;    %[m]

set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);
if ~exist('data', 'var')
% if no input --> load file in current directory
%if nargin == 0, inFiles = pwd; end

%find all ps files
%if isdir(inFiles)
%    cd(inFiles)
%    
psfilenames = dir('*_ps.mat');
psfilenames = {psfilenames.name};
%else
%    psfilenames = {inFiles};
%end
end
%% Spatial Analysis
if any(choosePlots == 1)
figure(1);
clf;

subplot(3,2,1);
hold on;
[a b] = hist(data.xPos(data.partIsReal).*1e3,30);
[c d] = hist(data.xPos(data.partIsRealCor).*1e3,b);
a = a./(sum(a)/numel(a))-1;
c = c./(sum(c)/numel(c))-1;
e = [a;c]';
bar(b,a)
hold on
bar(b,e)
xlim([-2.2 2.2]);
ylim([-.2 .2]);
title('Y position frequency');
xlabel('Y Position (mm)');
ylabel('Relative Count');

subplot(3,2,3);
hold on;
[a b] = hist(data.yPos(data.partIsReal).*1e3,30);
[c d] = hist(data.yPos(data.partIsRealCor).*1e3,b);
a = a./(sum(a)/numel(a))-1;
c = c./(sum(c)/numel(c))-1;
e = [a;c]';
bar(b,a)
hold on
bar(b,e)
xlim([-1.8 1.8]);
ylim([-.2 .2]);
title('X position frequency');
xlabel('X Position (mm)');
ylabel('Relative Count');

subplot(3,2,5);
hold on;
[a b] = hist(data.zPos(data.partIsReal).*1e3,30);
[c d] = hist(data.zPos(data.partIsRealCor).*1e3,b);
a = a./(sum(a)/numel(a))-1;
c = c./(sum(c)/numel(c))-1;
e = [a;c]';
%bar(b,a)
hold on
bar(b,e)
ylim([-.4 .4]);
title('Z position frequency');
xlabel('Z Position (mm)');
ylabel('Relative Count');

subplot(3,2,[2 4 6]);
bln = .1e-3;
x = data.xPos(data.partIsRealCor);
y = data.yPos(data.partIsRealCor);
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
caxis([-.2 .2]);

mtit(measurementTime);
end
% %old
% divideSize = 20;
% maxSize = 250;
% bigInd = 20;
% smallBorder = (( 0.5 : 2389.5)*data.cfg.dx*data.cfg.dy*4/pi).^(1/2)*1000000;
% divideInd = find(smallBorder > divideSize, 1 ,'first');
% bigBorder = logspace(log10(smallBorder(divideInd)),log10(maxSize),bigInd);
% partBorder = [smallBorder(1:(divideInd-1)) bigBorder]; 
maxSize = 250;
divideSize = 34;
maxBin = pi/4*(maxSize./1e6)^2./data.cfg.dx./data.cfg.dy;
cnt = 2;
while cnt^2 <= maxBin
    numberBin(cnt-1) = cnt^2;
    cnt = cnt+1;
end
numberBin = [1 1 2 numberBin];
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

tmp = partBorder;
tmp(1) = [];
partBorder(end) = [];
edgesSize = tmp - partBorder;
middle = (tmp + partBorder)/2;


[histAll, edges1, middle1, limit1] = ...
    histogram(data.pDiam*1000000, data.sampleVolumeAll, partBorder);
[histReal, edges2, middle2, limit2, histRealError] = ...
    histogram(data.pDiam(data.partIsReal)*1000000, data.sampleVolumeAll, partBorder);
[histRealCor, edges2, middle2, limit2, histRealCorError] = ...
    histogram(data.pDiam(data.partIsRealCor)*1000000, data.sampleVolumeCor, partBorder);
[histRealCorOld, edgesOld, middleOld, limitOld, histRealCorOldError] = ...
    histogram(data.pDiam(data.partIsRealCor)*1000000, data.sampleVolumeCor, partBorderOld);
[histRealAll, edges3, middle3, limit3, histRealAllError] = ...
    histogram(data.pDiam(data.partIsRealAll)*1000000, data.sampleVolumeAll, partBorder);
[histRealAllCor, edges3, middle3, limit3, histRealAllCorError] = ...
    histogram(data.pDiam(data.partIsRealAllCor)*1000000,  data.sampleVolumeAllCor , partBorder);


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

if any(choosePlots == 3 | choosePlots == 4 | choosePlots == 6 | choosePlots == 7 | choosePlots == 8)

    if ~exist('tsRealCor')
        %tsAll  = timeSerieAnalysis(data, intervall, constInletCorr);
        %tsReal    = timeSerieAnalysisApril(data, intervall, constInletCorr, data.partIsReal);
        tsRealCor    = timeSerieAnalysisApril(data, intervall, constInletCorr, data.partIsRealCor);
        %tsRealAll = timeSerieAnalysisApril(data, intervall, constInletCorr, data.partIsRealAll);
        tsRealAllCor = timeSerieAnalysisApril(data, intervall, constInletCorr, data.partIsRealAll);
    end
end
measTime = tsRealCor.StartTime-tsRealCor.StartTime(1);
measTime = measTime/60/60;

measTimeLT = conTime2Vec(tsRealCor.StartTime)';
tmp = size(measTimeLT,1);
measTimeLT = [ones(tmp,1)*2012  ones(tmp,1)*04  measTimeLT(:,1:4)];
measTimeUTC = measTimeLT;
measTimeUTC(:,4) = measTimeUTC(:,4)-2; 
measTimeNumLT = datenum(measTimeLT);
measTimeNumUTC = datenum(measTimeUTC);
%% Time Serie Water Content
if any(choosePlots == 3)
figure(3)
clf

ymax = 0.4;
ymaxCount = 4;
if exist('tsRealCor.IWC')
    xIce = find(tsRealCor.IWC > max(tsRealCor.IWC)*0.5);
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
plot(measTime, tsRealCor.TWC, ...
    measTime, tsRealAllCor.TWC,'LineWidth',2);
 
title('Total Water Content');
%xlim([0 7000]);
%ylim([0 ymax]);
ylabel('WC [g/m^3]');
xlabel('Measurement time [h]');



subplot(4,1,2);
hold on;
stem(xIce,yIce,'r','marker','none');
hold on;
plot(measTime, tsRealCor.LWC, ...
    measTime,tsRealAllCor.LWC,'LineWidth',2);

title('Water Content d < 20 \mum');
%xlim([0 600]);
%ylim([0 ymax]);
ylabel('WC [g/m^3]');
xlabel('Measurement time [h]');

subplot(4,1,3);
hold on;
stem(xIce,yIce,'r','marker','none');
hold on;
plot(measTime, tsRealCor.IWC, ...
    measTime, tsRealAllCor.IWC, 'LineWidth',2);

ylabel('WC [g/m^3]');
xlabel('Measurement time [s]');
title('Water Content d > 20 \mum');
%xlim([0 600]);
%ylim([0 0.1]);
xlabel('Measurement time [h]');

subplot(4,1,4);
hold on;
stem(xIce,yIce2,'r','marker','none');
hold on;
plot(measTime, tsRealCor.IWCCount, ...
    measTime, tsRealAllCor.IWCCount, 'LineWidth',2);

ylabel('Number Count');
xlabel('Measurement time [s]');
title('Particle d > 20 \mum');
%xlim([0 600]);
%ylim([0 ymaxCount]);
xlabel('Measurement time [h]');


mtit(measurementTime);
end

%% TimeSerie Fraction
if any(choosePlots == 8)
figure(8)
clf

    axnumber = 2;
    for m=1:axnumber
        axleft = 0.10;
        axright = 0.01;
        axtop = 0.01;
        axbottom = 0.08;
        axwidth = 1-axleft-axright;
        axheight = (1-axbottom-axtop)./axnumber;
        axPos(m,:) = [axleft axbottom+(m-1)*axheight axwidth axheight];
    end
s(1)=axes('position',axPos(2,:));
plot(measTime, tsRealCor.TWC,...
    measTime, tsRealCor.LWC,...
    measTime, tsRealCor.IWC,...
    measTime, smooth(tsRealCor.TWC,0.1,'rlowess'),'b',...
    measTime, smooth(tsRealCor.LWC,0.1,'rlowess'),'g',...
    measTime, smooth(tsRealCor.IWC,0.1,'rlowess'),'r',...
    'LineWidth',2);
box on
%xlim([0 7000]);
ylim([0 .7]);
set(gca,'XTickLabel',[]);
ylabel({'Water content','[g/m^3]'},'FontSize',18);
legend('TW','LW','IW');

s(2)=axes('position',axPos(1,:));

plot(measTime, tsRealCor.TWCon,...
    measTime, tsRealCor.LWCon,...
    measTime, tsRealCor.IWCon*1000,...
    measTime, smooth(tsRealCor.TWCon,0.1,'rlowess'),'b',...
    measTime, smooth(tsRealCor.LWCon,0.1,'rlowess'),'g',...
    measTime, smooth(tsRealCor.IWCon*1000,0.1,'rlowess'),'r',...
    'LineWidth',2);
box on
%xlim([0 7000]);
ylim([0 450]);
xlabel('Measurement time [s]','FontSize',18);
ylabel({'Number Concentraction','[1/cm^3]'},'FontSize',18);
legend('TW','LW','IW*1000');

% 
% s(3)=axes('position',axPos(1,:));
% 
% plot(measTime, tsRealCor.IWCon./tsRealCor.TWCon*1000, ...
%     measTime, tsRealCor.IWC./tsRealCor.TWC,'LineWidth',2);
% box on
% ylabel({'xxx', 'xxx'},'FontSize',18);
% %xlim([0 7000]);
% ylim([0 10]);
% xlabel('Measurement time [s]','FontSize',18);
% legend('IW/TW Con*1000','IWC/TWC');

% subplot(3,1,3);
% hold on;
% stem(xIce,yIce,'r','marker','none');
% hold on;
% [AX,H1,H2] = plotyy((tsRealCor.Intervall-1)*intervall, tsRealCor.IWC,...
%     (tsRealCor.Intervall-1)*intervall, tsRealCor.IWCCount);
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
    set(gcf, 'PaperSize', [15 19]);  
    if savePlots
    print('-dpdf','-r600', 'Fraction.png')
    end
end

%% TimeSerie Histogram
if any(choosePlots == 4)
    f4=figure(4)
    clf
    plotXLim = [min(measTimeNumUTC) max(measTimeNumUTC)];
    
    nInt = size(data.measTimeVecStart,2);
    [diffMean tmpStd1] = mean_data(diff_azimut,xlimit_all);
    meanDiff = abs(meanDegreeSonic-meanDegreeRotor);
        
   
    sizeLimit = find(tsRealCor.middle >maxSize,1);
    contourSizes = tsRealCor.middle(2:sizeLimit);
    
    %outtake = meanDiff > 360;
    
    s(2) = subplot(2,1,2);
    
    contourData = (tsRealCor.HistogramCorr(:,2:sizeLimit))';
    %contourData = contourData(:,~outtake);      
    num2Vol = (1/6*pi.*repmat(tsRealCor.middle.^3,numel(measTime),1))';
    contourData = contourData.*num2Vol(2:sizeLimit,:);
    conLevelVol = [1 3 10 30 100 300 1000 3000 10000 30000];
    conLevelVol = 10.^[1:.25:4.5];
    
    [C h] = contourf(measTimeNumUTC,contourSizes,log10(contourData), log10(conLevelVol));
    clear plotDataHOL
    plotDataHOL = contourData;
    save('AprilConVolData.mat','plotDataHOL');
    colorbar('YTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5]);
    colormap(jet);
    
    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
    set(gca,'YScale','log','YLim',[6.8 250],'YTick',[7 10 20 40 60 100 200 400],...
        'XLim',plotXLim,'Box','on','Layer','top');
    xlabel('Measurement Time [h]');
    ylabel('Particle Diameter [\mum]');
    title('Volume-Weighted Density d(V)/d(log d) [cm^{-3}*\mum^{-1}*\mum^{3}]')
    
    xlabel('Time (UTC) [h]');
    datetick(gca,'x','hh','keeplimits');
    plotXTick = get(gca,'XTick');
    
    s(1) = subplot(2,1,1);
    hold on
    %number density log
  
    contourData = (tsRealCor.HistogramCorr(:,2:sizeLimit))';
    %contourData = contourData(:,~outtake);
    contourData(contourData==0) = nan;
    conLevelListNumLog = 10.^[-5:.25:2.5];
    
    [C h] = contourf(measTimeNumUTC,contourSizes,log10(contourData), log10(conLevelListNumLog));
    
    clear plotDataHOL
    plotDataHOL = measTime;
    save('AprilConMeasTime.mat','plotDataHOL');
    clear plotDataHOL
    plotDataHOL = contourSizes;
    save('AprilConSizes.mat','plotDataHOL');
    clear plotDataHOL
    plotDataHOL = contourData;
    save('AprilConNumData.mat','plotDataHOL');
    
    colorbar('YTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5]);
    colormap(jet);

    for q=1:length(h)
        set(h(q),'LineStyle','none');
    end
   
    set(gca,'YScale','log','YLim',[6.8 250],'YTick',[7 10 20 40 60 100 200 400],...
        'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'Box','on','Layer','top');
    ylabel('Particle Diameter [\mum]');
    
    title('Number-Weighted Density d(N)/d(log d) [cm^{-3}*\mum^{-1}]')    

    linkaxes([s(1) s(2)],'x');
    annotation(f4,'textbox',[0.92 0.934 0.03 0.05],'String',{'10^{x}'},...
        'LineStyle','none','FontSize',15);
    annotation(f4,'textbox',[0.92 0.459 0.03 0.05],'String',{'10^{x}'},...
        'LineStyle','none','FontSize',15);
  for cnt = 1:2
        aPos = get(s(cnt),'pos');
        aPos(1) = aPos(1)-0.06;
        aPos(2) = aPos(2)-0.05;
        aPos(3) = 0.84;
        aPos(4) = 0.363;
        set(s(cnt),'pos',aPos);
  end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 30 15]);
    set(gcf, 'PaperSize', [30 15]); 
    if savePlots
    print('-dpdf','-r600', 'ContourPlot')
    end
end

% figure(9)
% 
% scatter(diffMean(~outtake),tsRealCor.TWCCount(~outtake),'MarkerEdgeColor','g');
% hold on
% scatter(diffMean(outtake),tsRealCor.TWCCount(outtake),'MarkerEdgeColor','b');
% hold on
% scatter(meanDiff(~outtake),tsRealCor.TWCCount(~outtake),'MarkerEdgeColor','r');
% hold on
% scatter(meanDiff(outtake),tsRealCor.TWCCount(outtake),'MarkerEdgeColor','y');
% hold on
%  a=fit(diffMean',tsRealCor.TWCCount','poly1');
%  plot(a,'g')
%  hold on
%  b=fit(meanDiff',tsRealCor.TWCCount','poly1');
%  plot(b,'r')
%  hold on
% 
%  
%     legend('mean(diff)','diff(mean)');
%     xlabel('Measurement Time [s]');
%     ylim([0 300000]);
    
%% Histogram
if any(choosePlots == 5)
    a=figure(5);
    clf        
    clear s;
    
    plotDataNum= histRealCor./Paik_inert(middle2/1000000, constInletCorr);
    plotErrorNum = histRealCorError./Paik_inert(middle2/1000000, constInletCorr);

 
    
    errorbar(middle2, plotDataNum, plotErrorNum,'LineWidth',2);
    
    title(measurementTime);
    %legend('All','Real','Real Cor','Real All Cor');
    ylabel('number density d(N)/d(log d) [cm^{-3}/\mum]');
    xlabel('diameter [\mum]')
    xlim([2 maxSize]);
    ylim([3e-6 1e3]);
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    grid minor
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
    if savePlots
    print('-dpdf','-r600', 'SizeDistributionNumber.pdf');
    end
end


%% Histogramm Volume Density
if any(choosePlots == 7)
    figure(7)
    clf
    
    clear s;
    plotDataVol= histRealCor./Paik_inert(middle2/1000000, constInletCorr).*(1/6*pi.*middle2.^3);
    plotErrorVol = histRealCorError./Paik_inert(middle2/1000000, constInletCorr).*(1/6*pi.*middle2.^3);
    plotDataOld= histRealCorOld./Paik_inert(middleOld/1000000, constInletCorr).*(1/6*pi.*middleOld.^3);
    plotErrorOld= histRealCorOldError./Paik_inert(middleOld/1000000, constInletCorr).*(1/6*pi.*middleOld.^3);

    clear plotDataHOL
    plotDataHOL(:,1) = middle2;
    plotDataHOL(:,2) = plotDataNum;
    plotDataHOL(:,3) = plotErrorNum;
    plotDataHOL(:,4) = plotDataVol;
    plotDataHOL(:,5) = plotErrorVol;
    plotDataHOL(:,6) = histRealCor;
    plotDataHOL(:,7) = histRealCorError;
    plotDataHOL(:,8) = histRealCor.*(1/6*pi.*middle2.^3);
    plotDataHOL(:,9) = histRealCorError.*(1/6*pi.*middle2.^3);
    save('AprilHistHOL.mat','plotDataHOL');
    
    
    errorbar(middle2, plotDataVol, plotErrorVol,'LineWidth',2);
    hold on
    line([34 34],[1 100000],'LineStyle','--','LineWidth',2,'Color','b');
    %title(measurementTime);
    ylabel('Volume-Weighted Density d(V)/d(log d) [cm^{-3}*\mum^{2}]');
    xlabel('Particle Diameter [\mum]')
    xlim([6.8 maxSize]);
    ylim([1 50000]);
    set(gca,'YScale','log');    
    set(gca,'XTick',[7 10 20 30 40 60 100 200 400],'TickLength',[.025 .025])
    set(gca,'XScale','log');
    set(gca);  
    
    set(gcf, 'Units', 'centimeters');
    set(gcf, 'OuterPosition', [5 5 12 12]);
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
    if savePlots
    print('-dpdf','-r600', 'SizeDistributionVolume.pdf')
    end
end

%% TimeSerie Mean D / Number 
if any(choosePlots == 6)
    figure(6)
    clf
    n = ceil(intervall);
    clear s;    

    set(gcf,'DefaultLineLineWidth',2);
    axnumber = 3;
    for m=1:axnumber
        axleft = 0.09;
        axright = 0.10;
        axtop = 0;
        axbottom = 0.07;
        axgap = 0.01;
        axwidth = 1-axleft-axright;
        axheight = (1-axbottom-axtop)./axnumber-axgap*(axnumber-1);
        axPos(m,:) = [axleft axbottom+(m-1)*(axheight+axgap) axwidth axheight];
    end
    
    meanNum = 5;
    markerSize=60;
    scLineWidht = 1;
    plotXLim = [min(measTimeNumUTC) max(measTimeNumUTC)];
    
%     BTdataAll.timeStartNumUTCall = repmat(BTdataAll.timeStartNumUTC,1,lTraj);
%     tmp=unique(BTdataAll.timeStartNumUTC);
%     for cnt = 1:numel(tmp)
%     BTchoosendata = (BTdataAll.time(:) >= 0 & BTdataAll.lev0All(:) <= 3380 &...
%         BTdataAll.lev0All(:) >= 3280 & BTdataAll.timeStartNumUTCall(:) == tmp(cnt));
%     BTplotData.timeUTC(cnt) = tmp(cnt);
%     BTplotData.IWC(cnt)  = mean(100000*BTdataAll.iwc(BTchoosendata));
%     BTplotData.LWC(cnt)  = mean(5000*BTdataAll.lwc(BTchoosendata));
%     BTplotData.temp(cnt)  = mean(BTdataAll.temp(BTchoosendata));
%     BTplotData.pottemp(cnt)  = mean(BTdataAll.pottemp(BTchoosendata));
%     BTplotData.humid(cnt)  = mean(BTdataAll.humid(BTchoosendata));
%     BTplotData.relhumid(cnt)  = mean(BTdataAll.relhumid(BTchoosendata));
%     BTplotData.mixratio(cnt)  = mean(BTdataAll.mixratio(BTchoosendata));
%     BTplotData.windspeed(cnt)  = mean(BTdataAll.windspeed(BTchoosendata));
%     BTplotData.winddirection(cnt)  = mean(BTdataAll.winddirection(BTchoosendata))+180;
%     BTplotData.IWCstd(cnt)  = std(200000*BTdataAll.iwc(BTchoosendata));
%     BTplotData.LWCstd(cnt)  = std(5000*BTdataAll.lwc(BTchoosendata));
%     BTplotData.tempstd(cnt)  = std(BTdataAll.temp(BTchoosendata));
%     BTplotData.pottempstd(cnt)  = std(BTdataAll.pottemp(BTchoosendata));
%     BTplotData.humidstd(cnt)  = std(BTdataAll.humid(BTchoosendata));
%     BTplotData.relhumidstd(cnt)  = std(BTdataAll.relhumid(BTchoosendata));
%     BTplotData.mixratiostd(cnt)  = std(BTdataAll.mixratio(BTchoosendata));
%     BTplotData.windspeedstd(cnt)  = std(BTdataAll.windspeed(BTchoosendata));
%     BTplotData.winddirectionstd(cnt)  = std(BTdataAll.winddirection(BTchoosendata));
%     end
    
    
    s(3)=axes('position',axPos(1,:));
    [ax,h1,h2]= plotyy(measTimeNumUTC, nanmoving_average(tsRealCor.LWC,meanNum),...
        measTimeNumUTC, nanmoving_average(tsRealCor.IWC,meanNum));
    hold(ax(1),'on')
    hold(ax(2),'on')
    scatter(ax(1),measTimeNumUTC, tsRealCor.LWC, ...        
        markerSize,'bx','lineWidth',scLineWidht);
    %plot(ax(1), BTplotData.timeUTC, BTplotData.LWC,'b--');
    %plot(ax(2), BTplotData.timeUTC, BTplotData.IWC,'--','Color',[0 0.5 0]);
    scatter(ax(2),measTimeNumUTC, tsRealCor.IWC, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    set(get(ax(1),'Ylabel'),'String',{'Water Content', 'd < 34 \mum [g*m^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Water Content', 'd > 34 \mum [g*m^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(ax(1),'XLim',plotXLim,'YLim',[0 0.5],'YTick',[0 0.1 0.2 0.3 0.4 0.6 0.8]);
    set(ax(2),'XLim',plotXLim,'XTickLabel',[],'YLim',[0 0.5],'YTick',[0 0.1 0.2 0.3 0.4 0.6 0.8]);
    
    xlabel('Time (UTC) [h]');
    datetick(ax(1),'x','hh','keeplimits');
    datetick(ax(2),'x','hh','keeplimits');
    plotXTick = get(ax(1),'XTick');
    
    s(2)=axes('position',axPos(2,:));
    [ax,h1,h2]= plotyy(measTimeNumUTC, nanmoving_average(tsRealCor.LWCon,meanNum),...
        measTimeNumUTC, nanmoving_average(tsRealCor.IWCon*1000,meanNum));
    hold(ax(1),'on')
    hold(ax(2),'on')
    scatter(ax(1),measTimeNumUTC, tsRealCor.LWCon,markerSize,'bx','lineWidth',scLineWidht);
    scatter(ax(2),measTimeNumUTC, tsRealCor.IWCon*1000,markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    set(get(ax(1),'Ylabel'),'String',{'Number Concentration', 'd < 34 \mum [cm^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Number Concentration', 'd > 34 \mum [l^{-1}]'},'fontsize',18,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],...
        'YLim',[0 450],'YTick',[0 100 200 300 400 500]);
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],...
        'YLim',[0 450],'YTick',[0 100 200 300 400 500]);
    
    s(1)=axes('position',axPos(3,:)); 
    [ax,h1,h2]= plotyy(measTimeNumUTC, nanmoving_average(rem(data.measMeanAzimutSonic+180,360), meanNum),...
        measTimeNumUTC, nanmoving_average(data.measMeanT, meanNum));
    hold(ax(1),'on')
    hold(ax(2),'on')
    scatter(ax(1),measTimeNumUTC, rem(data.measMeanAzimutSonic+180,360),markerSize,'bx','lineWidth',scLineWidht);
    scatter(ax(2),measTimeNumUTC, data.measMeanT, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    %plot(ax(1), BTplotData.timeUTC, BTplotData.winddirection,'b--');
    %plot(ax(2), BTplotData.timeUTC, BTplotData.temp,'--','Color',[0 0.5 0]);
    set(get(ax(1),'Ylabel'),'String',{'Wind Direction', 'Azimut [°]'},'fontsize',18,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Air Temperature', '[°C]'},'fontsize',18,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
      
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],...
        'YLim',[0 360],'YTick',[0 90 180 270 360]);
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],...
        'YLim',[-10 -6],'YTick',[-10 -9 -8 -7 -6]);

    set(ax(1),'XTickLabel',[]);
    set(ax(2),'XTickLabel',[]);

    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 30 20]);
    set(gcf, 'PaperSize', [30 20]); 
    if savePlots
    print('-dpdf','-r600', 'TimeSerie')
    end
end

%  %% wind direction
% if any(choosePlots == 9)
%     figure(9)
%     clf
%     plot(data.measMeanAzimutSonic+180)
%     
%     %data.measMeanAzimutSonic(data.measMeanAzimutSonic>=180) = data.measMeanAzimutSonic(data.measMeanAzimutSonic>=180)-180
%     %rose(WD_azimut(xlimit_all(1,1):xlimit_all(end,end)))
%     figure(10)
%     hist(V_total(xlimit_all(1,1):xlimit_all(end,end)))
%     figure(11)
%     scatter(WD_azimut(xlimit_all(1,1):xlimit_all(end,end)),V_total(xlimit_all(1,1):xlimit_all(end,end)))
% end