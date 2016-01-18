savePlots = 1;
saveDir = 'Z:\6_Auswertung\ALL';

date = 100;
plotScatterPlot = 0;
plotScatterPlotPaper = 1;
plotTimeSerie =0;
plotTimeSerie07 = 0;
plotTimeSerie07All = 0;
plotTimeSerieComp = 0;
plotWind = 0;
plotSpectrum = 0;
plotSpectrumRatio = 0;


set(0, 'DefaultFigureWindowStyle', 'docked')
set(0,'DefaultAxesFontSize',13);
set(0,'DefaultAxesLineWidth',1.3);
set(0,'DefaultAxesTickDir','out');

pathMeteoSwiss2013 = 'Z:\6_Auswertung\ALL\MeteoSwissCLACE2013JFJData.dat';

if ~exist('allData','var');
    allData  = load('Z:\6_Auswertung\ALL\Clean_10sec.mat');
    allData = allData.anDataOut;
end

if ~exist('anData20130207','var');
    anData20130207  = load('Z:\6_Auswertung\ALL\CLACE2013-All-Clean-2013-02-07-10sec.mat');
    anData20130207 = anData20130207.anDataOut;
    anData20130207 = anData20130207{1};    
    anData20130207 = includeMeteoSwiss(anData20130207, pathMeteoSwiss2013);
end

if ~exist('anData20130207_100','var');
    anData20130207_100  = load('Z:\6_Auswertung\ALL\CLACE2013-All-Clean-2013-02-07-100sec.mat');
    anData20130207_100 = anData20130207_100.anDataOut;
    anData20130207_100 = anData20130207_100{1};
    anData20130207_100 = includeMeteoSwiss(anData20130207_100, pathMeteoSwiss2013);
end

if ~exist('anData2013','var');
    anData2013  = load('Z:\6_Auswertung\ALL\Clean_100sec.mat');
    anData2013 = anData2013.anDataOut;
    anData2013 = anData2013{1};
    
   
    pathMeteoSwiss2013 = 'Z:\6_Auswertung\ALL\MeteoSwissCLACE2013JFJData.dat';
    anData2013 = includeMeteoSwiss(anData2013, pathMeteoSwiss2013);
end

if ~exist('anData2013New','var');
    anData2013New  = load('Z:\6_Auswertung\ALL\CLACE2013-All-New-100sec.mat');
    anData2013New = anData2013New.anDataOut;
    anData2013New = anData2013New{1};  
end



if date == 29
    datetmp = 1;
elseif date == 4
    datetmp = 2;
elseif date == 5
    datetmp = 3;
elseif date == 6
    datetmp = 4;
elseif date == 7
    datetmp = 5;
elseif date == 11
    datetmp = 6;
elseif date == 12
    datetmp = 7;
elseif date == 99
    datetmp = 99;
elseif date == 100;
    datetmp = 100;
else
    error('unknown date')
end

if datetmp == 99
    anData2013All = anData2013;
elseif datetmp == 100
    anData2013All = anData2013New;
else    
    anData2013All = allData{datetmp};
end

clear datetmp inttmp

pathMeteoSwiss2013 = 'Z:\6_Auswertung\ALL\MeteoSwissCLACE2013JFJData.dat';
anData2013All = includeMeteoSwiss(anData2013All, pathMeteoSwiss2013);

anData2013All.PSIManchCDPMean(anData2013All.PSIManchCDPMean<0)=nan;
anData2013All.PSIManchCDPMean = anData2013All.PSIManchCDPMean/1000;
anData2013All.PSIManchPVMMean(anData2013All.PSIManchPVMMean<0)=nan;
anData2013All.PSIManchPVMMean = anData2013All.PSIManchPVMMean/1000;
anData2013All.PSIPSIPVMMean(anData2013All.PSIPSIPVMMean<0)=nan;
anData2013All.PSIPSIPVMMean = anData2013All.PSIPSIPVMMean/1000;

diff_azimut = difference_azimuth(anData2013All.ManchRotorWingAzimuthMean,anData2013All.ManchRotorWindAzimuthMean);
diff_elevation = anData2013All.ManchRotorWingElevationMean - anData2013All.ManchRotorWindElevationMean;
isAligned = abs(diff_azimut) < 15 & abs(diff_elevation < 30);
isParticles = anData2013All.TWCountRaw > 10;
isMassflow = anData2013All.measMeanFlow > 50;
isLowIce = anData2013All.IWContent < 0.1;
isLowIceRatio = anData2013All.IWContent./anData2013All.TWContent < 0.4;
isLowIceConcRatio = anData2013All.IWConcentraction./anData2013All.TWConcentraction < 0.005;
goodInt = isAligned & isParticles & isMassflow;


%Log Normalization for CDP Concentraction Spectra
CDPEdges = (anData2013All.Parameter.ManchCDPBinSizes(2:end)+anData2013All.Parameter.ManchCDPBinSizes(1:end-1))/2;
CDPEdgesUpper = [CDPEdges 51];
CDPEdgesLower = [2.5 CDPEdges];
CDPEdgeLog = log(CDPEdgesUpper) - log(CDPEdgesLower);
CDPCorrArray = repmat(CDPEdgeLog,size(anData2013All.ManchCDPConcArrayMean,1),1);
anData2013All.ManchCDPConcArrayMeanNorm = anData2013All.ManchCDPConcArrayMean./CDPCorrArray;


CDP2EdgesLower = [4.5 5.5 6.5 8.5 9.5 11.5 13.5 15 17 19 23 25 29 33 37];
CDP2EdgesUpper = [CDP2EdgesLower(2:end) 49];
CDP2Sizes = (CDP2EdgesUpper + CDP2EdgesLower)./2;
CDP2EdgeLog = log(CDP2EdgesUpper) - log(CDP2EdgesLower);
clear CDP2ConcArray;
CDP2ConcArray(:,1) = anData2013All.ManchCDPConcArrayMean(:,3);
CDP2ConcArray(:,2) = anData2013All.ManchCDPConcArrayMean(:,4);
CDP2ConcArray(:,3) = nansum(anData2013All.ManchCDPConcArrayMean(:,5:6),2);
CDP2ConcArray(:,4) = anData2013All.ManchCDPConcArrayMean(:,7);
CDP2ConcArray(:,5) = nansum(anData2013All.ManchCDPConcArrayMean(:,8:9),2);
CDP2ConcArray(:,6) = nansum(anData2013All.ManchCDPConcArrayMean(:,10:11),2);
CDP2ConcArray(:,7) = anData2013All.ManchCDPConcArrayMean(:,12);
CDP2ConcArray(:,8) = anData2013All.ManchCDPConcArrayMean(:,13);
CDP2ConcArray(:,9) = anData2013All.ManchCDPConcArrayMean(:,14);
CDP2ConcArray(:,10) = nansum(anData2013All.ManchCDPConcArrayMean(:,15:16),2);
CDP2ConcArray(:,11) = anData2013All.ManchCDPConcArrayMean(:,17);
CDP2ConcArray(:,12) = nansum(anData2013All.ManchCDPConcArrayMean(:,18:19),2);
CDP2ConcArray(:,13) = nansum(anData2013All.ManchCDPConcArrayMean(:,20:21),2);
CDP2ConcArray(:,14) = nansum(anData2013All.ManchCDPConcArrayMean(:,22:23),2);
CDP2ConcArray(:,15) = nansum(anData2013All.ManchCDPConcArrayMean(:,24:29),2);
CDP2CorrArray = repmat(CDP2EdgeLog,size(CDP2ConcArray,1),1);
anData2013All.ManchCDP2ConcArrayMeanNorm = CDP2ConcArray./CDP2CorrArray;

