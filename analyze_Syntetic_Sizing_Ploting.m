nrNewpDiam = 5;
cntfig = 1;
basepath = 'Z:\1_Raw_Images\2014_Synthisch';

%Volumen per Hologram Syntetisch
syndeltaz = 49*0.001;
syndeltay = 2.72*1236*1e-6;
syndeltax = 2.72*1648*1e-6;
synV = syndeltax * syndeltay * syndeltaz;
  
%Volumen Algortihm
alV = 2.7828e-7;

anDataAll.synSizes = [4 6 8 12 18 200 25 40 80];
anDataAll.expectedCount = [1 1 1 1 .64 .2 1 1 .5]*alV/synV;
anDataAll.colormap = lbmap(9,'RedBlue');


%PSD Spectrum
figure(cntfig)
cntfig = cntfig+1;
clf
hold on
for cnt = 1:9
maxValue(cnt) = max(max(anDataAll.histRealCount(:,cnt)./anDataAll.expectedCount(cnt)));
end
maxValue = max(maxValue);
for cnt = 1:9
plot(anParameter.histBinMiddle,anDataAll.histRealCount(:,cnt)./anDataAll.expectedCount(cnt), 'Color',anDataAll.colormap(cnt,:))
line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
    'Color',anDataAll.colormap(cnt,:))
end

xlim([3 250])
ylim([0 maxValue])
set(gca,'XScale','log');


% %PSD Spectrum Comparision
% 
% figure(cntfig)
% cntfig = cntfig+1;
% clf
% hold on
% 
% data = anDataAll.NimEquivDiaOldSizesHist;
% for cnt = 1:9
% maxValue(cnt) = max(max(data(:,cnt)./anDataAll.expectedCount(cnt)));
% end
% maxValue = max(maxValue);
% set(gca,'XScale','log');
% for cnt = [2:5 7:8]
% stairs(anDataAll.NHistBinBorder(1:end-1),data(:,cnt)./anDataAll.expectedCount(cnt), ...
%     '--','Color',anDataAll.colormap(cnt,:), 'LineWidth',1)
% stairs(anParameter.histBinBorder(1:end-1),anDataAll.histReal(:,cnt)./anDataAll.expectedCount(cnt),...
%     '-', 'Color',anDataAll.colormap(cnt,:), 'LineWidth',1)
% line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
%     'Color',anDataAll.colormap(cnt,:), 'LineWidth',1,'LineStyle','-.')
% end
% 
% xlim([3 100])
% %ylim([0 maxValue])
% set(gca,'XScale','log');
% box on
% legend({'Fine Bin Size','Standard Bin Size','Synthetic Particle Size'})
% xlabel('Particle Diameter [\mum]')
% ylabel('Concentration [a.u.]')
% 
% set(gcf, 'PaperUnits','centimeters');
% set(gcf, 'PaperPosition',[0 0 15 10]);
% set(gcf, 'PaperSize', [15 10]);
% fileName = ['PSD_Syn_AllSizes4'];
% print(gcf,'-dpdf','-r600', fullfile(basepath,fileName));  

