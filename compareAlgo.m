%run first: analyzeCLACE2013_Overview.m
%then run for every day: 
%clear anData
%analyzeCLACE2013_OveRecComp.m
%analyzeCLACE2013_OverviewComp.m

figure(20)
set(gcf,'Units','normalized','position',[0 0 1 1]);

subplot(2,4,1,'replace')     
% plot(anParameter.histBinMiddle, mean(anDataAll.water.histRealCor(:,:),2), ...
%     'LineWidth',2);
% hold on
% plot(anParameter.histBinMiddle, mean(anDataAll.ice.histRealCor(:,:),2), ...
%     'LineWidth',2,'LineStyle',':');
% plot(anParameterRec.histBinMiddle, mean(anDataRec.histRealCor(:,:),2), ...
%      'LineWidth',2,'LineStyle','--');
plot(anParameterRec.histBinMiddle(1:14), mean(anDataRec.histRealCor(1:14,:),2),...    
     'LineWidth',2,'LineStyle','-','Color','b');
hold on
plot(anParameter.histBinMiddle, mean(anDataAll.water.histRealCor(:,:),2), ...
    'LineWidth',2,'Color','r');
 plot(anParameterRec.histBinMiddle(14:end), mean(anDataRec.histRealCor(14:end,:),2), ...
     'LineWidth',2,'LineStyle','--','Color','b');
plot(anParameter.histBinMiddle, mean(anDataAll.ice.histRealCor(:,:),2), ...
    'LineWidth',2,'LineStyle','--','Color','r');

h_legend = legend({'HS2012 water' ,'HS2013 water','HS2012 ice','HS2013 ice'}, 'Location', 'NorthEast');
set(h_legend,'FontSize',9);
ylabel('number density d(N)/d(log d) [cm^{-3}\mum^{-1}]');
xlabel('diameter [\mum]')
set(gca,'YScale','log');
set(gca,'XScale','log');
xlim(gca, [6 anParameter.maxSize]);
ylim(gca, [5e-4 1e2]);

subplot(2,4,5,'replace')  
plot(anParameterRec.histBinMiddle(1:14), mean(anDataRec.histRealCor(1:14,:)'.*...
    repmat((1/6*pi.*anParameterRec.histBinMiddle(1:14).^3),size(anDataRec.histRealCor(1:14,:),2),1)), ...
     'LineWidth',2,'LineStyle','-','Color','b');
hold on
plot(anParameter.histBinMiddle, mean(anDataAll.water.histRealCor(:,:)'.*...
    repmat((1/6*pi.*anParameter.histBinMiddle.^3),size(anDataAll.water.histRealCor(:,:),2),1)), ...
    'LineWidth',2,'Color','r');
 plot(anParameterRec.histBinMiddle(14:end), mean(anDataRec.histRealCor(14:end,:)'.*...
    repmat((1/6*pi.*anParameterRec.histBinMiddle(14:end).^3),size(anDataRec.histRealCor(14:end,:),2),1)), ...
     'LineWidth',2,'LineStyle','--','Color','b');
plot(anParameter.histBinMiddle, mean(anDataAll.ice.histRealCor(:,:)'.*...
    repmat((1/6*pi.*anParameter.histBinMiddle.^3),size(anDataAll.water.histRealCor(:,:),2),1)), ...
    'LineWidth',2,'LineStyle','--','Color','r');

 
h_legend = legend({'HS2012 water' ,'HS2013 water','HS2012 ice','HS2013 ice'}, 'Location', 'NorthEast');
set(h_legend,'FontSize',9);
ylabel('volume density d(N)/d(log d) [cm^{-3}\mum^{-1}\mum^{3}]');
xlabel('diameter [\mum]')
set(gca,'YScale','log');
set(gca,'XScale','log');
xlim(gca, [6 anParameter.maxSize]);
ylim(gca,[8e-1 1e5]);

    
subplot(2,4,2,'replace')
hold on
aPos= get(gca,'Position');
x=anDataRec.TWConcentraction;
y=anDataAll.TWConcentraction;
plotLimit = 1.05*max(max(x),max(y));
scatter(x, y);
p=polyfit(x,y,1);
xfit = linspace(0,plotLimit);
plot(xfit,p(1).*xfit+p(2));
plot(xfit,xfit,'k-');
R=corrcoef(x,y);

str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
str1(1) = {['R^2 -value: ' num2str(R(1,2),'%4.2g')]};
h=legend(str1,'Location','NorthWest');
set(h,'FontSize',12);
xlim([0, plotLimit]);
ylim([0, plotLimit]);
xlabel('HS2012');
ylabel('HS2013');
title('Total conc. [cm^{-3}]')
box on

