function plot_CloudCasesTemperature(anData,cntFig)
%UNTITLED21 Summary of this function goes here
%   Detailed explanation goes here
    figure(cntFig)
    clf
    
    subplot(3,5,1)
    gscatter(anData.caseStats.TempMean, anData.caseStats.TWMeanDMean*1e6,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Mean diameter all [\mum]')
    set(gca, 'YLim',[5 20],'yscale', 'log',...
        'YTickLabel',{'5';'10';'20'},'Ytick',[5 10 20]);
    box on
    
    subplot(3,5,2)
    gscatter(anData.caseStats.TempMean, anData.caseStats.LWMeanDMean*1e6,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Mean diameter liquid [\mum]')
    set(gca, 'YLim',[5 20],'yscale', 'log',...
        'YTickLabel',{'5';'10';'20'},'Ytick',[5 10 20]);
    box on
    
    subplot(3,5,3)
    gscatter(anData.caseStats.TempMean, anData.caseStats.IWMeanDMean*1e6,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    
    xlabel('Temperature [°C]')
    xlim([-35 0])
    ylabel('Mean diameter ice[\mum]')
    set(gca, 'YLim',[40 200],'yscale', 'log',...
        'YTickLabel',{'20';'50';'100';'200'},'Ytick',[20 50 100 200]);
    
    box on
    
    subplot(3,5,4)
    gscatter(anData.caseStats.TempMean, anData.caseStats.IWMeanDMean./anData.caseStats.LWMeanDMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[])
    l = findobj(gcf,'tag','legend'); 
    l.Position(1) = 0.75;
    %set(l,'location','northeastoutside','fontsize',9);
    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Ice/Liquid diameter')
    set(gca, 'YLim',[2 20],'yscale', 'log',...
        'YTickLabel',{'1';'2';'5';'10';'20'},'Ytick',[1 2 5 10 20]);
    box on
    
    subplot(3,5,6)
    gscatter(anData.caseStats.TempMean, anData.caseStats.TWConcMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Total conc. [cm^{-3}]')
    set(gca, 'YLim',[0.1 1000],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    box on
    
    subplot(3,5,7)
    gscatter(anData.caseStats.TempMean, anData.caseStats.LWConcMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Liquid conc. [cm^{-3}]')
    set(gca, 'YLim',[0.1 1000],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    box on
    
    subplot(3,5,8)
    gscatter(anData.caseStats.TempMean, anData.caseStats.IWConcMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    
    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Ice conc. [cm^{-3}]')
    set(gca, 'YLim',[0.001 10],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    box on
    
    subplot(3,5,9)
    gscatter(anData.caseStats.TempMean, anData.caseStats.IWConcMean./anData.caseStats.TWConcMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Ice/total conc.')
    set(gca, 'YLim',[0.0001 1],'yscale', 'log',...
        'YTickLabel',{'0.0001';'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.0001 0.001 0.01 0.1 1 10 100 1000]);
    box on
    
    subplot(3,5,11)
    gscatter(anData.caseStats.TempMean, anData.caseStats.TWCMean*1000,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Temperature [°C]')
    ylabel('TWC [mg m^{-3}]')
    set(gca, 'YLim',[.3 1000],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    xlim([-30 0])
    box on
    
    subplot(3,5,12)
    gscatter(anData.caseStats.TempMean, anData.caseStats.LWCMean*1000,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Temperature [°C]')
    ylabel('LWC [mg m^{-3}]')
    set(gca, 'YLim',[1 1000],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    xlim([-30 0])
    box on
    
    subplot(3,5,13)
    gscatter(anData.caseStats.TempMean, anData.caseStats.IWCMean*1000,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Temperature [°C]')
    ylabel('IWC [mg m^{-3}]')
    set(gca, 'YLim',[.3 1000],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    xlim([-30 0])
    box on
    
    subplot(3,5,14)
    gscatter(anData.caseStats.TempMean, anData.caseStats.IWCMean./anData.caseStats.TWCMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Temperature [°C]')
    ylabel('IWC/TWC')
    set(gca, 'YLim',[.01 1],'yscale', 'log',...
        'YTickLabel',{'0.001';'0.01';'0.1';'1';'10';'100';'1000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000]);
    xlim([-30 0])
    box on
    
    subplot(3,5,15)
    gscatter(anData.caseStats.TempMean, anData.caseStats.WindVelMean,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Temperature [°C]')
    ylabel('Wind speed [m s^{-1}]')
    set(gca, 'YLim',[0 15])
    xlim([-30 0])
    box on
    
    
    
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-3.3 -.7 34.3 16.3]);
    set(gcf, 'PaperSize', [29 15]);
    
    if anData.savePlots
        fileName = 'CloudCases_Temperature';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end

end

