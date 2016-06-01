function plot_CloudPhaseFrequency(anData,cntFig)

figure(cntFig)
gcf
plotColor = lbmap(4,'RedBlue');
plotColor = colormap(lines(7))
korTemp = -32.5:5:-2.5;
buhlTemp = -27.5:5:-2.5;
JFJTemp = -22.5 : 5 :-2.5;

freqTemp = summary(anData.oTemperature2(anData.chosenData));
freqTempNorth = summary(anData.oTemperature2(anData.chosenData & ...
    anData.oWindDirection == 'North wind'));
freqTempSouth = summary(anData.oTemperature2(anData.chosenData & ...
    anData.oWindDirection == 'South wind'));
   
   
subplot(3,1,1)
hold on
chosenData = anData.chosenData & anData.oCloudPhase == 'Liquid';
% freqHOLIMO = summary(anData.oTemperature2(chosenData))./freqTemp*100;
% plot(JFJTemp,freqHOLIMO,'Color',[0 0 0])
chosenDataDir = chosenData &  anData.oWindDirection == 'South wind';
freqHOLIMO = summary(anData.oTemperature2(chosenDataDir))./freqTempSouth*100;
pc= anData.plotColorWindDir(1,:);
plot(JFJTemp,freqHOLIMO,'-d','MarkerFaceColor',pc,...
    'Color', pc)
chosenDataDir = chosenData &  anData.oWindDirection == 'North wind';
freqHOLIMO = summary(anData.oTemperature2(chosenDataDir))./freqTempNorth*100;
pc= anData.plotColorWindDir(2,:);
plot(JFJTemp,freqHOLIMO,'-d','MarkerFaceColor',pc,...
    'Color', pc)
pc= plotColor(5,:);
plot(korTemp,[3.8 4.6 8 16 30 50 75],':p','MarkerFaceColor',pc,...
    'Color', pc)
pc= plotColor(3,:);
plot(korTemp,anData.korData(1,:),'--s','MarkerFaceColor',pc,...
    'Color', pc)
pc = plotColor(4,:);
plot(buhlTemp, [0 0 0.05 0.1 0.6 0.8]*100,'-.o','MarkerFaceColor',pc,...
    'Color',pc);
legend({'JFJ - SE wind cases'; 'JFJ - NW wind cases'; ...
    'Borovikov (1963)'; 'Korolev et al. (2003)'; 'Buehl et al. (2013)'},'Location','northwest')
ylabel({' ';'Liquid clouds'})
set(gca, 'Ytick',[0 25 50 75 100]);
box on

subplot(3,1,2)
hold on
chosenData = anData.chosenData & anData.oCloudPhase == 'Mixed';
% freqHOLIMO = summary(anData.oTemperature2(chosenData))./freqTemp*100;
% plot(JFJTemp,freqHOLIMO,'Color',[0 0 0])
chosenDataDir = chosenData &  anData.oWindDirection == 'South wind';
freqHOLIMO = summary(anData.oTemperature2(chosenDataDir))./freqTempSouth*100;
pc= anData.plotColorWindDir(1,:);
plot(JFJTemp,freqHOLIMO,'-d','MarkerFaceColor',pc,...
    'Color', pc)
chosenDataDir = chosenData &  anData.oWindDirection == 'North wind';
freqHOLIMO = summary(anData.oTemperature2(chosenDataDir))./freqTempNorth*100;
pc= anData.plotColorWindDir(2,:);
plot(JFJTemp,freqHOLIMO,'-d','MarkerFaceColor',pc,...
    'Color', pc)
pc= plotColor(5,:);
plot(korTemp,[11.2 18.45 27 35 60 38 24.23],':p','MarkerFaceColor',pc,...
    'Color', pc)
pc= plotColor(3,:);
plot(korTemp,sum(anData.korData(2:end-1,:)),'--s','MarkerFaceColor',pc,...
    'Color', pc)
pc = plotColor(4,:);
plot(buhlTemp, [1 1 0.95 0.9 0.4 0.2]*100,'-.o','MarkerFaceColor',pc,...
    'Color',pc);
box on
ylabel({'Frequency of occurrence [%]';'Mixed-phase clouds'})
set(gca, 'Ytick',[0 25 50 75 100]);

subplot(3,1,3)
hold on
chosenData = anData.chosenData & anData.oCloudPhase == 'Ice';
% freqHOLIMO = summary(anData.oTemperature2(chosenData))./freqTemp*100;
% plot(JFJTemp,freqHOLIMO,'Color',[0 0 0])
chosenDataDir = chosenData &  anData.oWindDirection == 'South wind';
freqHOLIMO = summary(anData.oTemperature2(chosenDataDir))./freqTempSouth*100;
pc= anData.plotColorWindDir(1,:);
plot(JFJTemp,freqHOLIMO,'-d','MarkerFaceColor',pc,...
    'Color', pc)
chosenDataDir = chosenData &  anData.oWindDirection == 'North wind';
freqHOLIMO = summary(anData.oTemperature2(chosenDataDir))./freqTempNorth*100;
pc= anData.plotColorWindDir(2,:);
plot(JFJTemp,freqHOLIMO,'-d','MarkerFaceColor',pc,...
    'Color', pc)
pc= plotColor(5,:);
plot(korTemp,[85 77 65 49 30 12 0.77],':p','MarkerFaceColor',pc,...
    'Color', pc)
pc= plotColor(3,:);
plot(korTemp,anData.korData(end,:),'--s','MarkerFaceColor',pc,...
    'Color', pc)

box on
xlabel('Temperature [°C]')
ylabel({' ';'Ice clouds'})
set(gca, 'Ytick',[0 25 50 75 100]);

set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperPosition',[0 0 15 15]);
set(gcf, 'PaperSize', [15 15]);

if anData.savePlots
    fileName = ['CloudPhaseFrequency'];
    print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
end