subplot(2,4,3,'replace')
hold on
x=anDataRec.LWConcentraction;
y=anDataAll.LWConcentraction;
plotLimit = 1.05*max(max(x),max(y));
scatter(x, y);
p=polyfit(x,y,1);
xfit = linspace(0,plotLimit);
plot(xfit,p(1).*xfit+p(2));
plot(xfit,xfit,'k-');
R=corrcoef(x,y);
str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
str1(1) = {['R^2-value: ' num2str(R(1,2),'%4.2g')]};
h=legend(str1,'Location','NorthWest');
set(h,'FontSize',12);
xlim([0, plotLimit]);
ylim([0, plotLimit]);
xlabel('HS2012');
ylabel('HS2013');
title('Cloud droplet conc. [cm^{-3}]')
box on


subplot(2,4,4,'replace')
hold on
aPos= get(gca,'Position');
x=anDataRec.IWConcentraction;
y=anDataAll.IWConcentraction;
plotLimit = 1.05*max(max(x),max(y));
scatter(x, y);
p=polyfit(x,y,1);
xfit = linspace(0,plotLimit);
plot(xfit,p(1).*xfit+p(2));
plot(xfit,xfit,'k-');
R=corrcoef(x,y);
str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
str1(1) = {['R^2-value: ' num2str(R(1,2),'%4.2g')]};
h=legend(str1,'Location','NorthWest');
set(h,'FontSize',12);
xlim([0, plotLimit]);
ylim([0, plotLimit]);
xlabel('HS2012');
ylabel('HS2013');
title('Ice crystal conc. [cm^{-3}]')
box on


subplot(2,4,6,'replace')
hold on
x=anDataRec.TWContent;
y=anDataAll.TWContent;
plotLimit = 1.05*max(max(x),max(y));
scatter(x, y);
p=polyfit(x,y,1);
xfit = linspace(0,plotLimit);
plot(xfit,p(1).*xfit+p(2));
plot(xfit,xfit,'k-');
R=corrcoef(x,y);
str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
str1(1) = {['R^2-value: ' num2str(R(1,2),'%4.2g')]};
h=legend(str1,'Location','NorthWest');
set(h,'FontSize',12);
xlim([0, plotLimit]);
ylim([0, plotLimit]);
xlabel('HS2012');
ylabel('HS2013');
title('TWC [g m^{-3}]')
box on

subplot(2,4,7,'replace')
hold on
x=anDataRec.LWContent;
y=anDataAll.LWContent;
plotLimit = 1.05*max(max(x),max(y));
scatter(x, y);
p=polyfit(x,y,1);
xfit = linspace(0,plotLimit);
plot(xfit,p(1).*xfit+p(2));
plot(xfit,xfit,'k-');
R=corrcoef(x,y);
str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
str1(1) = {['R^2-value: ' num2str(R(1,2),'%4.2g')]};
h=legend(str1,'Location','NorthWest');
set(h,'FontSize',12);
xlim([0, plotLimit]);
ylim([0, plotLimit]);
xlabel('HS2012');
ylabel('HS2013');
title('LWC [g m^{-3}]')
box on

subplot(2,4,8,'replace')
hold on
x=anDataRec.IWContent;
y=anDataAll.IWContent;
plotLimit = 1.05*max(max(x),max(y));
scatter(x, y);
p=polyfit(x,y,1);
xfit = linspace(0,plotLimit);
plot(xfit,p(1).*xfit+p(2));
plot(xfit,xfit,'k-');
R=corrcoef(x,y);
str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
str1(1) = {['R^2-value: ' num2str(R(1,2),'%4.2g')]};
h=legend(str1,'Location','NorthWest');
set(h,'FontSize',12);
xlim([0, plotLimit]);
ylim([0, plotLimit]);
xlabel('HS2012');
ylabel('HS2013');
title('IWC [g m^{-3}]')
box on

['mean total conc. [cm^{-3}] ' ...
    'HS2012: ' num2str(mean(anDataRec.TWConcentraction),'%4.2g')...
    ' HS2013: ' num2str(mean(anDataAll.TWConcentraction),'%4.2g')]
['mean water conc. [cm^{-3}] ' ...
    'HS2012: ' num2str(mean(anDataRec.LWConcentraction),'%4.2g')...
    ' HS2013: ' num2str(mean(anDataAll.LWConcentraction),'%4.2g')]
['mean ice conc. [cm^{-3}] ' ...
    'HS2012: ' num2str(mean(anDataRec.IWConcentraction),'%4.2g')...
    ' HS2013: ' num2str(mean(anDataAll.IWConcentraction),'%4.2g')]

['mean total content [g m^{-3}] ' ...
    'HS2012: ' num2str(mean(anDataRec.TWContent),'%4.2g')...
    ' HS2013: ' num2str(mean(anDataAll.TWContent),'%4.2g')]
['mean water content [g m^{-3}] ' ...
    'HS2012: ' num2str(mean(anDataRec.LWContent),'%4.2g')...
    ' HS2013: ' num2str(mean(anDataAll.LWContent),'%4.2g')]
['mean ice content [g m^{-3}] ' ...
    'HS2012: ' num2str(mean(anDataRec.IWContent),'%4.2g')...
    ' HS2013: ' num2str(mean(anDataAll.IWContent),'%4.2g')]