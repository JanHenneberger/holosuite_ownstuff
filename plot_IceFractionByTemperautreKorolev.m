function plot_IceFractionByTemperatureKorolev(anData)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    edges = [-35 -30 -25 -20 -15 -10 -5 0];
    middle = [-32.5:5:-2.5];
    labels={ '-35 to -30°C'; '-30 to -25°C'; '-25 to -20°C'; '-20 to -15°C'; ...
        '-15 to -10°C'; '-10 to -5°C'; '-5 to 0°C'};
    
   
    
    plotColor = flipud(lbmap(7,'RedBlue'));
    stat=tabulate(anData.oIceFraction(anData.chosenData));
    
    %plot(anData.levelsIceFraction,[stat{:,3}],'LineStyle','--','Color',[0.7 0.7 0.7],'LineWidth',1.2)
    hold on
    for cnt = 1:numel(labels)
        plot(anData.korFrac,anData.korData(:,cnt)*100,'Color', plotColor(cnt,:),'LineWidth',1.5)
        
        %plot(anData.korFrac,anData.korData(:,3:6),'--k','LineWidth',1)
    end
    
    legend(labels,'Location','Best')
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
        fileName = ['All_IceFraction_TempKorolev'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end

end

