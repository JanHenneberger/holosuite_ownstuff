function plot_ScatterWind(anData , cntFig)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

    figure(cntFig)
    clf
    markerColor = [1 69/255 0; 0 191/255 1;  1 165/255 0;0 0 205/255];
    markerStyle = 'ooss';
    subplot(1,3,1)
    gscatter(anData.measMeanVAzimut, anData.meteoWindVel, times(anData.oWindDirection, anData.oYear),...
        markerColor, markerStyle)
    xlim([0 18]);
    ylim([0 18]);
    title('Wind velocity [m s^{-1}]')
    xlabel('Sonic');
    ylabel('Meteo Swiss');
    refline(1,0)
    box on
    
    subplot(1,3,2)
    gscatter(anData.measMeanAzimutSonic, anData.meteoWindDir,times(anData.oWindDirection, anData.oYear),...
        markerColor, markerStyle)
    xlim([0 360]);
    ylim([0 360]);
    title('Wind direction [°]')
    xlabel('Sonic');
    ylabel('Meteo Swiss');
    box on
    
    subplot(1,3,3)
    gscatter(anData.measMeanT, anData.meteoTemperature,times(anData.oWindDirection, anData.oYear),...
        markerColor, markerStyle)
    xlim([-27 0]);
    ylim([-27 0]);
    title('Temperature [°C]')
    xlabel('Sonic');
    ylabel('Meteo Swiss');
    refline(1,0)
    box on
end

