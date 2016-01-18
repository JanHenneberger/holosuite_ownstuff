function plot_IceFractionByWindVelWindDierction(anData, cntFig )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    figure(cntFig)
    gcf
    anData.chosenDataWind = anData.oWindDirection == anData.chosenWindDirection & anData.chosenData;
    levels = anData.levelsIceFraction;
    labels = getlabels(anData.oWindVMeteo(anData.chosenDataWind));
    frequency = summary(anData.oWindVMeteo(anData.chosenDataWind));
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    legendString = strcat(labels, freqString);
    plotColor = anData.plotColorWindVel;
    stat=tabulate(anData.oIceFraction(anData.chosenDataWind));
    
    plot(levels,[stat{:,3}],'LineStyle','--','Color',[0.7 0.7 0.7],'LineWidth',1.2)
    hold on
    for cnt = 1:numel(labels)
        tmp = anData.oIceFraction(anData.chosenDataWind);
        stat=tabulate(tmp(anData.oWindVMeteo(anData.chosenDataWind)==labels{cnt}));
        plot(levels,[stat{:,3}],'Color', plotColor(cnt,:),'LineWidth',1.5)
    end
    
    legend([{'All'},legendString],'Location','NorthEast')
    xlabel('IWC/TWC')
    ylabel('Frequency [%]')
    ylim([0 100]);
    if strcmpi(anData.chosenWindDirection,'South wind')
        title('Southerly wind cases')
    else
        title('Northerly wind cases')
    end
    
    
    if anData.plotTitle
        title([anData.campaignName ' - ' anData.chosenWindDirection])
    end
    %ylim([-5,105])
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
        fileName = ['All_IceFraction_WindVel_' anData.chosenWindDirection];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    

end

