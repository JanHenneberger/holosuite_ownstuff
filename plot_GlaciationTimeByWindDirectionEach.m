function plot_GlaciationTimeByWindDirectionEach( anData, cntFig )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

    figure(cntFig)
    cat = anData.oWindDirection.*anData.oCloudPhase;
    labels = getlabels(cat);
    frequency = summary(anData.oWindDirection(anData.chosenData));
    frequency = [repmat(frequency(1),1,3) repmat(frequency(2),1,3)];
    clear freqString

    plotColor = anData.plotColorWindDir;
    plotColor = [repmat(plotColor(1,:),3,1); repmat(plotColor(2,:),3,1)];
    lineSt = {'--','-',':','--','-',':'};
    legendString = {'South-east/Liquid'; 'South-east/Mixed'; 'South-east/Ice'; ...
        'North-west/Liquid'; 'North-west/Mixed'; 'North-west/Ice'};
    hold on
    
    
    minVal = nanmin(anData.glaciationTime(anData.chosenData));
    maxVal = nanmax(anData.glaciationTime(anData.chosenData));
    binsLog = linspace(log(minVal),log(maxVal+1),20); 
    binsLog(end+1) = 2*binsLog(end)-binsLog(end-1);
    anData.glaciationTime(isnan(anData.glaciationTime)) = maxVal;
    binsLin = exp(binsLog);
    
    uperSizes = binsLin;
    uperSizes(1) = [];
    lowerSizes = binsLin(1:end-1);
    %bin width on a linear scale
    linBinWidth = uperSizes - lowerSizes;
    %bin width on a log scale
    logBinWidth = log(uperSizes) - log(lowerSizes);
    chosen = [1 2 3 4 5 6];    
for cnt = chosen
    var = anData.glaciationTime(cat==labels{cnt} & anData.chosenData);
    %histogram(var, bins, 'Normalization','pdf','DisplayStyle','stairs');
    counts  = histcounts(var, binsLin);
    plotCounts(cnt) = sum(counts);
    %stairs(0.5*uperSizes + 0.5*lowerSizes, counts/frequency(cnt)./logBinWidth,...
    %    'LineStyle',lineSt{cnt},'Color',plotColor(cnt,:));
    
    
    stairs(0.5*uperSizes + 0.5*lowerSizes, counts/sum(counts),...
        'LineStyle',lineSt{cnt},'Color',plotColor(cnt,:));
    

end

    legend(legendString(chosen),'fontSize',9, 'Location', 'northwest')
    set(gca,'XScale','log');
    set(gca,'XLim',[minVal 40000])
       set(gca, 'XTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000';'10000';},'XTick',[0.001 0.01 0.1 1 10 100 1000 10000])
    set(gca,'YLim',[0 .75])
    xlabel('Glaciation time [s]')
    ylabel('PDF')
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    
    box on
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 13 10.4]);
    set(gcf, 'PaperSize', [13 10]);
    
    if anData.savePlots
        fileName = 'Frequency_GlaciationTimeByWindDirectionEach';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    
end