%Grouping Manchester
isSouth= anData2013All.meteoWindDir > 45 & anData2013All.meteoWindDir < 225;
oWindDirection = ordinal(isSouth,{'South wind','North wind'},[1,0]);


%% Scatter plot wind measurements comparision
if plotWind
    figure(17)
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
        print(gcf,'-dpdf','-r600', fullfile(saveDir,fileName));
    end
    
    
end

if plotSpectrumRatio
    figure(16)
    clf
    hold on
    plotColor =flipud(lbmap(2,'RedBlue'));
    plotDataXEdges = anData2013All.Parameter.histBinBorder(3:16);
    plotDataX1 = anData2013All.Parameter.histBinMiddle(3:16);
    plotDataY1 = anData2013All.water.histRealCor(3:16,goodInt) + anData2013All.ice.histRealCor(3:16,goodInt);
    plotDataY1(~isfinite(plotDataY1)) = nan;
    plotDataY1 = nanmean(plotDataY1,2);
  
    plotDataX2 = CDP2Sizes(2:end);
    plotDataY2 = nanmean(anData2013All.ManchCDP2ConcArrayMeanNorm(goodInt,:));
    plotDataY2 = plotDataY2(:,2:end);
    
    subplot(1,3,1)
    stairs(plotDataX1,plotDataY1, ...
        'LineWidth',2,'Color','k');
    hold on
    stairs(plotDataX2,plotDataY2', ...
        'LineWidth',2,'LineStyle','--','Color','k');
        ylabel('Number density d(N)/d(log d) [cm^{-3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    xlim(gca, [5 55]);
    ylim(gca,[0.5 5e3])
    set(gca,'XTick',[2 5 10 20 50 100 200])
    legend('HOLIMO','CDP')
    
    subplot(1,3,2)
    plot(plotDataX1, plotDataY1./plotDataY2');
    set(gca,'XScale','log');
    xlabel('Diameter [\mum]')
    ylabel('Concentration ratio HOLIMO/CDP')
    xlim(gca, [5 55]);
    set(gca,'XTick',[2 5 10 20 50 100 200])
    box on
    
    subplot(1,3,3)
    plot(plotDataX1, plotDataY1-plotDataY2');
    set(gca,'XScale','log');
    xlabel('Diameter [\mum]')
    ylabel('Concentration difference HOLIMO - CDP')
      xlim(gca, [5 55]);
    set(gca,'XTick',[2 5 10 20 50 100 200])
    box on
    
    
    set(gcf, 'PaperUnits','centimeters');

    set(gcf, 'PaperPosition',[0 0 22 10]);
    set(gcf, 'PaperSize', [21 9.6]);
    
    if savePlots
        fileName = ['Comparision_Spectrum_Ratio_New2_' num2str(date,'%02u')];        
        print(gcf,'-dpdf','-r600', fullfile(saveDir,fileName));
    end
end 

% Spectrum
if plotSpectrum
    figure(15)
    clf      
    hold on
    plotColor =flipud(lbmap(2,'RedBlue'));
    
    plotData = anData2013All.water.histRealCor(:,goodInt);
    plotData(~isfinite(plotData)) = nan;
    plotData = nanmean(plotData,2);
    p1 = stairs(anData2013All.Parameter.histBinBorder(3:end-1), ...
        plotData(3:end), ...
        'LineWidth',2,'Color','k');
    
    plotData = anData2013All.ice.histRealCor(:,goodInt);
    plotData(~isfinite(plotData)) = nan;
    plotData = nanmean(plotData,2);
    p2 = stairs(anData2013All.Parameter.histBinBorder(3:end-1), ...
        plotData(3:end), ...
        'LineWidth',2,'LineStyle','--','Color','k');
    
    %
    %     plotData = nanmean(anData2013AllAll.ManchCDPConcArrayMean);
    %     p2 = stair( anData2013AllAll.Parameter.ManchCDPBinSizes, ...
    %        plotData, ...
    %         'LineWidth',2,'Color','b');
    
    plotData = nanmean(anData2013All.ManchCDPConcArrayMeanNorm(goodInt,:));
    p2 = stairs(CDPEdgesLower, ...
        plotData, ...
        'LineWidth',2,'Color',plotColor(1,:));
    

    h_legend = legend({'HOLIMO Liquid', 'HOLIMO Ice', 'CDP'}, 'Location', 'NorthEast');
    set(h_legend,'FontSize',11);
    ylabel('Number density d(N)/d(log d) [cm^{-3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');

    xlim(gca, [3 250]);
    ylim(gca, [5e-2 5e3]);
    set(gca,'XTick',[2 5 10 20 50 100 200])
    set(gca,'YTick',[1e-2 1e-1 1e0 1e1 1e2 1e3])
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    box on    
    
    set(gcf, 'PaperUnits','centimeters');

    set(gcf, 'PaperPosition',[0 0 13 10]);
    set(gcf, 'PaperSize', [12.2 9.6]);
    
    if savePlots
        fileName = ['Comparision_Spectrum_New_' num2str(date,'%02u')];        
        print(gcf,'-dpdf','-r600', fullfile(saveDir,fileName));
    end
    
end


%% Comparision Time Serie
if plotTimeSerieComp
    figure(4)
    clf
    plotXLim = [min(anData2013All.timeStart) max(anData2013All.timeStart)];
    
    h1 = subplot(3,1,1);
    plotdataX = [anData2013All.cdpMean;  anData2013All.PSIManchCDPMean; anData2013All.pvmMean; ...
        anData2013All.PSIManchPVMMean; anData2013All.PSIPSIPVMMean]';
    plotdataX = plotdataX(goodInt,:);
    plot(anData2013All.timeStart(goodInt), plotdataX);
    xlabel('Time (UTC)');
    legend({'Man CDP raw'; 'Man CDP'; 'Man PVM raw'; 'Man PVM'; 'PSI PVM'});
    set(gca,'XLim',plotXLim);
    datetick(gca,'x','HH:MM','keeplimits');
    
    
    
    h2 = subplot(3,1,2);
    plotdataX = [anData2013All.TWContent;  anData2013All.TWContent2; anData2013All.TWContentRaw; ...
        anData2013All.TWContentRaw2]';
    plotdataX = plotdataX(goodInt,:);
    plot(anData2013All.timeStart(goodInt), plotdataX);
    xlabel('Time (UTC)');
    legend({'TWC'; 'TWC >50um'; 'TWC raw'; 'TWC raw <50um'});
    set(gca,'XLim',plotXLim);
    datetick(gca,'x','HH:MM','keeplimits');
    
    
    
    h3 = subplot(3,1,3);
    plotdataX = [anData2013All.TWContent; anData2013All.TWContent2; anData2013All.PSIManchCDPMean; anData2013All.PSIManchPVMMean; anData2013All.PSIPSIPVMMean]';
    plotdataX = plotdataX(goodInt,:);
    plot(anData2013All.timeStart(goodInt), plotdataX);
    xlabel('Time (UTC)');
    legend({'TWC'; 'TWC >50um'; 'Man CDP'; 'Man PVM'; 'PSI PVM'});
    set(gca,'XLim',plotXLim);
    datetick(gca,'x','HH:MM','keeplimits');
    
    
    linkaxes([h1 h2 h3])
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if savePlots
        fileName = ['Comparision_TimeSerie_New_' num2str(date,'%02u') '_Intercomparision'];        
        print(gcf,'-dpdf','-r600', fullfile(saveDir,fileName));
    end
    
end


%% Comparsion old Manchester / HOLIMO (only good Intervalss)
if plotScatterPlot
    
    figure(2)
    clf
    %goodInt = goodInt & isSouth;
   
    
    subplot(2,2,1)
    hold on
    
    x=anData2013All.cdpMean(goodInt);
    y=anData2013All.TWContent2(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    
    plotLimit = 1.05*max(max(x),max(y));
    scatter(x, y);
    
    p=polyfit(x,y,1);
    xfit = linspace(0,plotLimit);
    plot(xfit,p(1).*xfit+p(2));
    plot(xfit,xfit,'k-');
    R=corrcoef(x,y);
    
    str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
    str1(1) = {['R-value: ' num2str(R(1,2),'%4.2g')]};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, 1.2]);
    ylim([0, 0.3]);
    xlabel('CDP');
    ylabel('HOLIMO II (6-50 um)');
    title('Total Water Content [g m^{-3}]')
    box on
    
    subplot(2,2,2)
    hold on
    x=anData2013All.pvmMean(goodInt);
    y=anData2013All.TWContent2(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 1.05*max(max(x),max(y));
    scatter(x, y);
    
    p=polyfit(x,y,1);
    xfit = linspace(0,plotLimit);
    plot(xfit,p(1).*xfit+p(2));
    plot(xfit,xfit,'k-');
    R=corrcoef(x,y);
    
    str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
    str1(1) = {['R-value: ' num2str(R(1,2),'%4.2g')]};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, .6]);
    ylim([0, .3]);
    xlabel('PVM');
    ylabel('HOLIMO II (6-50 um)');
    title('Total Water Content [g m^{-3}]')
    box on
    
    subplot(2,2,3)
    hold on
    x=anData2013All.ManchCDPConcArrayMean(goodInt,:);
    x=x(:,4:end);
    x=sum(x,2);
    x=x';
    y=anData2013All.TWConcentraction2(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 1.05*max(max(x),max(y));
    scatter(x, y);
    
    p=polyfit(x,y,1);
    xfit = linspace(0,plotLimit);
    plot(xfit,p(1).*xfit+p(2));
    plot(xfit,xfit,'k-');
    R=corrcoef(x,y);
    
    str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
    str1(1) = {['R-value: ' num2str(R(1,2),'%4.2g')]};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, 2000]);
    ylim([0, 500]);
    xlabel('CDP (6-50 um)');
    ylabel('HOLIMO II (6-50 um)');
    title('Number Concentration [cm^{-3}]')
    box on
    
    subplot(2,2,4)
    hold on
    
    x=anData2013All.cdpMean(goodInt);
    y=anData2013All.pvmMean(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    
    plotLimit = 1.05*max(max(x),max(y));
    scatter(x, y );
    
    p=polyfit(x,y,1);
    xfit = linspace(0,plotLimit);
    plot(xfit,p(1).*xfit+p(2));
    plot(xfit,xfit,'k-');
    R=corrcoef(x,y);
    
    str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
    str1(1) = {['R-value: ' num2str(R(1,2),'%4.2g')]};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, 1.2]);
    ylim([0, .6]);
    xlabel('CDP');
    ylabel('PVM');
    title('Total Water Content [g m^{-3}]')
    box on
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if savePlots
        fileName = ['Comparision_Scatter_Free_New2_' num2str(date,'%02u')];        
        print(gcf,'-dpdf','-r600', fullfile(saveDir,fileName));
    end
    