% %Test Histogram Binning
% figure(cntfig)
% cntfig = cntfig+1;
% clf
% hold on
% 
% plot(1:24, anParameter.histBinMiddle,'Color',anDataAll.colormap(1,:))
% plot(0:24, anParameter.histBinBorder,'--' ,'Color',anDataAll.colormap(2,:))
% plot(1:25, anParameter.histBinBorder,'--' ,'Color',anDataAll.colormap(3,:))
% plot(1:24, anParameter.histBinMiddleOldSizes,'.-','Color',anDataAll.colormap(4,:))
% 
% plot(1:59, anDataAll.NHistBin,'Color',anDataAll.colormap(7,:))
% plot(0:59, anDataAll.NHistBinBorder,'--' ,'Color',anDataAll.colormap(8,:))
% plot(1:60, anDataAll.NHistBinBorder,'--' ,'Color',anDataAll.colormap(9,:))
% 
% set(gca,'XScale','log');
% set(gca,'YScale','log');
% %PSD Spectrum
% figure(cntfig)
% cntfig = cntfig+1;
% clf
% hold on
% for cnt = 1:9
% maxValue(cnt) = max(max(anDataAll.histRealCount(:,cnt)./anDataAll.expectedCount(cnt)));
% end
% maxValue = max(maxValue);
% for cnt = 1:9
% plot(anParameter.histBinMiddle,anDataAll.newPDiam(nrNewpDiam).histRealCount(:,cnt)./anDataAll.expectedCount(cnt), 'Color',anDataAll.colormap(cnt,:))
% line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
%     'Color',anDataAll.colormap(cnt,:))
% end
% 
% xlim([3 250])
% ylim([0 maxValue])
% set(gca,'XScale','log');
% 
% %Concentraction
% figure(cntfig)
% cntfig = cntfig+1;
% clf
% hold on
% 
% for cnt = 1:numel(anDataAll.newPDiam)
%     scatter(anDataAll.synSizes ,sum(anDataAll.newPDiam(nrNewpDiam).histRealCount,1)./anDataAll.expectedCount)
% end


xlim([3 250])
%ylim([0 max(anDataAll.totalCount)])
set(gca,'XScale','log');

%PSD Spectrum All
figure(cntfig)
cntfig = cntfig+1;
clf


subplot(2,2,1)
hold on
data = anDataAll.NpDiamOldSizesHist;
for cnt = 1:9
maxValue(cnt) = max(max(data(:,cnt)./anDataAll.expectedCount(cnt)));
end
maxValue = max(maxValue);
for cnt = 1:9
plot(anDataAll.NHistBin,data(:,cnt)./anDataAll.expectedCount(cnt), 'Color',anDataAll.colormap(cnt,:))
line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
    'Color',anDataAll.colormap(cnt,:))
end
scatter(anDataAll.synSizes, anDataAll.NpDiamOldSizesCount./anDataAll.expectedCount/10000/10);
xlim([2 100])
title('pDiam - loose Tresh/no Size correction')

set(gca,'XScale','log');

subplot(2,2,2)
hold on
data = anDataAll.NpDiamHist;
for cnt = 1:9
maxValue(cnt) = max(max(data(:,cnt)./anDataAll.expectedCount(cnt)));
end
maxValue = max(maxValue);
for cnt = 1:9
plot(anDataAll.NHistBin,data(:,cnt)./anDataAll.expectedCount(cnt), 'Color',anDataAll.colormap(cnt,:))
line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
    'Color',anDataAll.colormap(cnt,:))
end
xlim([2 100])
title('pDiam - loose Tresh/Size correction')
set(gca,'XScale','log');

subplot(2,2,3)
hold on
data = anDataAll.NpDiamOldSizesOldThreshHist;
for cnt = 1:9
maxValue(cnt) = max(max(data(:,cnt)./anDataAll.expectedCount(cnt)));
end
maxValue = max(maxValue);
for cnt = 1:9
plot(anDataAll.NHistBin,data(:,cnt)./anDataAll.expectedCount(cnt), 'Color',anDataAll.colormap(cnt,:))
line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
    'Color',anDataAll.colormap(cnt,:))
end
scatter(anDataAll.synSizes, anDataAll.NpDiamOldSizesOldThreshCount./anDataAll.expectedCount/10000/20);
xlim([2 100])
title('pDiam - strict Tresh/no Size correction')
set(gca,'XScale','log');

% subplot(2,2,4)
% hold on
% data = anDataAll.NpDiamOldThreshHist;
% for cnt = 1:9
% maxValue(cnt) = max(max(data(:,cnt)./anDataAll.expectedCount(cnt)));
% end
% maxValue = max(maxValue);
% for cnt = 1:9
% plot(anDataAll.NHistBin,data(:,cnt)./anDataAll.expectedCount(cnt), 'Color',anDataAll.colormap(cnt,:))
% line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
%     'Color',anDataAll.colormap(cnt,:))
% end
% xlim([2 100])
% title('pDiam - strict Tresh/Size correction')
% set(gca,'XScale','log');

