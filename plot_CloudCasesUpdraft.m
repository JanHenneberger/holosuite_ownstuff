function plot_ScatterUpdraft(anData,cntFig)
%UNTITLED20 Summary of this function goes here
%   Detailed explanation goes here

    figure(cntFig)
    clf
    
    subplot(1,4,1)
    gscatter(anData.caseStats.TempMean, anData.caseStats.updraft,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Updraft velocity [m s^{-1}]')
    set(gca, 'YLim',[0.01 10],'yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    box on
    
    
    subplot(1,4,2)
    gscatter(anData.caseStats.WindVelMean, anData.caseStats.updraft,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    xlim([0 15])
    ylabel('Updraft velocity [m s^{-1}]')
   set(gca, 'YLim',[0.01 10],'yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    box on
    
    subplot(1,4,3)
    gscatter(anData.caseStats.IWConcMean, anData.caseStats.updraft,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    xlabel('Ice concentration [cm^{-3}]')
    xlim([0.0015 12])
    ylabel('Updraft velocity [m s^{-1}]')
    set(gca, 'xscale','log')
    set(gca, 'YLim',[0.01 10],'yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    set(gca, 'XTickLabel',{'0.001';'0.01';'0.1';'1';},'XTick',[0.001 0.01 0.1 1])
    box on
    
    subplot(1,4,4)
    gscatter(anData.caseStats.IWMeanMaxDMean*1e6, anData.caseStats.updraft,anData.caseStats.oWindDirection, ...
        anData.plotColorWindDir,'.' ,[],'off')
    %xlim([0 15])
    xlabel('Ice maximum diameter [\mum]')
    ylabel('Updraft velocity [m s^{-1}]')
    set(gca, 'xscale','log','XLim',[50 300])
    set(gca, 'XTickLabel',{'20';'50';'100';'200';},'XTick',[20 50 100 200])
    set(gca, 'YLim',[0.01 10],'yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    box on
    
    
    
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-2.1 .2 23.6 4.9]);
    set(gcf, 'PaperSize', [20 5.2]);
    
    if anData.savePlots
        fileName = ['CloudCases_UpdraftVel'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
end

