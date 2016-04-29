function plot_GlaciationTimeByWindDirection( anData, cntFig )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

    figure(cntFig)
    labels = getlabels(anData.oWindDirection);
    frequency = summary(anData.oWindDirection(anData.chosenData));
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    %dayString = {', 1 day',', 6 days'};
    dayString = {'',''};
    legendString = strcat(labels, freqString, dayString);
    plotColor = anData.plotColorWindDir;
    hold on

%     for cnt = 1:numel(labels)
%         stat=tabulate(anData.anData.oGlactiationTime(anData.oWindDirection==labels{cnt} & anData.chosenData));
%         plot(anData.levelsIceFraction,[stat{:,3}],'Color', plotColor(cnt,:),'LineWidth',2)
%     end
    minVal = nanmin(anData.glaciationTime(anData.chosenData));
    maxVal = nanmax(anData.glaciationTime(anData.chosenData));
    binsLog = linspace(log(minVal),log(maxVal),30); 
    binsLin = exp(binsLog);
    
    uperSizes = binsLin;
    uperSizes(1) = [];
    lowerSizes = binsLin(1:end-1);
    %bin width on a linear scale
    linBinWidth = uperSizes - lowerSizes;
    %bin width on a log scale
    logBinWidth = log(uperSizes) - log(lowerSizes);
for cnt = 1:numel(labels)
    var = anData.glaciationTime(anData.oWindDirection==labels{cnt} & anData.chosenData);
    %histogram(var, bins, 'Normalization','pdf','DisplayStyle','stairs');
    counts  = histcounts(var, binsLin);
    stairs(0.5*uperSizes + 0.5*lowerSizes, counts/sum(counts)./logBinWidth,'Color',plotColor(cnt,:));
end

    legend({'South-east wind cases'; 'North-west wind cases'},'fontSize',11, 'Location', 'north')
    set(gca,'XScale','log');
    set(gca,'XLim',[minVal maxVal])
    set(gca,'YLim',[0 .6])
    xlabel('Glaciation time [s]')
    ylabel('PDF')
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    
    box on
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 13 10]);
    set(gcf, 'PaperSize', [13 10]);
    
    if anData.savePlots
        fileName = 'Frequency_GlaciationTimeByWindDirection';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    
end