subplot(2,2,4)
hold on
data = anDataAll.NimEquivDiaOldSizesHist;
for cnt = 1:9
maxValue(cnt) = max(max(data(:,cnt)./anDataAll.expectedCount(cnt)));
end
maxValue = max(maxValue);
for cnt = 1:9
plot(anDataAll.NHistBin,data(:,cnt)./anDataAll.expectedCount(cnt), 'Color',anDataAll.colormap(cnt,:))
line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
    'Color',anDataAll.colormap(cnt,:))
end
xlim([2 250])
title('imEquivDia')
set(gca,'XScale','log');
% 
% subplot(3,3,6)
% hold on
% data = anDataAll.NimEquivDiaHist;
% for cnt = 1:9
% maxValue(cnt) = max(max(data(:,cnt)./anDataAll.expectedCount(cnt)));
% end
% maxValue = max(maxValue);
% for cnt = 1:9
% plot(anDataAll.NHistBin,data(:,cnt)./anDataAll.expectedCount(cnt), 'Color',anDataAll.colormap(cnt,:))
% line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
%     'Color',anDataAll.colormap(cnt,:))
% end
% xlim([2 100])
% 
% set(gca,'XScale','log');
% 
% subplot(3,3,7)
% hold on
% data = anDataAll.NpDiamMeanHist;
% for cnt = 1:9
% maxValue(cnt) = max(max(data(:,cnt)./anDataAll.expectedCount(cnt)));
% end
% maxValue = max(maxValue);
% for cnt = 1:9
% plot(anDataAll.NHistBin,data(:,cnt)./anDataAll.expectedCount(cnt), 'Color',anDataAll.colormap(cnt,:))
% line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
%     'Color',anDataAll.colormap(cnt,:))
% end
% xlim([2 100])
% 
% set(gca,'XScale','log');
% 
% subplot(3,3,8)
% hold on
% data = anDataAll.NimDiamMeanHist;
% for cnt = 1:9
% maxValue(cnt) = max(max(data(:,cnt)./anDataAll.expectedCount(cnt)));
% end
% maxValue = max(maxValue);
% for cnt = 1:9
% plot(anDataAll.NHistBin,data(:,cnt)./anDataAll.expectedCount(cnt), 'Color',anDataAll.colormap(cnt,:))
% line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
%     'Color',anDataAll.colormap(cnt,:))
% end
% xlim([2 100])
% 
% set(gca,'XScale','log');
% 
% subplot(3,3,9)
% hold on
% data = anDataAll.NimDiamMeanHistOldSizes;
% for cnt = 1:9
% maxValue(cnt) = max(max(data(:,cnt)./anDataAll.expectedCount(cnt)));
% end
% maxValue = max(maxValue);
% for cnt = 1:9
% plot(anDataAll.NHistBin,data(:,cnt)./anDataAll.expectedCount(cnt), 'Color',anDataAll.colormap(cnt,:))
% line([anDataAll.synSizes(cnt) anDataAll.synSizes(cnt)],[0 maxValue], ...
%     'Color',anDataAll.colormap(cnt,:))
% 
% end
% xlim([2 100])
% 
% set(gca,'XScale','log');


figure(cntfig)
cntfig = cntfig+1;
clf
for cnt = 1:9
isFin = isfinite(anDataAll.NimEquivDiaOldSizes{cnt});
isSmall = anDataAll.NimEquivDiaOldSizes{cnt}<5e-6;
isReal = anDataAll.partIsReal{cnt};

nrNotFin(cnt) = sum(~isFin);
nrRealSmall(cnt) = sum(isFin & isSmall & isReal);
nrReal(cnt)  = sum(isFin & isReal);
end

scatter(anDataAll.synSizes, nrRealSmall)
hold on

scatter(anDataAll.synSizes, nrReal,'x')

scatter(anDataAll.synSizes, anDataAll.expectedCount*10000,'.')

xlim([2 250])
legend('Small and Real','Real','Expected')
set(gca,'XScale','log');