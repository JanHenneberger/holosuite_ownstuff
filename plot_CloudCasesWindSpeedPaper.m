function plot_CloudCasesWindSpeedPaper(anData,cntFig)
%UNTITLED23 Summary of this function goes here
%   Detailed explanation goes here

    figure(cntFig)
    clf
    
    subplot(1,4,1)
    xvar = anData.caseStats.WindVelMean;
    yvar = log(anData.caseStats.LWMeanDMean*1e6);
    
    ylimit = log([5 20]);
    yticks = log([5 10 20]);
    ytickslabel = {'5';'10';'20'};
    gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(xvar',yvar','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    set(gca, 'YLim',ylimit,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 14])
    ylabel('Mean diameter liquid [\mum]')
    box on
    
    subplot(1,4,2)
    xvar = anData.caseStats.WindVelMean;
    yvar = log(anData.caseStats.IWConcMean*1e3);
    
    ylimit = log([2 2000]);
    yticks = log([10 100 1000]);
    ytickslabel = {'10';'100';'1000'};
    %gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
    %    anData.plotColorWindDir,'.' ,[],'on')
    scatter(xvar, yvar,250,'.')
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(xvar',yvar','y~x1');
    [ypred,yci] = predict(foo,xfit');
    %plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    %plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    %plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    set(gca, 'YLim',ylimit,...
    'YTickLabel',ytickslabel,'Ytick',yticks);
    
%     l= findobj(gcf,'tag','legend'); 
%     l.Position(1) = 0.48;
%     l.FontSize = 9;
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 14])
    ylabel('Ice concentration [cm^{-3}]')
    box on
    
%     subplot(1,4,3)
%     xvar = anData.caseStats.WindVelMean;
%     yvar = log(anData.caseStats.IWMeanDMean*1e6);
%     
%     ylimit = log([40 200]);
%     yticks = log([20 50 100 200]);
%     ytickslabel = {'20';'50';'100';'200'};
%     gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
%         anData.plotColorWindDir,'.' ,[],'on')
%     hold on
%     plotLimit = 30;
%     xfit = linspace(0,plotLimit);
%     foo = LinearModel.fit(xvar',yvar','y~x1');
%     [ypred,yci] = predict(foo,xfit');
%     plot(xfit,ypred,'Color',[0.7 0.7 0.7])
%     plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
%     plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
%     set(gca, 'YLim',ylimit,...
%         'YTickLabel',ytickslabel,'Ytick',yticks);
%     
%     l= findobj(gcf,'tag','legend'); 
%     l.Position(1) = 0.48;
%     l.FontSize = 9;
%     %set(l,'location','northeastoutside','fontsize',9);
%     xlabel('Wind speed [m s^{-1}]')
%     xlim([0 14])
%     ylabel('Mean diameter ice[\mum]')
%     box on
%     
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1.6 0.1 24.4 4.9]);
    set(gcf, 'PaperSize', [14.3 5.1]);
    if anData.savePlots
        fileName = ['CloudCases_WindSpeed_Paper'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end 
    
end

