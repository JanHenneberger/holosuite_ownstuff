function plot_IceFractionByWindVel(anData, cntFig )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    figure(cntFig)
    gcf
    labels = getlabels(anData.oWindVMeteo(anData.chosenData));
    frequency = summary(anData.oWindVMeteo(anData.chosenData));
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    legendString = strcat(labels, freqString);
    plotColor = anData.plotColorWindVel;
    stat=tabulate(anData.oIceFraction(anData.chosenData));
    
    plot(anData.levelsIceFraction,[stat{:,3}],'LineStyle','--','Color',[0.7 0.7 0.7],'LineWidth',1.2)
    hold on
    for cnt = 1:numel(labels)
        tmp = anData.oIceFraction(anData.chosenData);
        stat=tabulate(tmp(anData.oWindVMeteo(anData.chosenData)==labels{cnt}));
        plot(anData.levelsIceFraction,[stat{:,3}],'Color', plotColor(cnt,:),'LineWidth',1.5)
    end
    
    legend([{'All velocities'},legendString],'Location','NorthEast')
    xlabel('IWC/TWC')
    ylabel('Frequency [%]')
    title('All cases')
    if anData.plotTitle
        title([anData.campaignName ' - all directions' ])
    end
    ylim([0,100])
    box on
    
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 13 10]);
    set(gcf, 'PaperSize', [13 10]);
    if anData.savePlots
        fileName = ['All_IceFraction_WindVel'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end

end

