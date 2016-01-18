function plot_ScatterUpdraft(anData,cntFig)
%UNTITLED20 Summary of this function goes here
%   Detailed explanation goes here

    figure(cntFig)
    clf
    anData.chosenData = anData.chosenData; % & anData.oWindDirection == 'North wind';
    %cat = anData.oCloudPhase(anData.chosenData);
    cat = anData.oWindDirection(anData.chosenData);
    subplot(2,3,1)
    gscatter(anData.meteoTemperature(anData.chosenData), anData.uz(anData.chosenData)...
        ,cat, ...
        anData.plotColorTemp,'.' ,[],'off')
    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Updraft velocity [m s^{-1}]')
    set(gca, 'YLim',[0.001 100],'yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    box on
    
    

    subplot(2,3,2)
    gscatter(anData.IWConcentraction(anData.chosenData), anData.uz(anData.chosenData)...
        ,cat, ...
        anData.plotColorTemp,'.' ,[],'off')
    xlabel('Ice concentration [cm^{-3}]')
    xlim([0.0015 12])
    ylabel('Updraft velocity [m s^{-1}]')
    set(gca, 'xscale','log')
    set(gca, 'YLim',[0.001 100],'yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    set(gca, 'XTickLabel',{'0.001';'0.01';'0.1';'1';},'XTick',[0.001 0.01 0.1 1])
    box on
    
    subplot(2,3,3)
    gscatter(anData.IWMeanMaxD(anData.chosenData)*1e6, anData.uz(anData.chosenData)...
        ,cat, ...
        anData.plotColorTemp,'.' ,[],'off')
    %xlim([0 15])
    xlabel('Ice maximum diameter [\mum]')
    ylabel('Updraft velocity [m s^{-1}]')
    set(gca, 'xscale','log','XLim',[50 300])
    set(gca, 'XTickLabel',{'20';'50';'100';'200';},'XTick',[20 50 100 200])
    set(gca, 'YLim',[0.001 100],'yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    box on
    
        subplot(2,3,4)
        
    gscatter(anData.IWContent(anData.chosenData)./anData.TWContent(anData.chosenData), ...
        anData.uz(anData.chosenData)...
        ,cat, ...
        anData.plotColorTemp,'.' ,[],'off')
    %xlim([0 15])
    xlabel('Ice / Total Water Content')
    ylabel('Updraft velocity [m s^{-1}]')
    set(gca, 'XLim',[0 1])
    set(gca, 'XTickLabel',{'20';'50';'100';'200';},'XTick',[20 50 100 200])
    set(gca, 'YLim',[0.001 100],'yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    box on
    
    subplot(2,3,5)
   gscatter(anData.meteoWindVel(anData.chosenData), anData.uz(anData.chosenData)...
        ,cat, ...
        anData.plotColorTemp,'.' ,[],'off')
    xlabel('Wind speed [m s^{-1}]')
    xlim([0.8 20])
    ylabel('Updraft velocity [m s^{-1}]')
   set(gca, 'YLim',[0.001 100],'yscale', 'log','xscale','log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    box on
    
    
        subplot(2,3,6)
     tmp = (anData.measMeanV.^2-anData.measMeanVAzimut.^2).^(1/2);
    gscatter(tmp(anData.chosenData), ...
        anData.uz(anData.chosenData)...
        ,cat, ...
        anData.plotColorTemp,'.' ,[],'off')
    %xlim([0 15])
    xlabel('Sonic updraft velocity [m s^{-1}]')
    ylabel('Updraft velocity [m s^{-1}]')
    set(gca, 'XLim',[0.4 8])
    %set(gca, 'XTickLabel',{'20';'50';'100';'200';},'XTick',[20 50 100 200])
    set(gca, 'YLim',[0.001 100],'yscale', 'log','xscale','log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    box on
    
    
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-2.1 .2 28 4.9]);
    set(gcf, 'PaperSize', [25 5.2]);
    
    if anData.savePlots
        fileName = ['Scatter_UpdraftVel'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
end

