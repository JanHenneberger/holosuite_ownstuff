function h = plotGroupBoxplots15(anData, B, chosenData)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
set(gcf,'DefaultAxesFontSize',12);
set(gcf,'DefaultAxesLineWidth',1);


%%First line
subplot(3,5,1)
plotInd = anData.TWConcentraction>=0 & ~isinf(anData.TWConcentraction) & chosenData &...
    ~isnan(anData.TWContent) & ~isnan(anData.IWContent);
anData.TWConcentraction(anData.TWConcentraction==0)=1e-7;
h=boxplot(anData.TWConcentraction(plotInd), B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.TWConcentraction(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');

set(h(7,:),'Visible','off')
set(gca,'YScale','log')
set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
set(gca,'YLim',[1/mean(anData.sample.VolumeReal)/1000000 5e2])
ylabel('Total conc. [cm^{-3}]')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

subplot(3,5,2)
plotInd = anData.LWConcentraction>=0 & ~isinf(anData.LWConcentraction)& chosenData;
anData.LWConcentraction(anData.LWConcentraction==0)=1e-7;
h=boxplot(anData.LWConcentraction(plotInd), B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.LWConcentraction(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');

set(h(7,:),'Visible','off')
set(gca,'YScale','log')
set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
set(gca,'YLim',[1/mean(anData.sample.VolumeReal)/1000000 5e2])
ylabel('Liquid conc. [cm^{-3}]')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

subplot(3,5,3)
plotInd = anData.IWConcentraction>=0 & ~isinf(anData.IWConcentraction)& chosenData;
anData.IWConcentraction(anData.IWConcentraction==0)=1e-7;
h=boxplot(anData.IWConcentraction(plotInd), B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.IWConcentraction(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
set(gca,'YScale','log')
set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
set(gca,'YLim',[1/mean(anData.sample.VolumeReal)/1000000 3])
ylabel('Ice conc. [cm^{-3}]')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

subplot(3,5,4)
plotInd = anData.IWConcentraction./anData.TWConcentraction>=0 & ~isinf(anData.IWConcentraction./anData.TWConcentraction)& chosenData;
plotData = anData.IWConcentraction./anData.TWConcentraction;
plotData(plotData==0)=1e-7;

h=boxplot(plotData(plotInd), B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(plotData(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');

set(h(7,:),'Visible','off')
set(gca,'YScale','log')
set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
set(gca,'YLim',[1e-4 1])
ylabel('Ice/Total conc.')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

subplot(3,5,5)
plotInd = anData.uz>=0 & ~isinf(anData.uz)& chosenData;
h=boxplot(anData.uz(plotInd), B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.uz(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
set(gca,'YScale','log')
set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
set(gca,'YLim',[1e-3 1e1])
ylabel('Req. vert. vel. [m s^{-1}]')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

%%Second line
subplot(3,5,6)
plotInd = anData.TWContent>=0 & ~isinf(anData.TWContent)& chosenData;
anData.TWContent(anData.TWContent==0)=1e-7;
h=boxplot(anData.TWContent(plotInd) , B(plotInd),'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.TWContent(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
set(gca,'YScale','log')
%set(gca,'YLim',[1/mean(anData.sample.VolumeReal)*6/pi*nanmean(anData.TWMeanD)^3*1e6 1e0])
set(gca,'YLim',[1e-4 1e0])
set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
ylabel('TWC [g m^{-3}]')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

subplot(3,5,7)
plotInd = anData.LWContent>=0 & ~isinf(anData.LWContent)& chosenData;
anData.LWContent(anData.LWContent==0)=1e-7;
h=boxplot(anData.LWContent(plotInd) , B(plotInd),'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.LWContent(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
set(gca,'YScale','log')
%set(gca,'YLim',[1/mean(anData.sample.VolumeReal)*6/pi*nanmean(anData.TWMeanD)^3*1e6 1e0])
set(gca,'YLim',[1e-4 1e0])
set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
ylabel('LWC [g m^{-3}]')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

subplot(3,5,8)
plotInd = anData.IWContent>=0 & ~isinf(anData.IWContent)& chosenData;
anData.IWContent(anData.IWContent==0)=1e-7;
h=boxplot(anData.IWContent(plotInd) , B(plotInd),'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.IWContent(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
set(gca,'YScale','log')
%set(gca,'YLim',[1/mean(anData.sample.VolumeReal)*6/pi*nanmean(anData.TWMeanD)^3*1e6 1e0])
set(gca,'YLim',[1e-4 1e0])
set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
ylabel('IWC [g m^{-3}]')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

subplot(3,5,9)
plotInd = anData.IWContent./anData.TWContent>=0 & ~isinf(anData.IWContent./anData.TWContent)& chosenData;
h=boxplot(anData.IWContent(plotInd)./anData.TWContent(plotInd), B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.IWContent(plotInd)./anData.TWContent(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
%set(gca,'YLim',[1e-3 1e0])
ylabel('IWC/TWC')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');
ylim([-.05 1.05])

subplot(3,5,10)
plotInd = anData.glaciationTime>=0 & ~isinf(anData.glaciationTime)& chosenData;
h=boxplot(anData.glaciationTime(plotInd), B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.glaciationTime(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
set(gca,'YScale','log')
set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
set(gca,'YLim',[1e-1 1e4])
ylabel('Glaciation time [s]')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

%%third line
subplot(3,5,11)
plotInd = anData.TWMeanD*1e6>0 & ~isinf(anData.TWMeanD)& chosenData;
anData.TWMeanD(anData.TWMeanD(plotInd)==0)=1e-9;

h=boxplot(anData.TWMeanD(plotInd)*1e6, B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.TWMeanD(plotInd)*1e6, B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
set(gca,'YScale','log')
set(gca,'YTick',[10 20 50 100 200])
ylabel('Mean diameter total [\mum]')
ylim([6 105])
set(gca,'TickLength',[0.03 0.06],'TickDir','out');


subplot(3,5,12)
plotInd = anData.LWMeanD*1e6>0 & ~isinf(anData.LWMeanD)& chosenData;
anData.LWMeanD(anData.LWMeanD(plotInd)==0)=1e-9;

h=boxplot(anData.LWMeanD(plotInd)*1e6, B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.LWMeanD(plotInd)*1e6, B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
set(gca,'YScale','log')
set(gca,'YTick',[10 20 50 100 200])
ylabel('Mean diameter liquid [\mum]')
ylim([6 55])
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

subplot(3,5,13)
plotInd = anData.IWMeanD*1e6>0 & ~isinf(anData.IWMeanD)& chosenData;
anData.IWMeanD(anData.IWMeanD(plotInd)==0)=1e-9;
h=boxplot(anData.IWMeanD(plotInd)*1e6, B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.IWMeanD(plotInd)*1e6, B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
set(gca,'YScale','log')
set(gca,'YTick',[10 20 50 100 200])
ylabel('Mean diameter ice [\mum]')
ylim([6 205])
set(gca,'TickLength',[0.03 0.06],'TickDir','out');


subplot(3,5,14)
plotInd =  ~isinf(anData.measMeanT)& chosenData;
h=boxplot(anData.measMeanT(plotInd), B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.measMeanT(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
set(gca,'YTick',[-25 -20 -15 -10 -5 0])
set(gca,'YLim',[-25 0]);
ylabel('Temperature [°C]')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

subplot(3,5,15)
plotInd = anData.meteoWindVel>=0 & ~isinf(anData.meteoWindVel)& chosenData;
h=boxplot(anData.meteoWindVel(plotInd), B(plotInd) ,'symbol','r+','outliersize',4,'labelorientation','inline');
hold on
meanValues = grpstats(anData.meteoWindVel(plotInd), B(plotInd),'nanmean');
scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
set(h(7,:),'Visible','off')
%set(gca,'YScale','log')
set(gca,'YTick',[0 5 10 15 20 25])
set(gca,'YLim',[0 20])
ylabel('Wind speed [m s^{-1}]')
set(gca,'TickLength',[0.03 0.06],'TickDir','out');

%     subplot(3,4,11)
%     hist(B);
%     ylabel('Frequency')
end