end
%Comparsion old Manchester / HOLIMO (only good Intervalss)
%Through origin
if plotScatterPlot
    
    figure(111)
    clf
    set(gcf,'DefaultLineLineWidth',1.4)
     plotColor = flipud(lbmap(2,'RedBlue'));
    
    subplot(2,2,1)
    hold on
    
    xmax = 1.2;
    ymax = 1.2;
    xPoints = linspace(1,xmax,100);
    x=anData2013.cdpMean(goodInt);
    y=anData2013.TWContent2(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    
    plotLimit = 1.05*max(max(x),max(y));
   
    xfit = linspace(0,plotLimit);
           
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,6,plotColor(1,:),'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');  
    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP');
    ylabel('HOLIMO II (6-50 \mum)');
    title('Total Water Content [g m^{-3}]')
    box on
    
   subplot(2,2,2)
    hold on
    
    xmax = 1.2;
    ymax = 1.2;
    xPoints = linspace(1,xmax,100);
    x=anData2013.cdpMean(goodInt);
    y=anData2013.pvmMean(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    
    plotLimit = 1.05*max(max(x),max(y));
   
    xfit = linspace(0,plotLimit);
           
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,6,plotColor(1,:),'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');  
    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP');
    ylabel('PVM');
    title('Total Water Content [g m^{-3}]')
    box on
    
    subplot(2,2,3)
    hold on
    
    xmax = .6;
    ymax = .6;
    xPoints = linspace(1,xmax,100);
    x=anData2013.pvmMean(goodInt);
    y=anData2013.TWContent(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
        xfit = linspace(0,plotLimit);
       
    foo = LinearModel.fit(x',y','y~-1+x1');
   
    scatter(x,y,6,plotColor(1,:),'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');      
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('PVM');
    ylabel('HOLIMO II');
    title('Total Water Content [g m^{-3}]')
    box on
    
    
    subplot(2,2,4)
    hold on
    
      xmax = .6;
      ymax = .6;
    x=anData2013.pvmMean(goodInt)-0.0919;
    y=anData2013.TWContent(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 1.05*max(max(x),max(y));
    
    
   
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,6,plotColor(1,:),'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');   
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('PVM - Base Line Subraction');
    ylabel('HOLIMO II');
    title('Total Water Content [g m^{-3}]')
    box on
    
    

    

    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-.7 -.7 20.5 20]);
    set(gcf, 'PaperSize', [18.7 18.7]);
    
    if savePlots
        fileName = ['Comparision_Scatter_Origin2_New_' num2str(date,'%02u')];        
        print(gcf,'-dpdf','-r600', fullfile(saveDir,fileName));
    end
    
      
end

