function plot_ScatterUpdraftOlga5(anData,cntFig)
%UNTITLED20 Summary of this function goes here
%   Detailed explanation goes here
    set(0,'DefaultLineLineWidth',0.4);
    set(0,'DefaultAxesLineWidth',1.1);
%     group = anData.oCloudPhase.*anData.oWindDirection;
%     color = anData.plotColorWindDir;
%     symbol = 'oo++xx';
    group = anData.oCloudPhase.*anData.oWindDirection;
    color = anData.plotColorWindDir;
    color = [color; color; color];
    symbol = 'ooxx++';
    figure(cntFig)

    clf

    anData.chosenData
    s1 = subplot(1,4,1);
    
    g1 = gscatter(anData.meteoTemperature(anData.chosenData), anData.glaciationTime(anData.chosenData)...
        ,group(anData.chosenData), ...
        color,symbol ,3,'off');

    xlabel('Temperature [°C]')
    xlim([-30 0])
    ylabel('Glaciation time [s]')
    set(gca, 'YLim',[0.1 10000],'Yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},...
        'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    box on
    
    
      
    s2 = subplot(1,4,2);
    
    g2 = gscatter(anData.IWConcentraction(anData.chosenData), anData.glaciationTime(anData.chosenData)...
        ,group(anData.chosenData), ...
        color,symbol ,3,'off');
    xlabel('Ice concentration [cm^{-3}]')
    xlim([0.0015 12])
    set(gca, 'xscale','log')
    set(gca, 'YLim',[0.1 10000],'Yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},...
        'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
     l = findobj(gcf,'tag','legend'); 
%     l.Position(1) = 0.57;
     set(l,'location','northwest','fontsize',9);
    box on
     
        s2 = subplot(1,4,3);
    
    g2 = gscatter(anData.LWConcentraction(anData.chosenData), anData.glaciationTime(anData.chosenData)...
        ,group(anData.chosenData), ...
        color,symbol ,3,'on');
    xlabel('Liquid concentration [cm^{-3}]')
    xlim([0.1 1000])
    set(gca, 'xscale','log')
    set(gca, 'YLim',[0.1 10000],'Yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},...
        'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
         l = findobj(gcf,'tag','legend'); 
%     l.Position(1) = 0.57;
     set(l,'location','southeast','fontsize',8);
    box on
    
         
    s2 = subplot(1,4,4);
    
    g2 = gscatter(anData.uz(anData.chosenData), anData.glaciationTime(anData.chosenData)...
        ,group(anData.chosenData), ...
        color,symbol ,3,'off');
    xlabel('Required vertical velocity [m s^{-1}]')
    set(gca, 'XLim',[0.001 10],'xscale', 'log',...
        'XTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},...
        'Xtick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    set(gca, 'YLim',[0.1 10000],'Yscale', 'log',...
        'YTickLabel',{'.001';'0.01';'0.1';'1';'10';'100';'1000';'10000'},...
        'Ytick',[0.001 0.01 0.1 1 10 100 1000 10000]);
    box on
    
%        s3 = subplot(1,3,3);
%     
%     g3 = gscatter(anData.IWMeanD(anData.chosenData)*1e6, anData.uz(anData.chosenData)...
%         ,group(anData.chosenData), ...
%         color,symbol  ,3,'on');
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
    set(gcf, 'PaperPosition',[-1 .2 44 9]);
    set(gcf, 'PaperSize', [42 9]);
    
    if anData.savePlots
        fileName = ['Scatter_UpdraftVelOlga5'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
end

