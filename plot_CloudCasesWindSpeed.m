function plot_CloudCasesWindSpeed(anData,cntFig)
%UNTITLED22 Summary of this function goes here
%   Detailed explanation goes here

    figure(cntFig)
    clf
    
    %     scatter(anData.timeStart, anData.TWContent)
    %     xlim([datenum([2012 04 6 19 0 0]) datenum([2012 04 7 14 0 0])]);
    %     datetick(gca,'x','HH-MM','keeplimits');
    
    subplot(3,5,1)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.TWMeanDMean*1e6,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 14])
    ylabel('Mean diameter all [\mum]')
    set(gca, 'YLim',[5 18],'yscale', 'log',...
        'YTickLabel',{'5';'10';'20'},'Ytick',[5 10 20]);
    box on    
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',anData.caseStats.TWMeanDMean*1e6','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])   
    
    subplot(3,5,2)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.LWMeanDMean*1e6,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 14])
    ylabel('Mean diameter liquid [\mum]')
    set(gca, 'YLim',[5 20],'yscale', 'log',...
        'YTickLabel',{'5';'10';'20'},'Ytick',[5 10 20]);
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',anData.caseStats.LWMeanDMean*1e6','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    subplot(3,5,3)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.IWMeanDMean*1e6,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 14])
    ylabel('Mean diameter ice[\mum]')
    set(gca, 'YLim',[40 200],'yscale', 'log',...
        'YTickLabel',{'20';'50';'100';'200'},'Ytick',[20 50 100 200]);
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',anData.caseStats.IWMeanDMean*1e6','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    subplot(3,5,4)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.IWMeanMaxDMean*1e6,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 14])
    ylabel('Max diameter ice[\mum]')
    set(gca, 'YLim',[40 200],'yscale', 'log',...
        'YTickLabel',{'20';'50';'100';'200'},'Ytick',[20 50 100 200]);
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',anData.caseStats.IWMeanMaxDMean*1e6','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    subplot(3,5,5)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.IWMeanDMean./anData.caseStats.TWMeanDMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 14])
    ylabel('Ice/Total  diameter [\mum]')
    set(gca, 'YLim',[2 20],'yscale', 'log',...
        'YTickLabel',{'1';'2';'5';'10';'20'},'Ytick',[1 2 5 10 20]);
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',(anData.caseStats.IWMeanDMean./anData.caseStats.TWMeanDMean)','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    
    subplot(3,5,6)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.TWConcMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 14])
    ylabel('Total conc. [cm^{-3}]')
    set(gca, 'YLim',[0.1 1000],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',anData.caseStats.TWConcMean','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    subplot(3,5,7)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.LWConcMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 14])
    ylabel('Liquid conc. [cm^{-3}]')
    set(gca, 'YLim',[0.1 1000],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',anData.caseStats.LWConcMean','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    subplot(3,5,8)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.IWConcMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 14])
    ylabel('Ice conc. [cm^{-3}]')
    set(gca, 'YLim',[0.001 10],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',anData.caseStats.IWConcMean','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    subplot(3,5,9)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.IWConcMean./anData.caseStats.TWConcMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[])
    l= findobj(gcf,'tag','legend'); %set(l,'location','northeastoutside','fontsize',9);
    l.Position(1) = 0.75;
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 14])
    ylabel('Ice/total conc.')
    set(gca, 'YLim',[0.0001 1],'yscale', 'log',...
        'YTickLabel',{'0.0001';'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.0001 0.001 0.01 0.1 1 10 100 1000]);
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',(anData.caseStats.IWConcMean./anData.caseStats.TWConcMean)','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    
    subplot(3,5,11)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.TWCMean*1000,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    ylabel('TWC [g m^{-3}]')
    set(gca, 'YLim',[.3 1000],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    xlim([0 14])
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',anData.caseStats.TWCMean*1000','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    subplot(3,5,12)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.LWCMean*1000,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    ylabel('LWC [g m^{-3}]')
    set(gca, 'YLim',[.3 1000],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    xlim([0 14])
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',anData.caseStats.LWCMean*1000','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    subplot(3,5,13)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.IWCMean*1000,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    ylabel('IWC [g m^{-3}]')
    set(gca, 'YLim',[.3 1000],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    xlim([0 14])
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',anData.caseStats.IWCMean*1000','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    subplot(3,5,14)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.IWCMean./anData.caseStats.TWCMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    ylabel('IWC/TWC')
    set(gca, 'YLim',[.01 1],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    xlim([0 14])
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',(anData.caseStats.IWCMean./anData.caseStats.TWCMean)','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    subplot(3,5,15)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.TempMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    ylabel('Temperature [°C]')
    set(gca, 'YLim',[-30 0])
    xlim([0 14])
    box on
    hold on
    plotLimit = 30;
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(anData.caseStats.WindVelMean',anData.caseStats.TempMean','y~x1');
    [ypred,yci] = predict(foo,xfit');
    plot(xfit,ypred,'Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,1),'--','Color',[0.7 0.7 0.7])
    plot(xfit,yci(:,2),'--','Color',[0.7 0.7 0.7])
    
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-3.3 -.7 34.3 16.3]);
    set(gcf, 'PaperSize', [29 15]);
    if anData.savePlots
        fileName = 'CloudCases_WindSpeed';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end   
end