%Comparsion old Manchester / HOLIMO (only good Intervalss)
%Through origin
if plotScatterPlotPaper
    figure(1)
    clf
    
    set(gcf,'DefaultLineLineWidth',1.4)
    plotColor = flipud(lbmap(2,'RedBlue'));
    
    subplot(2,4,1)
    hold on
    
    xmax = 750;
    ymax = 750;
    xPoints = linspace(1,xmax,100);
    x=anData2013All.ManchCDPConcArrayMean(goodInt,:);
    x=x(:,4:end);
    x=sum(x,2);
    x=x';
    y=anData2013All.TWConcentraction2(goodInt);
    color = anData2013All.ManchCDPMVDMean(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    plotLimit = 1.05*max(max(x),max(y));
    
    
    m = y/x;
        xfit = linspace(0,plotLimit);
       
    foo = LinearModel.fit(x',y','y~-1+x1');
    yhat = predict(foo,x');
    
    scatter(x,y,6,color,'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP (6-50 um)');
    ylabel('HOLIMO II (6-50 um)');
    title('Number Concentration [cm^{-3}]')
    box on
    
     subplot(2,4,2)
    hold on
    
    xmax = 750;
    ymax = 750;
    xPoints = linspace(1,xmax,100);
    x=anData2013All.ManchCDPConcArrayMean(goodInt,:);
    x=x(:,4:end);
    x=sum(x,2);
    x=x';
    y=anData2013All.TWConcentraction2(goodInt);
    color = anData2013All.TWMeanD(goodInt)*1e6;
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    plotLimit = 1.05*max(max(x),max(y));
    
    
    m = y/x;
        xfit = linspace(0,plotLimit);
       
    foo = LinearModel.fit(x',y','y~-1+x1');
    yhat = predict(foo,x');
    
    scatter(x,y,6,color,'x')
    colorbar('Location','North')
    caxis([5 25])
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP (6-50 um)');
    ylabel('HOLIMO II (6-50 um)');
    title('Number Concentration [cm^{-3}]')
    box on
 
    
    subplot(2,4,3)
    hold on
    
    xmax = 1.2;
    ymax = 1.2;
    xPoints = linspace(1,xmax,100);
    x=anData2013All.cdpMean(goodInt);
    y=anData2013All.TWContent(goodInt);
    color = anData2013All.ManchCDPMVDMean(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    
    plotLimit = 1.05*max(max(x),max(y));
   
    xfit = linspace(0,plotLimit);
           
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,6,color,'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');  
    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP');
    ylabel('HOLIMO II');
    title('Total Water Content [g m^{-3}]')
    box on
    
    
    subplot(2,4,4)
    hold on
    
    xmax = 1.2;
    ymax = 1.2;
    xPoints = linspace(1,xmax,100);
   
    tmp = repmat(1/6*pi.*(anData2013All.Parameter.ManchCDPBinSizes*1e-3).^3,...
        size(anData2013All.ManchCDPConcArrayMean,1),1);    
    tmp2 = tmp.*anData2013All.ManchCDPConcArrayMean*1e3;
    
    x=nansum(tmp2(:,4:end),2)';
    x = x(goodInt);
    y= anData2013All.TWContent2(goodInt);
    color = anData2013All.ManchCDPMVDMean(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    
    plotLimit = 1.05*max(max(x),max(y));
   
    xfit = linspace(0,plotLimit);
           
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,6,color,'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');  
    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP (6 - 50 \mum)');
    ylabel('HOLIMO II (6 - 50 \mum)');
    title('Total Water Content [g m^{-3}]')
    box on
        
    subplot(2,4,5)
    hold on
    
    xmax = .6;
    ymax = .6;
    xPoints = linspace(1,xmax,100);
    x=anData2013All.pvmMean(goodInt);
    y=anData2013All.TWContent(goodInt);
    color = anData2013All.ManchCDPMVDMean(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
        xfit = linspace(0,plotLimit);
       
    foo = LinearModel.fit(x',y','y~-1+x1');
   
    scatter(x,y,6,color,'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');      
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('PVM');
    ylabel('HOLIMO II');
    title('Total Water Content [g m^{-3}]')
    box on
    
    
    subplot(2,4,6)
    hold on
    
      xmax = .6;
      ymax = .6;
    x=anData2013All.pvmMean(goodInt)-0.0919;
    y=anData2013All.TWContent(goodInt);
    color = anData2013All.ManchCDPMVDMean(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    plotLimit = 1.05*max(max(x),max(y));
    
    
   
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,6,color,'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');   
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('PVM - Base Line Subtraction');
    ylabel('HOLIMO II');
    title('Total Water Content [g m^{-3}]')
    box on
    
    

    subplot(2,4,7)
    hold on
    
    xmax = 1.2;
    ymax = 1.2;
    xPoints = linspace(1,xmax,100);
    x=anData2013All.cdpMean(goodInt);
    y=anData2013All.pvmMean(goodInt)-0.0919;
    color = anData2013All.ManchCDPMVDMean(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    
    
    plotLimit = 1.05*max(max(x),max(y));
   
    xfit = linspace(0,plotLimit);
           
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,6,color,'x')
    colorbar('Location','North')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');  
    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP');
    ylabel('PVM - Base Line Subtraction');
    title('Total Water Content [g m^{-3}]')
    box on


    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-.7 -.7 39 20]);
    set(gcf, 'PaperSize', [37 18.7]);
    
    if savePlots
        fileName = ['Comparision_Scatter_Origin_All_New_' num2str(date,'%02u')];        
        print(gcf,'-dpdf','-r600', fullfile(saveDir,fileName));
    end
    
      
end

%% colorplot for Manchester
if plotScatterPlotPaper
    figure(11)
    clf
    
    set(gcf,'DefaultLineLineWidth',1.4)
     plotColor = flipud(lbmap(2,'RedBlue'));
     
    
    hold on
    
    xmax = 1.2;
    ymax = 1.2;
    xPoints = linspace(1,xmax,100);
    x=anData2013All.cdpMean(goodInt);
    y=anData2013All.pvmMean(goodInt)-0.0919;
    color = anData2013All.ManchCDPMVDMean(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    
    
    plotLimit = 1.05*max(max(x),max(y));
   
    xfit = linspace(0,plotLimit);
           
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,60,color,'.')
    colorbar('Location','EastOutside')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');  
    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP');
    ylabel('PVM - Base Line Subtraction');
    title('Total Water Content [g m^{-3}]')
    box on


    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 12 12]);
    set(gcf, 'PaperSize', [12 12]);
    
    if savePlots
        fileName = ['Comparision_Scatter_Sizes' num2str(date,'%02u')];        
        print(gcf,'-dpdf','-r600', fullfile(saveDir,fileName));
    end
    
      
    end

    
