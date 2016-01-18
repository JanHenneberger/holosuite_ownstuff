function plot_IceFractionByWindDirection( anData, cntFig )
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
    %plot(anData.korFrac,mean(anData.korData,2),'--k','LineWidth',2)
    %plot(anData.korFrac,anData.korData(:,5),'--k','LineWidth',2)
    %plot(anData.korFrac,anData.korData(:,6),'--k','LineWidth',2)
    plot(anData.korFrac,mean(anData.korData(:,5:7),2),'--k','LineWidth',2)
    for cnt = 1:numel(labels)
        stat=tabulate(anData.oIceFraction(anData.oWindDirection==labels{cnt} & anData.chosenData));
        plot(anData.levelsIceFraction,[stat{:,3}],'Color', plotColor(cnt,:),'LineWidth',2)
    end
    ylim([0 80])
    legend([{'Korolev (BASE/CFDE/FIRE3/AIRS)'}, legendString],'fontSize',11, 'Location', 'north')
    xlabel('IWC/TWC')
    ylabel('Frequency [%]')
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    
    box on
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 13 10]);
    set(gcf, 'PaperSize', [13 10]);
    
    if anData.savePlots
        fileName = 'All_IceFraction_WindDir';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    
end

