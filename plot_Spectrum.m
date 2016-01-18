function plot_Spectrum(anData2013All, day)
    clf      
    hold on
    plotColor =flipud(lbmap(4,'RedBlue'));
    
    chosenData = anData2013All.goodInt & ...
        anData2013All.timeStart > datenum([2013 02 day 0 0 0]) & ...
        anData2013All.timeStart < datenum([2013 02 day+1 0 0 0]);
    
    plotData = anData2013All.water.histRealCor(:,chosenData);
    plotData = abs(plotData);
    plotData(~isfinite(plotData)) = nan;
    for cnt2 = 1:size(plotData,1)
       plotDataError(cnt2,1) = nanstd(plotData(cnt2,:))./(numel(plotData(cnt2,:))^(1/2));
    end
    
    plotData = nanmean(plotData,2);
    q = integral(@(x) x.^2,0,1);
    p1 = stairs(anData2013All.Parameter.histBinBorder(3:22), ...
        plotData(3:22), 'LineWidth',2,'Color','k');
%     p11 = stairs(anData2013All.Parameter.histBinBorder(3:end-1), ...
%         plotData(3:end)+plotDataError(3:end), 'LineStyle', '-.', 'LineWidth',2,'Color','k');
%     p12 = stairs(anData2013All.Parameter.histBinBorder(3:end-1), ...
%         plotData(3:end)-plotDataError(3:end), 'LineStyle', '-.', 'LineWidth',2,'Color','k');
    
    plotData = anData2013All.ice.histRealCor(:,chosenData);
    plotData = abs(plotData);
    plotData(~isfinite(plotData)) = nan;
    for cnt2 = 1:size(plotData,1)
       plotDataError(cnt2,1) = nanstd(plotData(cnt2,:))./(numel(plotData(cnt2,:))^(1/2));
    end
    plotData = nanmean(plotData,2);
    p2 = stairs(anData2013All.Parameter.histBinBorder(3:22), ...
        plotData(3:22), ...
        'LineWidth',2,'LineStyle','--','Color','k');
%     p21 = stairs(anData2013All.Parameter.histBinBorder(3:end-1), ...
%         plotData(3:end)+plotDataError(3:end), 'LineStyle', '-.', 'LineWidth',2,'Color','k');
%     p22 = stairs(anData2013All.Parameter.histBinBorder(3:end-1), ...
%         plotData(3:end)-plotDataError(3:end), 'LineStyle', '-.', 'LineWidth',2,'Color','k');
%    
    
    %SID Data
    %if day == 8
    stairs(anData2013All.SIDSpektrum.binbounds(1:28), ...
        anData2013All.SIDSpektrum.dn_dlogdp_dropcm3(1:28), ...
        'LineWidth',2,'Color',plotColor(2,:));
    stairs(anData2013All.SIDSpektrum.binbounds(1:28), ...
        anData2013All.SIDSpektrum.dn_dlogdp_icecm3(1:28), ...
        'LineWidth',2,'LineStyle','--','Color',plotColor(2,:));
    %end
    
    %2DS Data
    
    norm = log(anData2013All.Manch2DS_binBorder(2:end))-...
        log(anData2013All.Manch2DS_binBorder(1:end-1));
    plotData = anData2013All.Manch2DS_PSD(:,chosenData);    
    plotData = abs(plotData);
    plotData(~isfinite(plotData)) = nan;
    for cnt2 = 1:size(plotData,1)
       plotDataError(cnt2,1) = nanstd(plotData(cnt2,:))./(numel(plotData(cnt2,:))^(1/2));
    end
    plotData = nanmean(plotData,2);
    stairs(anData2013All.Manch2DS_binMiddle, plotData./norm/1000, ...
        'LineWidth',2,'Color',plotColor(3,:));
%     stairs(anData2013All.Manch2DS_binMiddle, (plotData+plotDataError)./norm/1000, ...
%         'LineStyle', '-.' , 'LineWidth',2,'Color',plotColor(3,:));
%     stairs(anData2013All.Manch2DS_binMiddle, (plotData-plotDataError)./norm/1000, ...
%         'LineStyle', '-.', 'LineWidth',2,'Color',plotColor(3,:));
%     if day == 6
%     %2DS For HOLIMO
%     borders = anData2013All.Ice2DS_size-5;
%     borders(end+1) = borders(end)+10;
%     
%     norm = log(borders(2:end))-...
%         log(borders(1:end-1));
%     
%     stairs(anData2013All.Ice2DS_size, ...
%         anData2013All.Ice2DS_conc./norm*10/1000, ...
%         'LineWidth',2,'Color',plotColor(4,:));
%     
%     borders = anData2013All.All2DS_size-5;
%     borders(end+1) = borders(end)+10;
%     
%     norm = log(borders(2:end))-...
%         log(borders(1:end-1));
%     stairs(anData2013All.All2DS_size, ...
%         anData2013All.All2DS_conc./norm/1000, ...
%         'LineWidth',2,'Color',plotColor(5,:));
%     end
    %
    %     plotData = nanmean(anData2013AllAll.ManchCDPConcArrayMean);
    %     p2 = stair( anData2013AllAll.Parameter.ManchCDPBinSizes, ...
    %        plotData, ...
    %         'LineWidth',2,'Color','b');
    
    plotData = nanmean(anData2013All.ManchCDPConcArrayMeanNorm(1:end-1,chosenData),2);
    p2 = stairs(anData2013All.CDPEdgesLower(1:end-1), ...
        plotData, ...
        'LineWidth',2,'Color',plotColor(1,:));
    
    
        h_legend = legend({'HOLIMO Liquid', 'HOLIMO Ice','SID Liquid', 'SID Ice', '2DS', 'CDP'}, 'Location', 'NorthEast');
    
    set(h_legend,'FontSize',11);
    ylabel('Number density d(N)/d(log d) [cm^{-3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');

    xlim(gca, [3 300]);
    ylim(gca, [5e-3 5e3]);
    set(gca,'XTick',[2 5 10 20 50 100 200 500 1000])
    set(gca,'XTickLabel',{'2','5','10','20','50','100','200', '500','1000'})
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1 1e2 1e3])
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    box on    
    
    set(gcf, 'PaperUnits','centimeters');

    set(gcf, 'PaperPosition',[0 0.3 13 10]);
    set(gcf, 'PaperSize', [12.2 10.6]);
    
    title(datestr([2013 02 day 0 0 0]));
    
    if anData2013All.savePlots
        fileName = ['Comparision_Spectrum_New_' datestr([2013 02 day 0 0 0])];        
        print(gcf,'-dpdf','-r600', fullfile(anData2013All.saveDir,fileName));
    end


end

