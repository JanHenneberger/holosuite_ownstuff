function plot_IceFractionByTemperatureKorolev(anData)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    labels={ '-35 to -30°C (L=574km)'; '-30 to -25°C (L=2494km)'; ...
        '-25 to -20°C (L=3882km)'; '-20 to -15°C (L=7147km)'; ...
        '-15 to -10°C (L=11441km)'; '-10 to -5°C (L=19720km)'; ...
        '-5 to 0°C (L=16328km)'};
    %labels={ '-25 to -20°C'; '-20 to -15°C'; ...
    %    '-15 to -10°C'; '-10 to -5°C'};
   
    
    plotColor = flipud(lbmap(7,'RedBlue'));
    %plotColor = anData.plotColorTemp;
    
    stat=tabulate(anData.oIceFraction(anData.chosenData));
    
    
    hold on
    for cnt = 1:numel(labels)
        plot(anData.korFrac,anData.korData(:,cnt),'Color', plotColor(cnt,:),'LineWidth',1.5)
        %plot(anData.korFrac,anData.korData(:,cnt+2),'Color', plotColor(cnt,:),'LineWidth',1.5)
        
        
    end
    
    legend(labels,'Location','Best')
    xlabel('IWC/TWC')
    ylabel('Frequency [%]')
    title('Korolev')
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

