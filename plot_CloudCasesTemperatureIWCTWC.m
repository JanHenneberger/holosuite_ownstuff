function plot_CloudCasesTemperaturePaper(anData,cntFig)
%UNTITLED24 Summary of this function goes here
%   Detailed explanation goes here
    figure(cntFig)
    clf
    plotColor = anData.plotColorWindDir;
    
    

    xvar = anData.caseStats.TempMean;
    yvar = anData.caseStats.IWCTWCMean;
    
    xerror = anData.caseStats.TempStd;
    yerror = anData.caseStats.IWCTWCStd;
         
    

    ylimit = [0 1];
    yticks = [0 0.2 0.4 0.6 0.8 1];
    ytickslabel = {'0';'0.2';'0.4';'0.6';'0.8';'1'};
    %gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
    %    plotColor,'.' ,[],'off')
    errorbar(xvar,yvar,yerror,'k','LineStyle','none');
    hold on
    gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
        plotColor,'.' ,[],'on')
    
    hold on
    xfit = linspace(-30,0);
    foo = LinearModel.fit(xvar',yvar','y~x1');
    [ypred,yci] = predict(foo,xfit');
%     plot(xfit,ypred,'Color',[0.7 0.7 0.7])
%     plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
%     plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    set(gca, 'YLim',ylimit,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    xlabel('Temperature [°C]')
    ylabel('IWC/TWC')
    xlim([-30 0])
    box on
    
    
    
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 10 8]);
    set(gcf, 'PaperSize', [10 8]);
    
    if anData.savePlots
        fileName = ['CloudCase_IWCTWC_Temp_Paper'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end

end

