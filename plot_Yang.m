function plot_Yang(anData,cntFig)
%UNTITLED19 Summary of this function goes here
%   Detailed explanation goes here

    figure(cntFig)
    clf
    chosenData = anData.chosenData & anData.IWContent < 4 & anData.IWContent > 0 &...
        isfinite(anData.IWConcentraction) & isfinite(anData.IWContent);
    
    subplot(3,4,1)
    xvar = real(log(anData.IWConcentraction(chosenData)));
    yvar = real(log(anData.IWContent(chosenData)));
    
    
    yticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    ytickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    xticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    xtickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    gscatter(xvar, yvar,anData.oWindDirection(chosenData), ...
        anData.plotColorWindDir,'.' ,7,'off')
    hold on
    slope = 1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(2,:));
    slope = 2.5;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(3,:));
    slope = -5;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(4,:));
    set(gca, 'YLim',[-11 2],...
        'XTickLabel',xtickslabel,'Xtick',xticks,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    
    xlabel('Ice concetration [cm^{-3}]')
    xlim([-7 3])
    ylabel('Ice water content [g m^{-3}]')
    title('all data')
    box on
    
    
    chosenData = anData.chosenData & anData.IWContent < 4 & anData.IWContent > 0 &...
        isfinite(anData.IWConcentraction) & isfinite(anData.IWContent) & ...
        anData.oWindDirection == 'South wind';
    
    subplot(3,4,2)
    xvar = real(log(anData.IWConcentraction(chosenData)));
    yvar = real(log(anData.IWContent(chosenData)));
    
    
    yticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    ytickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    xticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    xtickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    gscatter(xvar, yvar,anData.oWindDirection(chosenData), ...
        anData.plotColorWindDir,'.' ,7,'off')
    hold on
    xfit = logspace(log(min(xvar)), log(max(xvar)),100);
    
    %     foo = LinearModel.fit(xvar',yvar','y~x1');
    %     steigung(2) = table2array(foo.Coefficients(2,1));
    %     [ypred,yci] = predict(foo,xfit');
    %     plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    %plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    %plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    slope = 1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(2,:));
    slope = 2.5;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(3,:));
    slope = -5;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(4,:));
    
    set(gca, 'YLim',[-11 2],...
        'XTickLabel',xtickslabel,'Xtick',xticks,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    
    xlabel('Ice concetration [cm^{-3}]')
    xlim([-7 3])
    ylabel('Ice water content [g m^{-3}]')
    title('southerly wind')
    box on
    
    chosenData = anData.chosenData & anData.IWContent < 4 & anData.IWContent > 0 &...
        isfinite(anData.IWConcentraction) & isfinite(anData.IWContent)& ...
        anData.oWindDirection == 'North wind';
    
    subplot(3,4,3)
    xvar = real(log(anData.IWConcentraction(chosenData)));
    yvar = real(log(anData.IWContent(chosenData)));
    
    
    yticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    ytickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    xticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    xtickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    gscatter(xvar, yvar,anData.oWindDirection(chosenData), ...
        anData.plotColorWindDir,'.' ,7,'off')
    hold on
    slope = 1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(2,:));
    slope = 2.5;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(3,:));
    slope = -5;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(4,:));
    set(gca, 'YLim',[-11 2],...
        'XTickLabel',xtickslabel,'Xtick',xticks,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    xlabel('Ice concetration [cm^{-3}]')
    xlim([-7 3])
    ylabel('Ice water content [g m^{-3}]')
    title('norhterly wind')
    box on
    legend({'data';'slope = 1';'slope = 2.5';'slope = -5'},'location','northeastoutside')
    
    
    chosenData = anData.chosenData & anData.IWContent < 4 & anData.IWContent > 0 &...
        isfinite(anData.IWConcentraction) & isfinite(anData.IWContent);
    subplot(3,4,5)
    
    yvar = real(log(anData.IWMeanD(chosenData)*1e6));
    xvar = real(log(anData.IWConcentraction(chosenData)));
    
    xticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    xtickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    yticks = log([2e1 5e1 1e2 2e2 5e2]);
    ytickslabel = {'2e1';'5e1';'1e2';'2e2';'5e2'};
    gscatter(xvar, yvar,anData.oWindDirection(chosenData), ...
        anData.plotColorWindDir,'.' ,7,'off')
    lsline
    hold on
    slope = -1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(2,:));
    slope = 1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    %plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(3,:));
    slope = -1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    %plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(4,:));
    set(gca, 'YLim',[2.5 6.5],...
        'XTickLabel',xtickslabel,'Xtick',xticks,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    
    xlabel('Ice concetration [cm^{-3}]')
    xlim([-7 3])
    ylabel('Ice crystal diameter [\mum]')
    title('all wind')
    box on
    
    chosenData = anData.chosenData & anData.IWContent < 4 & anData.IWContent > 0 &...
        isfinite(anData.IWConcentraction) & isfinite(anData.IWContent)& ...
        anData.oWindDirection == 'South wind';
    subplot(3,4,6)
    
    yvar = real(log(anData.IWMeanD(chosenData)*1e6));
    xvar = real(log(anData.IWConcentraction(chosenData)));
    
    xticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    xtickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    yticks = log([2e1 5e1 1e2 2e2 5e2]);
    ytickslabel = {'2e1';'5e1';'1e2';'2e2';'5e2'};
    gscatter(xvar, yvar,anData.oWindDirection(chosenData), ...
        anData.plotColorWindDir,'.' ,7,'off')
    lsline
    hold on
    slope = -1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(2,:));
    slope = 1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    %plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(3,:));
    slope = -1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    %plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(4,:));
    set(gca, 'YLim',[2.5 6.5],...
        'XTickLabel',xtickslabel,'Xtick',xticks,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    
    xlabel('Ice concetration [cm^{-3}]')
    xlim([-7 3])
    ylabel('Ice crystal diameter [\mum]')
    title('Southerly wind')
    box on
    
    chosenData = anData.chosenData & anData.IWContent < 4 & anData.IWContent > 0 &...
        isfinite(anData.IWConcentraction) & isfinite(anData.IWContent)& ...
        anData.oWindDirection == 'North wind';
    
    subplot(3,4,7)
    
    yvar = real(log(anData.IWMeanD(chosenData)*1e6));
    xvar = real(log(anData.IWConcentraction(chosenData)));
    
    xticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    xtickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    yticks = log([2e1 5e1 1e2 2e2 5e2]);
    ytickslabel = {'2e1';'5e1';'1e2';'2e2';'5e2'};
    gscatter(xvar, yvar,anData.oWindDirection(chosenData), ...
        anData.plotColorWindDir,'.' ,7,'off')
    lsline
    hold on
    slope = -1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(2,:));
    slope = 1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    %plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(3,:));
    slope = -1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    %plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(4,:));
    set(gca, 'YLim',[2.5 6.5],...
        'XTickLabel',xtickslabel,'Xtick',xticks,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    
    xlabel('Ice concetration [cm^{-3}]')
    xlim([-7 3])
    ylabel('Ice crystal diameter [\mum]')
    title('Northerly wind')
    box on
    
    legend({'data';'fit';'fit';'slope = -1';'slope = 2';'slope = -1'},'location','northeastoutside')
    
    
    chosenData = anData.chosenData & anData.IWContent < 4 & anData.IWContent > 0 &...
        isfinite(anData.IWConcentraction) & isfinite(anData.IWContent);
    subplot(3,4,9)
    xvar = real(log(anData.IWMeanD(chosenData)*1e6));
    yvar = real(log(anData.IWContent(chosenData)));
    yticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    ytickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    xticks = log([2e1 5e1 1e2 2e2 5e2]);
    xtickslabel = {'2e1';'5e1';'1e2';'2e2';'5e2'};
    gscatter(xvar, yvar,anData.oWindDirection(chosenData), ...
        anData.plotColorWindDir,'.' ,7,'off')
    lsline
    hold on
    slope = 3;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(2,:));
    slope = 2;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(3,:));
    slope = -1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    %plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(4,:));
    set(gca, 'YLim',[-11 2],...
        'XTickLabel',xtickslabel,'Xtick',xticks,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    ylabel('Ice water content [g m^{-3}]')
    
    xlim([2.5 6.5])
    xlabel('Ice crystal diameter [\mum]')
    title('all wind')
    box on
    
    
    
    
    chosenData = anData.chosenData & anData.IWContent < 4 & anData.IWContent > 0 &...
        isfinite(anData.IWConcentraction) & isfinite(anData.IWContent)& ...
        anData.oWindDirection == 'South wind';
    subplot(3,4,10)
    xvar = real(log(anData.IWMeanD(chosenData)*1e6));
    yvar = real(log(anData.IWContent(chosenData)));
    yticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    ytickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    xticks = log([2e1 5e1 1e2 2e2 5e2]);
    xtickslabel = {'2e1';'5e1';'1e2';'2e2';'5e2'};
    gscatter(xvar, yvar,anData.oWindDirection(chosenData), ...
        anData.plotColorWindDir,'.' ,7,'off')
    lsline
    hold on
    slope = 3;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(2,:));
    slope = 2;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(3,:));
    slope = -1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    %plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(4,:));
    set(gca, 'YLim',[-11 2],...
        'XTickLabel',xtickslabel,'Xtick',xticks,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    ylabel('Ice water content [g m^{-3}]')
    
    xlim([2.5 6.5])
    xlabel('Ice crystal diameter [\mum]')
    title('Southerly wind')
    box on
    
    
    
    chosenData = anData.chosenData & anData.IWContent < 4 & anData.IWContent > 0 &...
        isfinite(anData.IWConcentraction) & isfinite(anData.IWContent)& ...
        anData.oWindDirection == 'North wind';
    subplot(3,4,11)
    xvar = real(log(anData.IWMeanD(chosenData)*1e6));
    yvar = real(log(anData.IWContent(chosenData)));
    yticks = log([1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1]);
    ytickslabel = {'1e-5';'1e-4';'1e-3';'1e-2';'1e-1';'1e0';'1e1'};
    xticks = log([2e1 5e1 1e2 2e2 5e2]);
    xtickslabel = {'2e1';'5e1';'1e2';'2e2';'5e2'};
    gscatter(xvar, yvar,anData.oWindDirection(chosenData), ...
        anData.plotColorWindDir,'.' ,7,'off')
    lsline
    hold on
    slope = 3;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(2,:));
    slope = 2;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(3,:));
    slope = -1;
    b = mean(yvar-slope*xvar);
    xLin = -100:100;
    %plot(xLin, slope*xLin+b,'Color',anData.plotColorTemp(4,:));
    set(gca, 'YLim',[-11 2],...
        'XTickLabel',xtickslabel,'Xtick',xticks,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    ylabel('Ice water content [g m^{-3}]')
    
    xlim([2.5 6.5])
    xlabel('Ice crystal diameter [\mum]')
    title('Notherly wind')
    box on
    
    legend({'data';'fit';'fit';'slope = 3';'slope = 2';'slope = -1'},'location','northeastoutside')
    
    
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-3 0.1 33 14]);
    set(gcf, 'PaperSize', [24 14.4]);
    
    if anData.savePlots
        fileName = ['YangPaper'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
end

