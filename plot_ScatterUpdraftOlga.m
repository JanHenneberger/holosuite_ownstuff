function plot_ScatterUpdraftOlga(anData,cntFig)
%UNTITLED20 Summary of this function goes here
%   Detailed explanation goes here
    set(0,'DefaultLineLineWidth',1.1);
    set(0,'DefaultAxesLineWidth',1.1);
%     group = anData.oCloudPhase.*anData.oWindDirection;
%     color = anData.plotColorWindDir;
%     symbol = 'oo++xx';
    group = anData.oWindDirection.*anData.oCloudPhase;
    color = flipud(anData.plotColorWindVel);
    symbol = 'oooxxx';
    size = 3;
    figure(cntFig)

    clf

    anData.chosenData
    s1 = subplot(1,3,1);
    
    g1 = gscatter(anData.meteoTemperature(anData.chosenData), anData.uz(anData.chosenData)...
        ,group(anData.chosenData), ...
        color,symbol ,size,'off');

    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Required vertical velocity [m s^{-1}]')
    set(gca, 'YLim',[0.003 70],'yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    box on
    
    
      
    s2 = subplot(1,3,2);
    
    g2 = gscatter(anData.IWConcentraction(anData.chosenData), anData.uz(anData.chosenData)...
        ,group(anData.chosenData), ...
        color,symbol ,size,'on');
    xlabel('Ice concentration [cm^{-3}]')
    xlim([0.0015 12])
    set(gca, 'xscale','log')
    set(gca, 'YLim',[0.003 70],'yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    set(gca, 'XTickLabel',{'0.001';'0.01';'0.1';'1';},'XTick',[0.001 0.01 0.1 1])
    l = findobj(gcf,'tag','legend'); 
    l.Position(1) = 0.57;
    box on
        
%        s3 = subplot(1,3,3);
%     
%     g3 = gscatter(anData.IWMeanD(anData.chosenData)*1e6, anData.uz(anData.chosenData)...
%         ,group(anData.chosenData), ...
%         color,symbol  ,size,'on');
%     xlabel('Mean Ice diameter [\mum]')
%     xlim([15 300])
%     set(gca, 'xscale','log')
%     set(gca, 'YLim',[0.003 70],'yscale', 'log',...
%         'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
%     set(gca, 'XTickLabel',{'10';'20';'50';'100';'200'},'XTick',[10 20 50 100 200])
%     box on
    
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-3 .2 35 9]);
    set(gcf, 'PaperSize', [25 9]);
    
    if anData.savePlots
        fileName = ['Scatter_UpdraftVelOlga'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
end

