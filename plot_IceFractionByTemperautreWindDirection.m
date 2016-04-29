function plot_IceFractionByTemperautreWindDirection( anData )
%UNTITLED6 Summary of this function goes here

oTemp = anData.oTemperature;
% if strcmpi(anData.chosenWindDirection, 'South wind')
%     oTemp = mergelevels(oTemp,{'-25 to -20°C','-20 to -15°C'}, '-20 to -15°C');
% end
    anData.chosenDataWind = anData.oWindDirection == anData.chosenWindDirection & anData.chosenData;
    
    levels = anData.levelsIceFraction;
    labels = getlabels(oTemp(anData.chosenDataWind));
    frequency = summary(oTemp(anData.chosenDataWind));
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    
    plotColor = anData.plotColorTemp;
    stat=tabulate(anData.oIceFraction(anData.chosenDataWind));
    
    plot(levels,[stat{:,3}],'LineStyle','--','Color',[0.7 0.7 0.7],'LineWidth',1.2)
    hold on
    if strcmpi(anData.chosenWindDirection, 'South wind')
        for cnt = 2:numel(labels)
            tmp = anData.oIceFraction(anData.chosenDataWind);
            stat=tabulate(tmp(oTemp(anData.chosenDataWind)==labels{cnt}));
            plot(levels,[stat{:,3}],'Color', plotColor(cnt,:),'LineWidth',1.5)
        end
    
        legendString = strcat(labels(2:end), freqString(2:end));
    else
        for cnt = 1:numel(labels)
            tmp = anData.oIceFraction(anData.chosenDataWind);
            stat=tabulate(tmp(oTemp(anData.chosenDataWind)==labels{cnt}));
            plot(levels,[stat{:,3}],'Color', plotColor(cnt,:),'LineWidth',1.5)
            legendString = strcat(labels, freqString);
        end
  
    end
    
    legend([{'All Temp.'},legendString],'Location','Best')
    xlabel('IWC/TWC')
    ylabel('Frequency [%]')
    ylim([0 100]);
    if strcmpi(anData.chosenWindDirection,'South wind')
        title('South-east wind cases')
    else
        title('North-west wind cases')        
    end
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
        fileName = ['All_IceFraction_Temp_' anData.chosenWindDirection];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end

end

