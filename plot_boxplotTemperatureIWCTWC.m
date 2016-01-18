function plot_boxplotTemperatureIWCTWC( anData, cntFig )
figure(cntFig)
    clf
    plotColor = anData.plotColorWindDir;
    
tmpInt = anData.chosenData & isfinite(anData.TWContent);
group = droplevels(anData.oCase(tmpInt));
yvar = anData.IWContent(tmpInt)./anData.TWContent(tmpInt);
pos = anData.caseStats.TempMean;
%boxplot(xvar,group,'Position',pos,'symbol','k+','outliersize',3)
boxplot(yvar,group,'Position',pos,'colorgroup',anData.caseStats.oWindDirection,'color',plotColor,'plotstyle','compact','medianstyle','target','symbol','.','notch','off')
hold on
yvar = anData.caseStats.IWCTWCMean;
% a= gscatter(pos, yvar,anData.caseStats.oWindDirection, ...
%        plotColor,'o' ,[],'off');
%    set(a(1), 'MarkerFaceColor', 'w')
%    set(a(2), 'MarkerFaceColor', 'w')
plot([0 1],[0 1],'Color', plotColor(1,:))
plot([0 1],[0 1],'Color', plotColor(2,:))
legend(flipud(unique(char(anData.caseStats.oWindDirection),'rows')),'location','NorthEast')
    
xlim([-27 -3])
ylim([0 1])
xlabel('Temperature [°C]')
ylabel('IWC/TWC')
set(gca,'XTick',-30:5:0,'XTickLabel',{'-30','-25','-20','-15','-10','-5','0'})

  if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0.1 15 12]);
    set(gcf, 'PaperSize', [15 12]);
    
    if anData.savePlots
        fileName = ['CloudCase_IWCTWC_Temp_Paper3'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    
end