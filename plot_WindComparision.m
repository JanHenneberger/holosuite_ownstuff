function plot_WindComparision( anData2013All )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    clf
    subplot(1,3,1,'replace')
    markerColor = [1 69/255 0; 0 191/255 1];
    markerStyle = 'oo';
    gscatter(anData2013All.meteoWindDir(goodInt),anData2013All.measMeanAzimutSonic(goodInt) , oWindDirection(goodInt),...
        markerColor, markerStyle)
    hold on
    markerColor = [ 1 165/255 0;0 0 205/255];
    markerStyle = 'ss';
    gscatter(anData2013All.meteoWindDir(goodInt), anData2013All.ManchMetekDirAzimuthMeanMean(goodInt) , oWindDirection(goodInt),...
        markerColor, markerStyle)
    xlim([0 360]);
    ylim([0 360]);
    refline(1,0)
    title('Wind direction Azimut [°]')
    ylabel('Sonic');
    xlabel('Meteo Swiss');
    h=legend('ETH - South wind','ETH - North wind','Manchester - South wind',...
        'Manchester - North wind','Location','NorthWest');
    set(h,'FontSize',8);
    box on
    
    subplot(1,3,2,'replace')
    markerColor = [1 69/255 0; 0 191/255 1];
    markerStyle = 'oo';
    gscatter(anData2013All.meteoWindVel(goodInt),anData2013All.measMeanVAzimut(goodInt) , oWindDirection(goodInt),...
        markerColor, markerStyle)
    hold on
    markerColor = [ 1 165/255 0;0 0 205/255];
    markerStyle = 'ss';
    gscatter(anData2013All.meteoWindVel(goodInt), anData2013All.ManchMetekVAzimuthMean(goodInt) , oWindDirection(goodInt),...
        markerColor, markerStyle)
    xlim([0 22]);
    ylim([0 22]);
    refline(1,0)
    title('horizontal Wind velocity [m s^{-1}]')
    ylabel('Sonic');
    xlabel('Meteo Swiss');
    h=legend('ETH - South wind','ETH - North wind','Manchester - South wind',...
        'Manchester - North wind','Location','NorthWest');
    set(h,'FontSize',8);
    box on
    
    
    subplot(1,3,3,'replace')
    markerColor = [1 69/255 0; 0 191/255 1];
    markerStyle = 'oo';
    gscatter(-anData2013All.ManchMetekDirElevationMeanMean(goodInt),anData2013All.meanElevSonic(goodInt) , oWindDirection(goodInt),...
        markerColor, markerStyle)
    hold on
    
    xlim([-40 5]);
    ylim([-40 5]);
    refline(1,0)
    title('Wind direction Elevation [°]')
    ylabel('Sonic ETH');
    xlabel('Sonic Manchester');
    h=legend('South wind','North wind','Location','NorthWest');
    set(h,'FontSize',8);
    box on
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if savePlots
        fileName = ['Comparision_Wind_New_' num2str(date,'%02u')];        
        print(gcf,'-dpdf','-r600', fullfile(anData2013All.saveDir,fileName));
    end
end

