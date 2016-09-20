function plot_boxplotIceConc( anData, cntFig )
f=figure(cntFig)
clf
plotColor = anData.plotColorWindDir;
tmpInt = anData.chosenData & isfinite(anData.TWContent);
group = droplevels(anData.oCase(tmpInt));
yvar = log((anData.IWConcentraction(tmpInt)+0.0000001)*1000);
yvar = real(yvar);
pos = anData.caseStats.TempMean;
%boxplot(xvar,group,'Position',pos,'symbol','k+','outliersize',3)
%boxplot(yvar,group,'Position',pos,'colorgroup',anData.caseStats.oWindDirection,...
%    'color',plotColor,'plotstyle','compact','medianstyle','line','symbol','.','notch','off')
hold on
boxplot(yvar,group,'Position',pos,...
    'color', plotColor(2,:),'plotstyle','compact','medianstyle','line','symbol','.','notch','off')

yvar =log(anData.caseStats.IWConcMean*1000);
% a= gscatter(pos, yvar,anData.caseStats.oWindDirection, ...
%     plotColor,'o' ,[],'off');
% 
% set(a(1), 'MarkerFaceColor', 'w')
% set(a(2), 'MarkerFaceColor', 'w')
% plot([0 1],[0 1],'Color', plotColor(2,:))
% plot([0 1],[0 1],'Color', plotColor(2,:))
 a= scatter(pos, yvar,30,plotColor(2,:),'o','MarkerFaceColor', 'w');
%legend({'Ice crystal';'INP'},'location','NorthWest')

%plotColorIN = lbmap(5,'BrownBlue');
plotColorIN = plotColor(1,:);
%scatter([-32 -32 -32 -32], log([1.6 0.47 0.68 4.8]/1000),25,plotColorIN(2,:),'filled')

INdata = log([1.7869225 0.546180138 6.148832727 7.855940297 4.635711431 ...
    6.200730006 6.87890141 1.438289304 53.6023857 6.148832727 4.809738284 ...
    6.223744538 33.32195351 42.19651238 76.56155999 18.8352604 ...
    14.57134 62.8877676 48.99992647 24.15435647 150.0001471 ...
    0.72 0.59 0.59 0.47 0.8 0.49 0.27 0.23 0.11 0.24 0.26 0.3 1.16 ...
    0.31 0.54 0.18 0.17 0.28 0.32 0.45 0.27 0.48 0.53 0.32 0.67 0.34 ...
     0.47 0.2 0.31 0.14 0.2 0.47 0.63 0.48 0.56 0.92 0.23 0.13 0.32 ...
      0.34 0.72 0.58 0.59 0.39 0.66 0.8]);
INmean = log([4.436438477	26.87108597	59.03598723 0.44]);
INGroup = [1 1 1 1 1 1 1 1 3 2 2 2 2 2 2 2 3 3 3 3 3 ...
    4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 ...
    4 4 4 4 4 4 4 4 4 4 4];
INPos = [-32 -32 -32 -26];
INcat = categorical(INGroup);

INcat = removecats(INcat, '2');
INPos = INPos([1 3 4]);
INmean = INmean([1 3 4]);
boxplot(INdata, INcat, 'Position', INPos ,'color',plotColorIN,...
    'plotstyle','compact','medianstyle','line','symbol','.','notch','off')

a= scatter(INPos, INmean, [], plotColorIN,'o');
set(a, 'MarkerFaceColor', 'w')

% INdata = log([1.6 0.47 0.68 4.8]/1000);
% INstd = log([0.9 .26 .33 8.2]/1000);
% INupper = INdata+INstd;
% INlower = INdata-INstd;
% e = errorbar([-32 -32 -32 -32],INdata ,INlower, INupper);%,25,plotColorIN(2,:),'filled')
%text(-30,log(1/1000),'\leftarrow Ice nuclei','Color',plotColorIN(2,:),'FontSize',10 )
%text(-30,log(10),'\leftarrow Ice nuclei','Color',plotColorIN(2,:),'FontSize',10 )




ylimit = log([0.010 10000]);
yticks = log([0.0001 0.001 0.01 0.1 1 10 100 1000 10000]);
ytickslabel = {'0.0001';'0.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'};
set(gca, 'YLim',ylimit,...
    'YTickLabel',ytickslabel,'Ytick',yticks);
xlim([-35 -3])

ylabel('Concentration [L^{-1}]')
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