%% time serie
if plotTimeSerie
    figure(18)
    clf
    
    plotInt = goodInt;    
    startTime = anData2013All.timeStart(goodInt);
    startTime = startTime(1);
    endTime = anData2013All.timeStart(goodInt);
    endTime = endTime(end);
    
    clear s;
    
    set(gcf,'DefaultLineLineWidth',2);
    axnumber = 4;
    for m=1:axnumber
        axleft = 0.09;
        axright = 0.10;
        axtop = 0;
        axbottom = 0.07;
        axgap = 0.01;
        axwidth = 1-axleft-axright;
        axheight = (1-axbottom-axtop)./axnumber-axgap*(axnumber-1);
        axPos(m,:) = [axleft axbottom+(m-1)*(axheight+axgap) axwidth axheight];
    end
    
    meanNum = 10;
    markerSize=60;
    scLineWidht = 1;
    plotXLim = [startTime endTime];
    
    s(4)=axes('position',axPos(1,:));
    [ax,h1,h2]= plotyy(anData2013.timeStart, nanmoving_average(anData2013.IWContent./anData2013.TWContent,meanNum),...
        anData2013.timeStart, nanmoving_average(anData2013.IWConcentraction./anData2013.TWConcentraction,meanNum));
    hold(ax(1),'on')
    hold(ax(2),'on')
    scatter(ax(1),anData2013All.timeStart, anData2013All.IWContent./anData2013All.TWContent, ...
        markerSize,'bx','lineWidth',scLineWidht);
    %    plot(ax(1), BTplotData.timeUTC, BTplotData.LWC,'b--');
    %    plot(ax(2), BTplotData.timeUTC, BTplotData.IWC,'--','Color',[0 0.5 0]);
    scatter(ax(2),anData2013All.timeStart, anData2013All.IWConcentraction./anData2013All.TWConcentraction,...
        markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    set(get(ax(1),'Ylabel'),'String',{'IWC/TWC'},'fontsize',18,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Ice/Total', 'Conc.'},'fontsize',18,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(ax(1),'XLim',plotXLim, 'YLim',[0 1.1],'YTick',[0 0.5 1]);
    %'YLim',[0 3],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    set(ax(2),'XLim',plotXLim,'XTickLabel',[], 'YLim',[0 0.22],'YTick',[0 0.1 .2]);
    %,'YLim',[0 0.8],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    
    xlabel('Time (UTC) [h]');
    datetick(ax(1),'x','HH-MM','keeplimits');
    datetick(ax(2),'x','HH-MM','keeplimits');
    plotXTick = get(ax(1),'XTick');
    
    
    s(3)=axes('position',axPos(2,:));
    [ax,h1,h2]= plotyy(anData2013.timeStart, nanmoving_average(anData2013.LWContent,meanNum),...
        anData2013.timeStart, nanmoving_average(anData2013.IWContent,meanNum));
    hold(ax(1),'on')
    hold(ax(2),'on')
    scatter(ax(1),anData2013All.timeStart, anData2013All.LWContent, ...
        markerSize,'bx','lineWidth',scLineWidht);
    %    plot(ax(1), BTplotData.timeUTC, BTplotData.LWC,'b--');
    %    plot(ax(2), BTplotData.timeUTC, BTplotData.IWC,'--','Color',[0 0.5 0]);
    scatter(ax(2),anData2013All.timeStart, anData2013All.IWContent, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    set(get(ax(1),'Ylabel'),'String',{'Water Content', 'Liquid [g*m^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Water Content', 'Ice [g*m^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %'YLim',[0 3],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %,'YLim',[0 0.8],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);   

    
    s(2)=axes('position',axPos(3,:));
    [ax, h1, h2]= plotyy(anData2013.timeStart, nanmoving_average(anData2013.LWConcentraction,meanNum),...
        anData2013.timeStart, nanmoving_average(anData2013.IWConcentraction*1000,meanNum));
    hold(ax(1),'on')
    hold(ax(2),'on')
    scatter(ax(1),anData2013All.timeStart, anData2013All.LWConcentraction,markerSize,'bx','lineWidth',scLineWidht);
    scatter(ax(2),anData2013All.timeStart, anData2013All.IWConcentraction*1000,markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    set(get(ax(1),'Ylabel'),'String',{'Number Concentration', 'Liquid [cm^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Number Concentration', 'Ice [l^{-1}]'},'fontsize',18,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %'YLim',[0 100],'YTick',[0 200 400 600 800 1000 1200 1400 1600 1800 2000 2200]);
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %'YLim',[0 600],'YTick',[0 200 400 600 800 1000 1200 1400 1600 1800 2000 2200]);
    
    s(1)=axes('position',axPos(4,:));
    plot(anData2013.timeStart, anData2013.TWContent,'k');
    hold on
    plot(anData2013.timeStart, anData2013.cdpMean,'b');
    plot(anData2013.timeStart, anData2013.pvmMean,'Color',[0 0.5 0]);
    legend('HOLIMO','CDP','PVM');
    %     [ax,h1,h2]= plotyy(anData2013All.timeStart, nanmoving_average(rem(anData2013All.measMeanAzimutSonic+180,360), meanNum),...
    %         anData2013All.timeStart, nanmoving_average(anData2013All.measMeanT, meanNum));
    %     hold(ax(1),'on')
    %     hold(ax(2),'on')
    %     scatter(ax(1),anData2013All.timeStart, rem(anData2013All.measMeanAzimutSonic+180,360),markerSize,'bx','lineWidth',scLineWidht);
    %     scatter(ax(2),anData2013All.timeStart, anData2013All.measMeanT, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    
    %    plot(ax(1), BTplotData.timeUTC, BTplotData.winddirection,'b--');
    %    plot(ax(2), BTplotData.timeUTC, BTplotData.temp,'--','Color',[0 0.5 0]);
    %set(get(ax(1),'Ylabel'),'String',{'Wind Direction', 'Azimut [°]'},'fontsize',18,'lineWidth',scLineWidht,'Color','b');
    %set(get(ax(2),'Ylabel'),'String',{'Air Temperature', '[°C]'},'fontsize',18,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(get(gca,'Ylabel'),'String',{'Water Content', 'Total [g*m^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color','k');
    set(gca,'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %    'YLim',[0 360],'YTick',[0 90 180 270 360]);
    %     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %     %    'YLim',[-10 -6],'YTick',[-10 -9 -8 -7 -6]);
    
    set(gca,'XTickLabel',[]);
    %     set(ax(2),'XTickLabel',[]);
    
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 30 20]);
    set(gcf, 'PaperSize', [30 20]);
%     if anParameter.savePlots
%         fileName = [anParameter.ParInfoFiles{1}(1:19) '-TimeSerie'];
%         fileFolder = fullfile(anParameter.ParInfoFolder, 'Plots');
%         print('-dpdf','-r600', fullfile(fileFolder,fileName));
%     end
    
        set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if savePlots
        fileName = ['Comparision_TimeSerie_New_' num2str(date,'%02u') '_HOLIMO'];        
        print(gcf,'-dpdf','-r600', fullfile(saveDir,fileName));
    end
    
end

%% time serie 07
if plotTimeSerie07
    figure(20)
    clf
    
    
    plotColor =flipud(lbmap(2,'RedBlue'));
    plotInt =ones(1,numel(anData20130207.intTimeStart)); 
    goodInt = plotInt;
%     startTime = anData20130207.intTimeStart(goodInt);
%     startTime = startTime(1);
%     endTime = anData20130207.intTimeStart(goodInt);
%     endTime = endTime(end);
    startTime = anData20130207.intTimeStart(find(isfinite(anData20130207.timeStart),1,'first'));
    %endTime = anData20130207.intTimeStart(find(isfinite(anData20130207.timeStart),1,'last'));
    endTime = datenum([2013 02 07 19 0 0]);
    clear s;
    set(gcf,'DefaultLineLineWidth',2);
    axnumber = 5;
    for m=1:axnumber
        axleft = 0.12;
        axright = 0.10;
        axtop = -.07;
        axbottom = 0.07;
        axgap = 0.01;
        axwidth = 1-axleft-axright;
        axheight = (1-axbottom-axtop)./axnumber-axgap*(axnumber-1);
        axPos(m,:) = [axleft axbottom+(m-1)*(axheight+axgap) axwidth axheight];
    end
    
    meanNum = 1;
    markerSize=60;
    scLineWidht = 1;
    plotXLim = [startTime endTime];
    
    s(5)=axes('position',axPos(1,:));
    [ax,h1,h2]= plotyy(anData20130207.intTimeStart, nanmoving_average(anData20130207.IWContent./anData20130207.TWContent,meanNum),...
    anData20130207.intTimeStart, nanmoving_average(anData20130207.IWConcentraction./anData20130207.TWConcentraction,meanNum));
    set(h1,'LineWidth',1, 'Color',plotColor(1,:))  
    set(h2,'LineWidth',1, 'Color',plotColor(2,:))
     set(ax(1),'XLim',plotXLim ,'YLim',[0 1.1],'YTick',[0 0.25 0.5 0.75 1],'ycolor', plotColor(1,:));
    %'YLim',[0 3],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    set(ax(2),'XLim',plotXLim, 'YLim',[0 0.22],'YTick',[0 0.05 0.10 .15 0.20],'ycolor', plotColor(2,:));
    %,'YLim',[0 0.8],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    hold(ax(1),'on')
    hold(ax(2),'on')
    [ax1,h11,h22]= plotyy(anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.IWContent./anData20130207_100.TWContent,meanNum),...
        anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.IWConcentraction./anData20130207_100.TWConcentraction,meanNum));
    set(h11,'LineStyle','--', 'Color',plotColor(1,:));
    set(h22,'LineStyle','--', 'Color',plotColor(2,:));
    xlabel('Time (UTC) [h]');
    set(ax1(1),'XLim',plotXLim ,'XTick',[],'XTickLabel',[],'YLim',[0 1.1],'YTick',[0 0.25 0.5 0.75 1],'ycolor', plotColor(1,:));
    %'YLim',[0 3],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    set(ax1(2),'XLim',plotXLim, 'XTick',[],'XTickLabel',[],'YLim',[0 0.22],'YTick',[0 0.05 0.10 .15 0.20],'ycolor', plotColor(2,:));
    %,'YLim',[0 0.8],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);  

    
    datetick(ax(1),'x','HH-MM','keeplimits');
    datetick(ax(2),'x','HH-MM','keeplimits');
    plotXTick = get(ax(1),'XTick');
    
    
    %scatter(ax(1),anData2013All.timeStart, anData2013All.IWContent./anData2013All.TWContent, ...
    %    markerSize,'bx','lineWidth',scLineWidht);
    %scatter(ax(2),anData2013All.timeStart, anData2013All.IWConcentraction./anData2013All.TWConcentraction,...
    %    markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    set(get(ax(1),'Ylabel'),'String',{'IWC/TWC'},'fontsize',13,'lineWidth',scLineWidht, 'Color',plotColor(1,:));
    set(get(ax(2),'Ylabel'),'String',{'Ice/Total', 'Conc.'},'fontsize',13,'lineWidth',scLineWidht,'Color', plotColor(2,:));

    

    
    
    s(4)=axes('position',axPos(2,:));
    [ax,h1,h2]= plotyy(anData20130207.intTimeStart, nanmoving_average(anData20130207.LWContent,meanNum),...
        anData20130207.intTimeStart, nanmoving_average(anData20130207.IWContent,meanNum));
    set(h1,'LineWidth',1, 'Color',plotColor(1,:))  
    set(h2,'LineWidth',1, 'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 1.1],'YTick',[0  0.2  0.4 0.6 0.8 1], 'ycolor',plotColor(1,:));
     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 1.1],'YTick',[0  0.2  0.4 0.6 0.8 1], 'ycolor',plotColor(2,:));  
    hold(ax(1),'on')
    hold(ax(2),'on')
    [ax,h11,h22]= plotyy(anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.LWContent,meanNum),...
        anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.IWContent,meanNum));
    set(h11,'LineStyle','--', 'Color',plotColor(1,:));
    set(h22,'LineStyle','--', 'Color',plotColor(2,:));
    %scatter(ax(1),anData2013All.timeStart, anData2013All.LWContent, ...
    %    markerSize,'bx','lineWidth',scLineWidht);

    %scatter(ax(2),anData2013All.timeStart, anData2013All.IWContent, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    set(get(ax(1),'Ylabel'),'String',{'Water Content', 'Liquid [g*m^{-3}]'},'fontsize',13,'lineWidth',scLineWidht);
    set(get(ax(2),'Ylabel'),'String',{'Water Content', 'Ice [g*m^{-3}]'},'fontsize',13,'lineWidth',scLineWidht);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 1.1],'YTick',[0  0.2  0.4 0.6 0.8 1], 'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 1.1],'YTick',[0 0.2 0.4  0.6 0.8 1], 'ycolor',plotColor(2,:));   

    
    s(3)=axes('position',axPos(3,:));
    [ax, h1, h2]= plotyy(anData20130207.intTimeStart, nanmoving_average(anData20130207.LWConcentraction,meanNum),...
        anData20130207.intTimeStart, nanmoving_average(anData20130207.IWConcentraction,meanNum));
    set(h1,'LineWidth',1,'Color',plotColor(1,:))  
    set(h2,'LineWidth',1,'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 250],'YTick',[0 50 100 150 200],'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 5],'YTick',[0 1 2 3 4],'ycolor',plotColor(2,:));
    hold(ax(1),'on')
    hold(ax(2),'on')
    [ax, h11, h22]= plotyy(anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.LWConcentraction,meanNum),...
        anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.IWConcentraction,meanNum));
    set(h11,'LineStyle','--', 'Color',plotColor(1,:));
    set(h22,'LineStyle','--', 'Color',plotColor(2,:));

    set(get(ax(1),'Ylabel'),'String',{'Number Concentration', 'Liquid [cm^{-3}]'},'fontsize',13,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Number Concentration', 'Ice [cm^{-3}]'},'fontsize',13,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 250],'YTick',[0 50 100 150 200],'ycolor',plotColor(1,:));
     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 5],'YTick',[0 1000 2000 3000 4000],'ycolor',plotColor(2,:));
    
      s(2)=axes('position',axPos(4,:));
    [ax, h1, h2]= plotyy(anData20130207.intTimeStart, anData20130207.measMeanT,...
        anData20130207.intTimeStart, anData20130207.measMeanV);
    set(h1,'LineWidth',1,'Color',plotColor(1,:))  
    set(h2,'LineWidth',1,'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[-24 -21.75],'YTick',[-24 -23.5 -23 -22.5 -22],'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 9],'YTick',[0 2 4 6 8],'ycolor',plotColor(2,:));
    hold(ax(1),'on')
    hold(ax(2),'on')
    
    [ax, h11, h22]= plotyy(anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.measMeanT,meanNum),...
        anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.measMeanV,meanNum));
    set(h11,'LineStyle','--', 'Color',plotColor(1,:));
    set(h22,'LineStyle','--', 'Color',plotColor(2,:));
    
    set(get(ax(1),'Ylabel'),'String',{'Temperature', '[°C]'},'fontsize',13,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Horz. Wind', 'Velocity [m s^{-1}]'},'fontsize',13,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[-24 -21.75],'YTick',[-24 -23.5 -23 -22.5 -22],'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 9],'YTick',[0 2 4 6 8],'ycolor',plotColor(2,:));
    
     
    
    plotColor = lbmap(4,'BrownBlue');
    s(1)=axes('position',axPos(5,:));
    hold on
    plot(anData20130207.intTimeStart, anData20130207.cdpMean,'r','LineWidth',1, 'Color',plotColor(2,:));
    plot(anData20130207.intTimeStart, anData20130207.pvmMean-0.0919,'c','LineWidth',1, 'Color',plotColor(1,:));
    
    plot(anData20130207.intTimeStart, anData20130207.TWContent,'k','LineWidth',1);
    plot(anData20130207_100.intTimeStart, anData20130207_100.TWContent,'k--');
    legend('CDP','PVM','HOLIMO');
    %     [ax,h1,h2]= plotyy(anData2013All.timeStart, nanmoving_average(rem(anData2013All.measMeanAzimutSonic+180,360), meanNum),...
    %         anData2013All.timeStart, nanmoving_average(anData2013All.measMeanT, meanNum));
    %     hold(ax(1),'on')
    %     hold(ax(2),'on')
    %     scatter(ax(1),anData2013All.timeStart, rem(anData2013All.measMeanAzimutSonic+180,360),markerSize,'bx','lineWidth',scLineWidht);
    %     scatter(ax(2),anData2013All.timeStart, anData2013All.measMeanT, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    
    %    plot(ax(1), BTplotData.timeUTC, BTplotData.winddirection,'b--');
    %    plot(ax(2), BTplotData.timeUTC, BTplotData.temp,'--','Color',[0 0.5 0]);
    %set(get(ax(1),'Ylabel'),'String',{'Wind Direction', 'Azimut [°]'},'fontsize',15,'lineWidth',scLineWidht,'Color','b');
    %set(get(ax(2),'Ylabel'),'String',{'Air Temperature', '[°C]'},'fontsize',15,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(get(gca,'Ylabel'),'String',{'Water Content', 'Total [g*m^{-3}]'},'fontsize',13,'lineWidth',scLineWidht,'Color','k');
    set(gca,'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %    'YLim',[0 360],'YTick',[0 90 180 270 360]);
    %     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %     %    'YLim',[-10 -6],'YTick',[-10 -9 -8 -7 -6]);
    
    set(gca,'XTickLabel',[]);
    box(s(1))
  
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-.15 -.15 31 23]);
    set(gcf, 'PaperSize', [31 21.5]);
    
    if savePlots
        fileName = ['Comparision_TimeSerie3_New_' num2str(date,'%02u') '_HOLIMO'];        
        print(gcf,'-dpdf','-r600', fullfile(saveDir,fileName));
    end
