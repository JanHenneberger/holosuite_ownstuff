function plot_SpectaRatio(anData2013All, day)

if ~exist('day','var')
    chosenData = anData2013All.goodInt;
else
    chosenData = anData2013All.goodInt & ...
        anData2013All.timeStart > datenum([2013 02 day 0 0 0]) & ...
        anData2013All.timeStart < datenum([2013 02 day+1 0 0 0]);
end

    clf
    hold on
    plotColor =flipud(lbmap(2,'RedBlue'));
    plotDataXEdges = anData2013All.Parameter.histBinBorder(3:16);
    plotDataX1 = anData2013All.Parameter.histBinMiddle(3:16);
    plotDataY1 = anData2013All.water.histRealCor(3:16,chosenData) + anData2013All.ice.histRealCor(3:16,chosenData);
    plotDataY1(~isfinite(plotDataY1)) = nan;
    plotDataY1 = nanmean(plotDataY1,2)';
  
    plotDataX2 = anData2013All.CDP2Sizes(2:end)';
    plotDataY2 = nanmean(anData2013All.ManchCDP2ConcArrayMeanNorm(:,chosenData),2);
    plotDataY2 = plotDataY2(2:end,:);
    
    subplot(1,3,1)
    stairs(plotDataX1,plotDataY1, ...
        'LineWidth',2,'Color','k');
    hold on
    stairs(plotDataX2,plotDataY2', ...
        'LineWidth',2,'LineStyle','--','Color','k');
        ylabel('Number density d(N)/d(log d) [cm^{-3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    xlim(gca, [5 55]);
    ylim(gca,[0.5 5e3])
    set(gca,'XTick',[2 5 10 20 50 100 200])
    legend('HOLIMO','CDP')
    
    subplot(1,3,2)
    plot(plotDataX1, plotDataY2./plotDataY1');
    set(gca,'XScale','log');
    xlabel('Diameter [\mum]')
    ylabel('Concentration ratio HOLIMO/CDP')
    xlim(gca, [5 55]);
    set(gca,'XTick',[2 5 10 20 50 100 200])
    box on
    
    subplot(1,3,3)
    hold on
    edges = [-1 5 10 20];
    labels={ '0-5 m/s'; '5-10 m/s';'10-20 m/s'};

    
    Y = anData2013All.meteoWindVel;
    anData2013All.oWindVMeteo= ordinal(Y,labels,[],edges);
    anData2013All.oWindVMeteo = droplevels(anData2013All.oWindVMeteo);

    choseDataTmp = anData2013All.oWindVMeteo(chosenData);  
    labels = getlabels(choseDataTmp);
    frequency = summary(choseDataTmp);
    
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    legendString = strcat(labels, freqString);
    
    plotColor = lbmap(numel(labels)+1,'Blue');
    plotColor(1,:)= [];
    plotColor2 = lbmap(2*numel(labels),'RedBlue');
    

    for cnt = 1:numel(labels)
        plotData = anData2013All.water.histRealCor+anData2013All.ice.histRealCor;
        plotData = plotData(3:16,chosenData);
        plotData = plotData(:,choseDataTmp==labels{cnt});
        plotData(~isfinite(plotData)) = nan;
        plot(anData2013All.Parameter.histBinMiddle(3:16), ...
            nanmean(plotData,2), ...
            'LineWidth',1.6,'Color',plotColor(cnt,:));
        
            

            
        plotDataX2 = anData2013All.CDP2Sizes(2:end);
        plotData2 = anData2013All.ManchCDP2ConcArrayMeanNorm;
        plotData2 = plotData2(2:end,chosenData);
        plotData2 = plotData2(:,choseDataTmp==labels{cnt});
        plot(plotDataX2, ...
            nanmean(plotData2,2), ...
            'LineWidth',1.6,'LineStyle','--','Color',plotColor(cnt,:));
    end

    h_legend = legend(legendString);
    set(h_legend,'FontSize',8);
    ylabel('Number density d(N)/d(log d) [cm^{-3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    
    xlim(gca, [5 55]);
    ylim(gca, [1e-1 1e3]);
    set(gca,'XTick',[10 20 50 100 200])
    set(gca,'YTick',[1e-2 1e-1 1e0 1e1 1e2])
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    box on
    
    
    set(gcf, 'PaperUnits','centimeters');

    set(gcf, 'PaperPosition',[0 0 22 10]);
    set(gcf, 'PaperSize', [21 9.6]);
    
    if anData2013All.savePlots
        fileName = ['Comparision_Spectrum_Ratio_New2_' num2str(date,'%02u')];        
        print(gcf,'-dpdf','-r600', fullfile(anData2013All.saveDir,fileName));
    end
end

