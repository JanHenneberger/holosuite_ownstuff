function plot_boxplotIceConc( anData, cntFig )
f=figure(cntFig)
clf
plotColor = anData.plotColorWindDir;
log(anData.caseStats.IWConcMean)
tmpInt = anData.chosenData & isfinite(anData.TWContent);
group = droplevels(anData.oCase(tmpInt));
yvar = log(anData.IWConcentraction(tmpInt)+0.0000001);
yvar = real(yvar)
pos = anData.caseStats.TempMean;
%boxplot(xvar,group,'Position',pos,'symbol','k+','outliersize',3)
boxplot(yvar,group,'Position',pos,'colorgroup',anData.caseStats.oWindDirection,'color',plotColor,'plotstyle','compact','medianstyle','line','symbol','.','notch','off')
hold on

yvar =   log(anData.caseStats.IWConcMean);
a= gscatter(pos, yvar,anData.caseStats.oWindDirection, ...
    plotColor,'o' ,[],'off');
set(a(1), 'MarkerFaceColor', 'w')
set(a(2), 'MarkerFaceColor', 'w')
plot([0 1],[0 1],'Color', plotColor(1,:))
plot([0 1],[0 1],'Color', plotColor(2,:))
legend(flipud(unique(char(anData.caseStats.oWindDirection),'rows')),'location','NorthWest')
plotColorIN = lbmap(5,'BrownBlue');
scatter([-32 -32 -32 -32], log([1.6 0.47 0.68 4.8]/1000),25,plotColorIN(2,:),'filled')
% INdata = log([1.6 0.47 0.68 4.8]/1000);
% INstd = log([0.9 .26 .33 8.2]/1000);
% INupper = INdata+INstd;
% INlower = INdata-INstd;
% e = errorbar([-32 -32 -32 -32],INdata ,INlower, INupper);%,25,plotColorIN(2,:),'filled')
text(-30,log(1/1000),'\leftarrow Ice nuclei','Color',plotColorIN(2,:),'FontSize',10 )

ylimit = log([0.00012 10]);
yticks = log([0.0001 0.001 0.01 0.1 1 10 100 1000]);
ytickslabel = {'0.0001';'0.001';'0.01';'0.1';'1';'10';'100';'1000'};
set(gca, 'YLim',ylimit,...
    'YTickLabel',ytickslabel,'Ytick',yticks);
xlim([-35 -3])

ylabel('Ice conc. [cm^{-3}]')
set(gca,'XTick',-30:5:0,'XTickLabel',{'-30','-25','-20','-15','-10','-5','0'})
xlabel('Temperature [°C]')
annotation(f,'textbox',...
    [0.387458333333333 0.0413105413105413 0.2865 0.0541310541310542],...
    'String',{'Temperature [°C]'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
if anData.plotTitle
    mtit([anData.campaignName])
end
set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperPosition',[0 0.1 15 12]);
set(gcf, 'PaperSize', [15 12]);

if anData.savePlots
    fileName = ['CloudCase_Conc_Temp_Boxplot'];
    print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
end

end