end

if plotTimeSerie07All
    figure(205)
    clf
    
    
    plotColor =flipud(lbmap(2,'RedBlue'));
    plotInt =ones(1,numel(anData20130207.intTimeStart)); 
    goodInt = plotInt;
%     startTime = anData20130207.intTimeStart(goodInt);
%     startTime = startTime(1);
%     endTime = anData20130207.intTimeStart(goodInt);
%     endTime = endTime(end);
    startTime = anData20130207.intTimeStart(find(isfinite(anData20130207.timeStart),1,'first'));
    %endTime = anData20130207.intTimeStart(find(isfinite(anData20130207.timeStart),1,'last'));
    endTime = datenum([2013 02 07 19 0 0]);
    clear s;
    set(gcf,'DefaultLineLineWidth',1.7);
    axnumber = 7;
    for m=1:axnumber
        axleft = 0.11;
        axright = 0.09;
        axtop = -0.33;
        axbottom = 0.09;
        axgap = 0.01;
        axwidth = 1-axleft-axright;
        axheight = (1-axbottom-axtop)./axnumber-axgap*(axnumber-1);
        axPos(m,:) = [axleft axbottom+(m-1)*(axheight+axgap) axwidth axheight];
    end
    
    meanNum = 1;
    markerSize=60;
    scLineWidht = 1;
    plotXLim = [startTime endTime];
    
    s(7)=axes('position',axPos(1,:));
    [ax,h1,h2]= plotyy(anData20130207.intTimeStart, nanmoving_average(anData20130207.IWContent./anData20130207.TWContent,meanNum),...
    anData20130207.intTimeStart, nanmoving_average(anData20130207.IWConcentraction./anData20130207.TWConcentraction,meanNum));
    set(h1,'LineWidth',1, 'Color',plotColor(1,:))  
    set(h2,'LineWidth',1, 'Color',plotColor(2,:))
     set(ax(1),'XLim',plotXLim ,'YLim',[0 1.1],'YTick',[0 0.25 0.5 0.75 1],'ycolor', plotColor(1,:));
    %'YLim',[0 3],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    set(ax(2),'XLim',plotXLim, 'YLim',[0 0.22],'YTick',[0 0.05 0.10 .15 0.20],'ycolor', plotColor(2,:));
    %,'YLim',[0 0.8],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    hold(ax(1),'on')
    hold(ax(2),'on')
    [ax1,h11,h22]= plotyy(anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.IWContent./anData20130207_100.TWContent,meanNum),...
        anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.IWConcentraction./anData20130207_100.TWConcentraction,meanNum));
    set(h11,'LineStyle','--', 'Color',plotColor(1,:));
    set(h22,'LineStyle','--', 'Color',plotColor(2,:));
    xlabel('Time (UTC) [h]');
    set(ax1(1),'XLim',plotXLim ,'XTick',[],'XTickLabel',[],'YLim',[0 1.1],'YTick',[0 0.25 0.5 0.75 1],'ycolor', plotColor(1,:));
    %'YLim',[0 3],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    set(ax1(2),'XLim',plotXLim, 'XTick',[],'XTickLabel',[],'YLim',[0 0.22],'YTick',[0 0.05 0.10 .15 0.20],'ycolor', plotColor(2,:));
    %,'YLim',[0 0.8],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);  

    
    datetick(ax(1),'x','HH-MM','keeplimits');
    datetick(ax(2),'x','HH-MM','keeplimits');
    plotXTick = get(ax(1),'XTick');
    
    
    %scatter(ax(1),anData2013All.timeStart, anData2013All.IWContent./anData2013All.TWContent, ...
    %    markerSize,'bx','lineWidth',scLineWidht);
    %scatter(ax(2),anData2013All.timeStart, anData2013All.IWConcentraction./anData2013All.TWConcentraction,...
    %    markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    set(get(ax(1),'Ylabel'),'String',{'IWC/TWC'},'fontsize',11,'lineWidth',scLineWidht, 'Color',plotColor(1,:));
    set(get(ax(2),'Ylabel'),'String',{'Ice/Total', 'Conc.'},'fontsize',11,'lineWidth',scLineWidht,'Color', plotColor(2,:));

    

    
    
    s(6)=axes('position',axPos(2,:));
    [ax,h1,h2]= plotyy(anData20130207.intTimeStart, nanmoving_average(anData20130207.LWContent,meanNum),...
        anData20130207.intTimeStart, nanmoving_average(anData20130207.IWContent,meanNum));
    set(h1,'LineWidth',1, 'Color',plotColor(1,:))  
    set(h2,'LineWidth',1, 'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 1.1],'YTick',[0  0.2  0.4 0.6 0.8 1], 'ycolor',plotColor(1,:));
     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 1.1],'YTick',[0  0.2  0.4 0.6 0.8 1], 'ycolor',plotColor(2,:));  
    hold(ax(1),'on')
    hold(ax(2),'on')
    [ax,h11,h22]= plotyy(anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.LWContent,meanNum),...
        anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.IWContent,meanNum));
    set(h11,'LineStyle','--', 'Color',plotColor(1,:));
    set(h22,'LineStyle','--', 'Color',plotColor(2,:));
    %scatter(ax(1),anData2013All.timeStart, anData2013All.LWContent, ...
    %    markerSize,'bx','lineWidth',scLineWidht);

    %scatter(ax(2),anData2013All.timeStart, anData2013All.IWContent, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    set(get(ax(1),'Ylabel'),'String',{'Water Content', 'Liquid [g*m^{-3}]'},'fontsize',11,'lineWidth',scLineWidht);
    set(get(ax(2),'Ylabel'),'String',{'Water Content', 'Ice [g*m^{-3}]'},'fontsize',11,'lineWidth',scLineWidht);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 1.1],'YTick',[0  0.2  0.4 0.6 0.8 1], 'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 1.1],'YTick',[0 0.2 0.4  0.6 0.8 1], 'ycolor',plotColor(2,:));   

  
      s(5)=axes('position',axPos(3,:));
    [ax, h1, h2]= plotyy(anData20130207.intTimeStart, nanmoving_average(anData20130207.LWMeanD*1e6,meanNum),...
        anData20130207.intTimeStart, nanmoving_average(anData20130207.IWMeanD*1e6,meanNum));
    set(h1,'LineWidth',1,'Color',plotColor(1,:))  
    set(h2,'LineWidth',1,'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[5 30],'YTick',[5 10 15 20 25],'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 100],'YTick',[0 20 40 60 80],'ycolor',plotColor(2,:));
    hold(ax(1),'on')
    hold(ax(2),'on')
    [ax, h11, h22]= plotyy(anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.LWMeanD*1e6,meanNum),...
        anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.IWMeanD*1e6,meanNum));
    set(h11,'LineStyle','--', 'Color',plotColor(1,:));
    set(h22,'LineStyle','--', 'Color',plotColor(2,:));

    set(get(ax(1),'Ylabel'),'String',{'Diameter', 'Liquid [cm^{-3}]'},'fontsize',11,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Diameter', 'Ice [cm^{-3}]'},'fontsize',11,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[5 30],'YTick',[5 10 15 20 25],'ycolor',plotColor(1,:));10
     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 100],'YTick',[0 20 40 60 80],'ycolor',plotColor(2,:));
      
     
    s(4)=axes('position',axPos(4,:));
    [ax, h1, h2]= plotyy(anData20130207.intTimeStart, nanmoving_average(anData20130207.LWConcentraction,meanNum),...
        anData20130207.intTimeStart, nanmoving_average(anData20130207.IWConcentraction,meanNum));
    set(h1,'LineWidth',1,'Color',plotColor(1,:))  
    set(h2,'LineWidth',1,'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 150],'YTick',[0 50 100],'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 6],'YTick',[0 2 4 ],'ycolor',plotColor(2,:));
    hold(ax(1),'on')
    hold(ax(2),'on')
    [ax, h11, h22]= plotyy(anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.LWConcentraction,meanNum),...
        anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.IWConcentraction,meanNum));
    set(h11,'LineStyle','--', 'Color',plotColor(1,:));
    set(h22,'LineStyle','--', 'Color',plotColor(2,:));

    set(get(ax(1),'Ylabel'),'String',{'Number Concentration', 'Liquid [cm^{-3}]'},'fontsize',11,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Number Concentration', 'Ice [cm^{-3}]'},'fontsize',11,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 150],'YTick',[0 50 100],'ycolor',plotColor(1,:));
     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 6],'YTick',[0 2 4],'ycolor',plotColor(2,:));
      
     %34
      s(3)=axes('position',axPos(5,:));
    [ax, h1, h2]= plotyy(anData20130207.intTimeStart, anData20130207.meteoTemperature,...
        anData20130207.intTimeStart, anData20130207.meteoWindVel);
    set(h1,'Color',plotColor(1,:))  
    set(h2,'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[-25.75 -23.25],'YTick',[-25.5 -25 -24.5 -24 -23.5],'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[-1.5 13.5],'YTick',[0 3 6 9 12],'ycolor',plotColor(2,:));
    hold(ax(1),'on')
    hold(ax(2),'on')
    
