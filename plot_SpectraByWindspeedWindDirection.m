function plot_SpectraByWindspeedWindDirection(anData, cntFig)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here

    figure(cntFig)
    clf
    
    
    anData.chosenDataWind = anData.oWindDirection == anData.chosenWindDirection & anData.chosenData;
    
    
    subplot(1,2,1,'replace')
    hold on
    choseDataTmp = anData.oWindVMeteo(anData.chosenDataWind);
    
    

    
    labels = getlabels(choseDataTmp);
    frequency = summary(choseDataTmp);
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    legendString = strcat(labels, freqString);
    plotColor = anData.plotColorWindVel;
    for cnt = 1:numel(labels)
        plotData = anData.water.histRealCor(:,choseDataTmp==labels{cnt});
        plotData(~isfinite(plotData)) = nan;
        stairs(anData.Parameter.histBinMiddle, ...
            nanmean(plotData,2), ...
            'LineWidth',1.6,'Color',plotColor(cnt,:));
    end
    
    for cnt = 1:numel(labels)
        plotData = anData.ice.histRealCor(:,choseDataTmp==labels{cnt});
        plotData(~isfinite(plotData)) = nan;
        stairs(anData.Parameter.histBinMiddle, ...
            nanmean(plotData,2), ...
            'LineWidth',1.6,'LineStyle','--','Color',plotColor(cnt,:));
        
    end
    h_legend = legend([legendString]);
    set(h_legend,'FontSize',8);
    ylabel('Number density d(N)/d(log d) [cm^{-3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    
    xlim(gca, [6 250]);
    ylim(gca, [8e-3 3e2]);
    set(gca,'XTick',[10 20 50 100 200])
    set(gca,'YTick',[1e-2 1e-1 1e0 1e1 1e2])
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    box on
    
    
    subplot(1,2,2,'replace')
    hold on
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    legendString = strcat(labels, freqString);
    
    for cnt = 1:numel(labels)
        plotData = anData.water.histRealCor(:,choseDataTmp==labels{cnt});
        plotData(~isfinite(plotData)) = nan;
        stairs(anData.Parameter.histBinMiddle, ...
            nanmean(plotData,2)'.*...
            (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
            'LineWidth',1.6,'Color',plotColor(cnt,:));
    end
    
    for cnt = 1:numel(labels)
        plotData = anData.ice.histRealCor(:,choseDataTmp==labels{cnt});
        plotData(~isfinite(plotData)) = nan;
        stairs(anData.Parameter.histBinMiddle, ...
            nanmean(plotData,2)'.*...
            (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
            'LineWidth',1.6,'LineStyle','--','Color',plotColor(cnt,:));
        
    end
    
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
    box on;
    if anData.plotTitle
        mtit([anData.campaignName ' - ' anData.chosenWindDirection])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-.7 0.1 21 9.8]);
    set(gcf, 'PaperSize', [18.7 9.8]);
    
    
    if anData.savePlots
        fileName = ['All_Spectra_WindVel_' anData.chosenWindDirection];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
end

