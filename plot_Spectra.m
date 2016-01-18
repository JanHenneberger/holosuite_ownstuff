function plot_Spectra(anData, cntFig)
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here

    figure(cntFig)
    clf
    
    plotColor = anData.plotColorWindDir;
    
    hold on  

    
    plotData = anData.water.histRealCor(:,anData.chosenData);
    plotData(~isfinite(plotData)) = nan;
    p3 = stairs(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2), ...
        'LineWidth',1.6,'Color',plotColor(2,:));
    plotData = anData.ice.histRealCor(:,anData.chosenData);
    plotData(~isfinite(plotData)) = nan;
    p4 = stairs(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2), ...
        'LineWidth',1.6,'LineStyle','-','Color',plotColor(1,:));
    
    

    
    h_legend = legend({'Liquid', 'Ice'});
    
    
    set(h_legend,'FontSize',7);
    ylabel('Number density d(N)/d(log d) [cm^{-3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    
    xlim(gca, [6 250]);
    ylim(gca, [8e-3 3e2]);
    set(gca,'XTick',[10 20 50 100 200])
    set(gca,'YTick',[1e-2 1e-1 1e0 1e1 1e2])
    set(gca,'XTickLabel',{'10','20','50','100','200'})
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    set(gca,'FontSize',12);
    h_legend.FontSize = 15;
    box on
    
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0.1 10 9.8]);
    set(gcf, 'PaperSize', [10 9.8]);
    
    if anData.savePlots
        fileName = 'All_Spectra';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    
end

