southWind = anData.meteoWindDir > 90 & anData.meteoWindDir < 270;

figure(2)
xData = anData.measMeanT;
xData(~isfinite(xData)) = nan;
yData = anData.TWConcentraction;
%yData = anData.IWContent./anData.TWContent;
yData(~isfinite(yData)) = 0;
yData(yData < 0) = 0;
xBins = 8;
yBins = 25;
levels = 10;
xEdges=linspace(min(xData),max(xData),xBins);
%yEdges=linspace(min(yData),max(yData),yBins);
yEdges=logspace(log10(min(yData)+0.001),log10(max(yData)),yBins);

clear xInd data counts frequency tmp
for cnt = 1:numel(xEdges)-1
    xInd(cnt,:) = xData > xEdges(cnt) & xData <= xEdges(cnt+1);
    counts(cnt,:) = histc(yData(xInd(cnt,:)), yEdges);
    tmp = sum(counts(cnt,:));
    if tmp == 0
        frequency(cnt,:) = zeros(1,numel(yEdges)); 
    else
        frequency(cnt,:) = counts(cnt,:)./tmp*100;
    end
end
frequency(frequency<0.1) = nan;
%image([xEdges(1) xEdges(end-1)],[yEdges(end) yEdges(1)],frequency');
pcolor(xEdges(1:end-1), yEdges, frequency')
set(gca,'YScale','log');

if 1
figure(1)
subplot(2,3,1)
scatter(anData.measMeanV, anData.meteoWindVel,20,southWind)
xlim([0 18]);
ylim([0 18]);
title('Wind velocity [m s^{-1}]')
xlabel('Sonic');
ylabel('Meteo Swiss');
refline(1,0)

subplot(2,3,2)
scatter(anData.measMeanAzimutSonic, anData.meteoWindDir,20,southWind)
xlim([0 360]);
ylim([0 360]);
title('Wind direction [°]')
xlabel('Sonic');
ylabel('Meteo Swiss');
refline(1,0)

subplot(2,3,3)
scatter(anData.measMeanT, anData.meteoTemperature,20,southWind)
xlim([-27 0]);
ylim([-27 0]);
title('Temperature [°C]')
xlabel('Sonic');
ylabel('Meteo Swiss');
refline(1,0)

subplot(2,3,4)
scatter(anData.TWContent, anData.meteoDewPoint./anData.meteoTemperature,20,southWind)
% xlim([-27 0]);
% ylim([-27 0]);
% title('Temperature [°C]')
xlabel('Sonic TWC');
ylabel('Meteo DewPointRatio');
refline(1,0)

subplot(2,3,5)
scatter(anData.LWContent, anData.meteoRadiation,20,southWind)
% xlim([-27 0]);
% ylim([-27 0]);
% title('Temperature [°C]')
xlabel('Sonic LWC');
ylabel('Meteo Radiation');
refline(1,0)

subplot(2,3,6)
scatter(anData.meteoTemperature, anData.meteoDewPoint,20,southWind)
% xlim([-27 0]);
% ylim([-27 0]);
% title('Temperature [°C]')
xlabel('Meteo Temperautre');
ylabel('Meteo DewPoint');
refline(1,0)
end