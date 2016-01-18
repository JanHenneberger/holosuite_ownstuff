function plot_IceFractionByTemperature(anData)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    labels = getlabels(anData.oTemperature(anData.chosenData));
    frequency = summary(anData.oTemperature(anData.chosenData));
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    legendString = strcat(labels, freqString);
    plotColor = anData.plotColorTemp;
    stat=tabulate(anData.oIceFraction(anData.chosenData));
    
    plot(anData.levelsIceFraction,[stat{:,3}],'LineStyle','--','Color',[0.7 0.7 0.7],'LineWidth',1.2)
    hold on
    for cnt = 1:numel(labels)
        tmp = anData.oIceFraction(anData.chosenData);
        stat=tabulate(tmp(anData.oTemperature(anData.chosenData)==labels{cnt}));
        plot(anData.levelsIceFraction,[stat{:,3}],'Color', plotColor(cnt,:),'LineWidth',1.5)
        
        %plot(anData.korFrac,anData.korData(:,3:6),'--k','LineWidth',1)
    end
    
    legend([{'All temperatures'},legendString],'Location','Best')
    xlabel('IWC/TWC')
    ylabel('Frequency [%]')
    title('All cases')
    if anData.plotTitle
        title([anData.campaignName ' - all directions'])
    end
    
    ylim([0,100])
    box on
    
    % tmp1 = anData.IWContent./anData.TWContent;
    % tmp1(isnan(tmp1))=0;
    % tmp1(isinf(tmp1))=0;
    %
    % tmp2 = anData.measMeanT;
    % aoctool(tmp1, tmp2,B);
    % anovan(tmp1,X,'Continuous',1:13,'varnames',varNames);
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 13 10]);
    set(gcf, 'PaperSize', [13 10]);
    if anData.savePlots
        fileName = ['All_IceFraction_Temp'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end

end

