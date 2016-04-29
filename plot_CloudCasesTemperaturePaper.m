function plot_CloudCasesTemperaturePaper(anData,cntFig)
%UNTITLED24 Summary of this function goes here
%   Detailed explanation goes here
    figure(cntFig)
    clf
    plotColor = anData.plotColorWindDir;
    tmpInt = anData.chosenData & isfinite(anData.TWContent);
    
    subplot(2,4,1)
    xvar = anData.caseStats.TempMean;
    yvar = log(anData.caseStats.TWConcMean);
    
   
    ylimit = log([0.1 1000]);
    yticks = log([0.001 0.01 0.1 1 10 100 1000]);
    ytickslabel = {'0.001';'0.01';'0.1';'1';'10';'100';'1000'};   
    gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
        plotColor,'.' ,[],'off');

    hold on
    xfit = linspace(-30,0);
    foo = LinearModel.fit(xvar',yvar','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    set(gca, 'YLim',ylimit,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    
    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Total conc. [cm^{-3}]')
    box on
    
    subplot(2,4,2)
    xvar = anData.caseStats.TempMean;
    yvar = log(anData.caseStats.LWConcMean);
    
    ylimit = log([0.1 1000]);
    yticks = log([0.001 0.01 0.1 1 10 100 1000]);
    ytickslabel = {'0.001';'0.01';'0.1';'1';'10';'100';'1000'};
    gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
        plotColor,'.' ,[],'off')
    hold on
    xfit = linspace(-30,0);
    foo = LinearModel.fit(xvar',yvar','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    set(gca, 'YLim',ylimit,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    
    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Liquid conc. [cm^{-3}]')
    box on
    
    subplot(2,4,3)
    xvar = anData.caseStats.TempMean;
    yvar = log(anData.caseStats.IWConcMean);
    
    ylimit = log([0.0003 10]);
    yticks = log([0.001 0.01 0.1 1 10 100 1000]);
    ytickslabel = {'0.001';'0.01';'0.1';'1';'10';'100';'1000'};
    gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
        plotColor,'.' ,[],'on')
    hold on
    %IN Data from Yvonne
    plotColorIN = lbmap(5,'BrownBlue');
    scatter([-32 -32 -32 -32], log([1.6 0.47 0.68 4.8]/1000),25,plotColorIN(2,:),'filled')
    text(-30,log(1/1000),'\leftarrow Ice nuclei','Color',plotColorIN(2,:),'FontSize',10 )
    
    xfit = linspace(-35,0);
    foo = LinearModel.fit(xvar',yvar','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    set(gca, 'YLim',ylimit,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    l= findobj(gcf,'tag','legend'); 
    l.Position(1) = 0.67;
    l.FontSize = 9;
    l.String = {'South-East wind cases';'North-west wind cases'};
    %set(l,'location','northeastoutside','fontsize',9);
    l.Position = l.Position + [0.05 0 0 0];
    
    xlabel('Temperature [°C]')
    xlim([-35 0])
    ylabel('Ice conc. [cm^{-3}]')
    box on
    
    subplot(2,4,5)
    xvar = anData.caseStats.TempMean;
    yvar = log(anData.caseStats.TWCMean*1000);
    
    ylimit = log([0.3 1000]);
    yticks = log([0.001 0.01 0.1 1 10 100 1000]);
    ytickslabel = {'0.001';'0.01';'0.1';'1';'10';'100';'1000'};
    gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
        plotColor,'.' ,[],'off')
    hold on
    xfit = linspace(-30,0);
    foo = LinearModel.fit(xvar',yvar','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    set(gca, 'YLim',ylimit,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    
    xlabel('Temperature [°C]')
    ylabel('TWC [mg m^{-3}]')
    xlim([-30 0])
    box on
    
    subplot(2,4,6)
    xvar = anData.caseStats.TempMean;
    yvar = log(anData.caseStats.LWCMean*1000);
    
    ylimit = log([.3 1000]);
    yticks = log([0.001 0.01 0.1 1 10 100 1000]);
    ytickslabel = {'0.001';'0.01';'0.1';'1';'10';'100';'1000'};
    gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
        plotColor,'.' ,[],'off')
    hold on
    xfit = linspace(-30,0);
    foo = LinearModel.fit(xvar',yvar','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    set(gca, 'YLim',ylimit,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    xlabel('Temperature [°C]')
    ylabel('LWC [mg m^{-3}]')
    
    
    xlim([-30 0])
    
    
    box on
    
    subplot(2,4,7)
    xvar = anData.caseStats.TempMean;
    yvar = log(anData.caseStats.IWCMean*1000);
    
    ylimit = log([.3 1000]);
    yticks = log([0.001 0.01 0.1 1 10 100 1000]);
    ytickslabel = {'0.001';'0.01';'0.1';'1';'10';'100';'1000'};
    gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
        plotColor,'.' ,[],'off')
    hold on
    xfit = linspace(-30,0);
    foo = LinearModel.fit(xvar',yvar','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    set(gca, 'YLim',ylimit,...
        'YTickLabel',ytickslabel,'Ytick',yticks);
    xlabel('Temperature [°C]')
    ylabel('IWC [mg m^{-3}]')
    xlim([-30 0])
    box on
    
    subplot(2,4,8)
    xvar = anData.caseStats.TempMean;
    yvar = anData.caseStats.IWCMean./anData.caseStats.TWCMean;
    
    ylimit = [0 1];
    yticks = [0 0.2 0.4 0.6 0.8 1];
    ytickslabel = {'0';'0.2';'0.4';'0.6';'0.8';'1'};
    gscatter(xvar, yvar,anData.caseStats.oWindDirection, ...
        plotColor,'.' ,[],'off')
    hold on
    xfit = linspace(-30,0);
    foo = LinearModel.fit(xvar',yvar','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
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
    set(gcf, 'PaperPosition',[-1.8 0.1 24.4 9.8]);
    set(gcf, 'PaperSize', [22 9.8]);
    
    if anData.savePlots
        fileName = ['CloudCases_Temp_Paper'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end

end

