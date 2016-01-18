function plot_SpectraByWindDirection(anData, cntFig)
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here

    figure(cntFig)
    clf
    
    plotColor = anData.plotColorWindDir;
    subplot(1,2,1,'replace')
    hold on
    
    %         plotData = anData.water.histRealCor(:,anData.chosenData);
    %         plotData(~isfinite(plotData)) = nan;
    %         p1 = stairs(anData.Parameter.histBinMiddle, ...
    %             nanmean(plotData,2), ...
    %             'LineWidth',1.6,'Color','k');
    %         plotData = anData.ice.histRealCor;
    %         plotData(~isfinite(plotData)) = nan;
    %         p2 = stairs(anData.Parameter.histBinMiddle, ...
    %             nanmean(plotData,2), ...
    %             'LineWidth',1.6,'LineStyle','--','Color','k');
    
    
    plotData = anData.water.histRealCor(:,anData.oWindDirection == 'South wind' & anData.chosenData);
    plotData(~isfinite(plotData)) = nan;
    p3 = stairs(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2), ...
        'LineWidth',1.6,'Color',plotColor(1,:));
    plotData = anData.ice.histRealCor(:,anData.oWindDirection == 'South wind' & anData.chosenData);
    plotData(~isfinite(plotData)) = nan;
    p4 = stairs(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2), ...
        'LineWidth',1.6,'LineStyle','--','Color',plotColor(1,:));
    
    
    plotData = anData.water.histRealCor(:,anData.oWindDirection == 'North wind' & anData.chosenData);
    plotData(~isfinite(plotData)) = nan;
    p5 = stairs(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2), ...
        'LineWidth',1.6,'Color',plotColor(2,:));
    plotData = anData.ice.histRealCor(:,anData.oWindDirection == 'North wind' & anData.chosenData);
    plotData(~isfinite(plotData)) = nan;
    p6 = stairs(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2), ...
        'LineWidth',1.6,'LineStyle','--','Color',plotColor(2,:));
    
    h_legend = legend([p3 p5 p4 p6], {'Liquid - South wind', 'Liquid - North wind', ...
        'Ice - South wind',...
        'Ice - North wind'}, 'Location', 'NorthEast');
    
    set(h_legend,'FontSize',7);
    ylabel('Number density d(N)/d(log d) [cm^{-3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    
    xlim(gca, [6 250]);
    ylim(gca, [8e-3 3e2]);
    set(gca,'XTick',[10 20 50 100 200])
    set(gca,'YTick',[1e-2 1e-1 1e0 1e1 1e2])
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    set(gca,'FontSize',10);
    box on
    
    
    subplot(1,2,2,'replace')
    hold on
    
    %         plotData = anData.water.histRealCor(:,anData.chosenData);
    %         plotData(~isfinite(plotData)) = nan;
    %         stairs(anData.Parameter.histBinMiddle, ...
    %             nanmean(plotData,2)'.*...
    %            (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
    %             'LineWidth',1.6,'Color','k');
    %         plotData = anData.ice.histRealCor(:,anData.chosenData);
    %         plotData(~isfinite(plotData)) = nan;
    %         stairs(anData.Parameter.histBinMiddle, ...
    %             nanmean(plotData,2)'.*...
    %            (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
    %             'LineWidth',1.6,'LineStyle','--','Color','k');
    
    plotData = anData.water.histRealCor(:,anData.oWindDirection == 'South wind' & anData.chosenData);
    plotData(~isfinite(plotData)) = nan;
    stairs(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2)'.*...
        (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
        'LineWidth',1.6,'Color',plotColor(1,:));
    plotData = anData.ice.histRealCor(:,anData.oWindDirection == 'South wind' & anData.chosenData);
    plotData(~isfinite(plotData)) = nan;
    stairs(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2)'.*...
        (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
        'LineWidth',1.6,'LineStyle','--','Color',plotColor(1,:));
    
    plotData = anData.water.histRealCor(:,anData.oWindDirection == 'North wind' & anData.chosenData);
    plotData(~isfinite(plotData)) = nan;
    stairs(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2)'.*...
        (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
        'LineWidth',1.6,'Color',plotColor(2,:));
    plotData = anData.ice.histRealCor(:,anData.oWindDirection == 'North wind' & anData.chosenData);
    plotData(~isfinite(plotData)) = nan;
    stairs(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2)'.*...
        (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
        'LineWidth',1.6,'LineStyle','--','Color',plotColor(2,:));
    
    
    ylabel('Volume density d(N)/d(log d) [cm^{-3} \mum^{3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    
    xlim(gca, [6 250]);
    ylim(gca,[1.9e3 2e5]);
    set(gca,'XTick',[10 20 50 100 200])
    set(gca,'YTickLabel',{'2e3','5e3','1e4','2e4','5e4','1e5'},...
        'YTick',[2000 5000 10000 20000 50000 100000]);
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    set(gca,'FontSize',10);
    box on;
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-.7 0.1 21 9.8]);
    set(gcf, 'PaperSize', [18.7 9.8]);
    
    if anData.savePlots
        fileName = 'All_Spectra_WindDir';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    
end

