function plot_boxplotTemperatureIWCTWC2( anData, cntFig )
figure(cntFig)
    clf
    plotColor = anData.plotColorWindDir;
    
tmpInt = anData.chosenData & isfinite(anData.TWContent) & ~(anData.oTemperature=='-25 to -20°C' & anData.oWindDirection=='South wind');
group1 = anData.oTemperature(tmpInt);
group2 = anData.oWindDirection(tmpInt);
group = {group1,group2};
yvar = anData.IWContent(tmpInt)./anData.TWContent(tmpInt);
pos = anData.caseStats.TempMean;

boxplot(yvar,group,'color',plotColor,'factorgap',[20 0],'factorseparator',[1],'labelverbosity','all','plotstyle','compact','medianstyle','target','symbol','.','notch','off')
hold on
yvar = anData.caseStats.IWCTWCMean;

plot([0 0],[0 1],'Color', plotColor(2,:))
plot([0 0],[0 1],'Color', plotColor(1,:))
%legend(flipud(unique(char(anData.caseStats.oWindDirection),'rows')),'location','SouthWest')
legend({'South-east wind cases';'North-west wind cases'},'location','SouthWest')

ylim([0 1])
ylabel('IWC/TWC')


  if anData.plotTitle
        mtit([anData.campaignName])
  end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0.1 15 12]);
    set(gcf, 'PaperSize', [15 12]);
    
    if anData.savePlots
        fileName = ['CloudCase_IWCTWC_Temp_Paper4'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    
end