%     [ax, h11, h22]= plotyy(anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.meteoTemperature,meanNum),...
%         anData20130207_100.intTimeStart, nanmoving_average(anData20130207_100.meteoWindVel,meanNum));
%     set(h11,'LineStyle','--', 'Color',plotColor(1,:));
%     set(h22,'LineStyle','--', 'Color',plotColor(2,:));
%     
     set(get(ax(1),'Ylabel'),'String',{'Temp. Meteo', '[°C]'},'fontsize',11,'lineWidth',scLineWidht,'Color',plotColor(1,:));
     set(get(ax(2),'Ylabel'),'String',{'Horz. Wind Vel.', 'Meteo [m s^{-1}]'},'fontsize',11,'lineWidth',scLineWidht,'Color',plotColor(2,:));
%      set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[-26 -22],'YTick',[-27 -26 -25 -24 -23 -22],'ycolor',plotColor(1,:));
%     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 14],'YTick',[0 2 4 6 8 10 12 14],'ycolor',plotColor(2,:));
    
    
    
     s(2)=axes('position',axPos(6,:));
    [ax, h1, h2]= plotyy(anData20130207_100.intTimeStart, anData20130207_100.measMeanT,...
        anData20130207_100.intTimeStart, anData20130207_100.measMeanV);
    set(h1,'Color',plotColor(1,:))  
    set(h2,'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[-24 -21.75],'YTick',[-24 -23.5 -23 -22.5 -22],'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 9],'YTick',[0 2 4 6 8],'ycolor',plotColor(2,:));
    hold(ax(1),'on')
    hold(ax(2),'on')
    
    [ax, h11, h22]= plotyy(anData20130207_100.intTimeStart, anData20130207_100.measMeanT,...
        anData20130207_100.intTimeStart, -sind(anData20130207_100.meanElevSonic).*anData20130207_100.measMeanV);
    set(h11,'LineStyle','-', 'Color',plotColor(1,:));
    set(h22,'LineStyle','--', 'Color',plotColor(2,:));
    
    set(get(ax(1),'Ylabel'),'String',{'Temp. Sonic', '[°C]'},'fontsize',11,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Velocity Sonic', '[m s^{-1}]'},'fontsize',11,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[-24 -21.75],'YTick',[-24 -23.5 -23 -22.5 -22],'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 9],'YTick',[0 2 4 6 8],'ycolor',plotColor(2,:));
    
     
    
    plotColor = lbmap(4,'BrownBlue');
    s(1)=axes('position',axPos(7,:));
    hold on
    plot(anData20130207.intTimeStart, anData20130207.cdpMean,'r','LineWidth',1, 'Color',plotColor(2,:));
    plot(anData20130207.intTimeStart, anData20130207.pvmMean-0.0919,'c','LineWidth',1, 'Color',plotColor(1,:));
    
    plot(anData20130207.intTimeStart, anData20130207.TWContent,'k','LineWidth',1);
    plot(anData20130207_100.intTimeStart, anData20130207_100.TWContent,'k--');
    legend('CDP','PVM','HOLIMO');
    %     [ax,h1,h2]= plotyy(anData2013All.timeStart, nanmoving_average(rem(anData2013All.measMeanAzimutSonic+180,360), meanNum),...
    %         anData2013All.timeStart, nanmoving_average(anData2013All.measMeanT, meanNum));
    %     hold(ax(1),'on')
    %     hold(ax(2),'on')
    %     scatter(ax(1),anData2013All.timeStart, rem(anData2013All.measMeanAzimutSonic+180,360),markerSize,'bx','lineWidth',scLineWidht);
    %     scatter(ax(2),anData2013All.timeStart, anData2013All.measMeanT, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    
    %    plot(ax(1), BTplotData.timeUTC, BTplotData.winddirection,'b--');
    %    plot(ax(2), BTplotData.timeUTC, BTplotData.temp,'--','Color',[0 0.5 0]);
    %set(get(ax(1),'Ylabel'),'String',{'Wind Direction', 'Azimut [°]'},'fontsize',15,'lineWidth',scLineWidht,'Color','b');
    %set(get(ax(2),'Ylabel'),'String',{'Air Temperature', '[°C]'},'fontsize',15,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(get(gca,'Ylabel'),'String',{'Water Content', 'Total [g*m^{-3}]'},'fontsize',11,'lineWidth',scLineWidht,'Color','k');
    set(gca,'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %    'YLim',[0 360],'YTick',[0 90 180 270 360]);
    %     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %     %    'YLim',[-10 -6],'YTick',[-10 -9 -8 -7 -6]);
    
    set(gca,'XTickLabel',[]);
    box(s(1))
  
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 31 24.5]);
    set(gcf, 'PaperSize', [31 24.5]);
    
    if savePlots
        fileName = ['Comparision_TimeSerieAll_New_' num2str(date,'%02u') '_HOLIMO'];        
        print(gcf,'-dpdf','-r600', fullfile(saveDir,fileName));
    end
end