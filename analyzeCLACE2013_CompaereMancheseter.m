if ~exist('anData2013','var');
    tmp  = load('Z:\6_Auswertung\ALL\Clean_100sec.mat');
    tmp = tmp.anDataOut;
    anData2013 = tmp{2};
    
    pathMeteoSwiss2013 = 'Z:\6_Auswertung\MeteoSwissCLACE2013JFJData.MeteoSwissCLACE2013JFJData.dat';
    anData2013 = includeMeteoSwiss(anData2013, pathMeteoSwiss2013);
    
    anData2013.PSIManchCDPMean(anData2013.PSIManchCDPMean<0)=nan;
    anData2013.PSIManchCDPMean = anData2013.PSIManchCDPMean/1000;
    anData2013.PSIManchPVMMean(anData2013.PSIManchPVMMean<0)=nan;
    anData2013.PSIManchPVMMean = anData2013.PSIManchPVMMean/1000;
    anData2013.PSIPSIPVMMean(anData2013.PSIPSIPVMMean<0)=nan;
    anData2013.PSIPSIPVMMean = anData2013.PSIPSIPVMMean/1000;
    %anData2013.ManchMetekDirAzimuthMean = anData2013.ManchMetekDirAzimuthMean*10;
    anData2013.pvmMean = anData2013.pvmMean-0.12;
    %     anData2013.ManchRotorWingAzimuthMean2=mod(anData2013.ManchRotorWingAzimuthMean-28,360);
    %     anData2013.ManchRotorWindAzimuthMean2=mod(anData2013.ManchRotorWindAzimuthMean-28,360);
    %     anData2013.measMeanAzimutSonic2 = mod(anData2013.measMeanAzimutSonic-41,360);
end

diff_azimut = difference_azimuth(anData2013.ManchRotorWingAzimuthMean,anData2013.ManchRotorWindAzimuthMean);
diff_elevation = anData2013.ManchRotorWingElevationMean - anData2013.ManchRotorWindElevationMean;
isAligned = abs(diff_azimut) < 15 & abs(diff_elevation < 30);
isParticles = anData2013.TWCountRaw > 20;
isMassflow = anData2013.measMeanFlow > 50;
%isLowIce = anData2013.IWContent < 0.02;
goodInt = isAligned & isParticles & isMassflow;


%Log Normalization for CDP Concentraction Spectra
CDPEdges = (anData2013.Parameter.ManchCDPBinSizes(2:end)+anData2013.Parameter.ManchCDPBinSizes(1:end-1))/2;
CDPEdgesUpper = [CDPEdges 51];
CDPEdgesLower = [2.5 CDPEdges];
CDPEdgeLog = log(CDPEdgesUpper) - log(CDPEdgesLower);
CDPCorrArray = repmat(CDPEdgeLog,size(anData2013.ManchCDPConcArrayMean,1),1);
anData2013.ManchCDPConcArrayMeanNorm = anData2013.ManchCDPConcArrayMean./CDPCorrArray;

%Grouping Manchester
isSouth= anData2013.meteoWindDir > 90 & anData2013.meteoWindDir < 270;
oWindDirection = ordinal(isSouth,{'South wind','North wind'},[1,0]);


%Group by day
Y = anData2013.timeVecStart(3,:)+100*anData2013.timeVecStart(2,:);
oDay=ordinal(Y,{'1/29';'2/04';'2/05';'2/06';'2/07';'2/08';'2/11';'2/12';'2/14'});


if 1
    figure(19)
    clear gcf
    oGoodComp = mergelevels(oDay, {'1/29';'2/04';'2/05';'2/06'}, 'No');
    oGoodComp = mergelevels(oGoodComp, {'2/07';'2/08';'2/11';'2/12';'2/14'}, 'Yes');
    
    set(gcf,'DefaultAxesFontSize',12);
    set(gcf,'DefaultAxesLineWidth',1);
    
    if ~isfield(anData2013,'sampleVolumeReal')
        anData2013.sampleVolumeReal = 0.00008;
    end
    
    subplot(1,4,1)
    plotInd = anData2013.TWContent>=0 & ~isinf(anData2013.TWContent);
    anData2013.TWContent(anData2013.TWContent==0)=1e-7;
    h=boxplot(anData2013.TWContent(plotInd) , oGoodComp(plotInd),'symbol','r+','outliersize',4,'labelorientation','inline');
    hold on
    meanValues = grpstats(anData2013.TWContent(plotInd), oGoodComp(plotInd),'nanmean');
    scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
    set(h(7,:),'Visible','off')
    set(gca,'YScale','log')
    set(gca,'YLim',[1/mean(anData2013.sampleVolumeReal)*6/pi*nanmean(anData2013.TWMeanD)^3*1e6 1e0])
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    ylabel('TWC [g m^{-3}]')
    set(gca,'TickLength',[0.03 0.06],'TickDir','out');
    
    subplot(1,4,2)
    plotInd = anData2013.TWContent2>=0 & ~isinf(anData2013.TWContent2);
    anData2013.TWContent2(anData2013.TWContent2==0)=1e-7;
    h=boxplot(anData2013.TWContent2(plotInd) , oGoodComp(plotInd),'symbol','r+','outliersize',4,'labelorientation','inline');
    hold on
    meanValues = grpstats(anData2013.TWContent2(plotInd), oGoodComp(plotInd),'nanmean');
    scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
    set(h(7,:),'Visible','off')
    set(gca,'YScale','log')
    set(gca,'YLim',[1/mean(anData2013.sampleVolumeReal)*6/pi*nanmean(anData2013.TWMeanD)^3*1e6 1e0])
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    ylabel('TWC [g m^{-3}] (0-50 \mum)')
    set(gca,'TickLength',[0.03 0.06],'TickDir','out');
    
    subplot(1,4,3)
    plotInd = anData2013.cdpMean>=0 & ~isinf(anData2013.cdpMean);
    anData2013.cdpMean(anData2013.cdpMean==0)=1e-7;
    h=boxplot(anData2013.cdpMean(plotInd) , oGoodComp(plotInd),'symbol','r+','outliersize',4,'labelorientation','inline');
    hold on
    meanValues = grpstats(anData2013.cdpMean(plotInd), oGoodComp(plotInd),'nanmean');
    scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
    set(h(7,:),'Visible','off')
    set(gca,'YScale','log')
    set(gca,'YLim',[1/mean(anData2013.sampleVolumeReal)*6/pi*nanmean(anData2013.TWMeanD)^3*1e6 1e0])
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    ylabel('CDP TWC [g m^{-3}]')
    set(gca,'TickLength',[0.03 0.06],'TickDir','out');
    
    subplot(1,4,4)
    plotInd = anData2013.pvmMean>=0 & ~isinf(anData2013.pvmMean);
    anData2013.pvmMean(anData2013.pvmMean==0)=1e-7;
    h=boxplot(anData2013.pvmMean(plotInd) , oGoodComp(plotInd),'symbol','r+','outliersize',4,'labelorientation','inline');
    hold on
    meanValues = grpstats(anData2013.pvmMean(plotInd), oGoodComp(plotInd),'nanmean');
    scatter(1:numel(meanValues),meanValues,1/numel(meanValues)*100,'fill');
    set(h(7,:),'Visible','off')
    set(gca,'YScale','log')
    set(gca,'YLim',[1/mean(anData2013.sampleVolumeReal)*6/pi*nanmean(anData2013.TWMeanD)^3*1e6 1e0])
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    ylabel('PVM TWC [g m^{-3}]')
    set(gca,'TickLength',[0.03 0.06],'TickDir','out');
    
    %plotGroupBoxplots(anData2013, oGoodComp);
end

if 1
    figure(18)
    clf
    %{'1/29';'2/04';'2/05';'2/06';'2/07';'2/08';'2/11';'2/12';'2/14'}
    plotInt = goodInt & oDay ==  '2/14';    
    
    %n = ceil(intervall);
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
    
    meanNum = 5;
    markerSize=60;
    scLineWidht = 1;
    plotXLim = [anData2013.timeStart(find(plotInt,1,'first')) anData2013.timeStart(find(plotInt,1,'last'))];
    
    s(4)=axes('position',axPos(1,:));
    [ax,h1,h2]= plotyy(anData2013.timeStart, smooth(anData2013.IWContent./anData2013.TWContent,meanNum),...
        anData2013.timeStart, smooth(anData2013.IWConcentraction./anData2013.TWConcentraction,meanNum));
    hold(ax(1),'on')
    hold(ax(2),'on')
    scatter(ax(1),anData2013.timeStart, anData2013.IWContent./anData2013.TWContent, ...
        markerSize,'bx','lineWidth',scLineWidht);
    %    plot(ax(1), BTplotData.timeUTC, BTplotData.LWC,'b--');
    %    plot(ax(2), BTplotData.timeUTC, BTplotData.IWC,'--','Color',[0 0.5 0]);
    scatter(ax(2),anData2013.timeStart, anData2013.IWConcentraction./anData2013.TWConcentraction,...
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
    scatter(ax(1),anData2013.timeStart, anData2013.LWContent, ...
        markerSize,'bx','lineWidth',scLineWidht);
    %    plot(ax(1), BTplotData.timeUTC, BTplotData.LWC,'b--');
    %    plot(ax(2), BTplotData.timeUTC, BTplotData.IWC,'--','Color',[0 0.5 0]);
    scatter(ax(2),anData2013.timeStart, anData2013.IWContent, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
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
    scatter(ax(1),anData2013.timeStart, anData2013.LWConcentraction,markerSize,'bx','lineWidth',scLineWidht);
    scatter(ax(2),anData2013.timeStart, anData2013.IWConcentraction*1000,markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    set(get(ax(1),'Ylabel'),'String',{'Number Concentration', 'Liquid [cm^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color','b');
    set(get(ax(2),'Ylabel'),'String',{'Number Concentration', 'Ice [l^{-1}]'},'fontsize',18,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %'YLim',[0 100],'YTick',[0 200 400 600 800 1000 1200 1400 1600 1800 2000 2200]);
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %'YLim',[0 600],'YTick',[0 200 400 600 800 1000 1200 1400 1600 1800 2000 2200]);
    
    s(1)=axes('position',axPos(4,:));
    plot(anData2013.timeStart, nanmoving_average(anData2013.TWContent,meanNum),'k');
    hold on
    plot(anData2013.timeStart, anData2013.cdpMean,'b');
    plot(anData2013.timeStart, anData2013.pvmMean,'Color',[0 0.5 0]);
    legend('HOLIMO','CDP','PVM');
    %     [ax,h1,h2]= plotyy(anData2013.timeStart, nanmoving_average(rem(anData2013.measMeanAzimutSonic+180,360), meanNum),...
    %         anData2013.timeStart, nanmoving_average(anData2013.measMeanT, meanNum));
    %     hold(ax(1),'on')
    %     hold(ax(2),'on')
    %     scatter(ax(1),anData2013.timeStart, rem(anData2013.measMeanAzimutSonic+180,360),markerSize,'bx','lineWidth',scLineWidht);
    %     scatter(ax(2),anData2013.timeStart, anData2013.measMeanT, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
    
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
%         print('-dpng','-r600', fullfile(fileFolder,fileName));
%     end
    
    
end


if 1
    figure(17)
    clf
    %{'1/29';'2/04';'2/05';'2/06';'2/07';'2/08';'2/11';'2/12';'2/14'}
    plotInt = goodInt & oDay ==  '2/12';
    
    scatter(anData2013.timeStart(plotInt), anData2013.TWContent2(plotInt),'b');
    hold on
    scatter(anData2013.timeStart(plotInt), anData2013.TWContent(plotInt),'c');
    scatter(anData2013.timeStart(plotInt), anData2013.cdpMean(plotInt),'g');
    scatter(anData2013.timeStart(plotInt), anData2013.pvmMean(plotInt),'r');
    hold on
    
    
    ylabel({'Water Content', 'Liquid [g*m^{-3}]'},'fontsize',18);
    %'YLim',[0 1],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    %set(gca,'XLim',anData2{1}.plotXLim,'YLim',[0 .4],'YTick',[0 .1 .2 .3 .4]);
    %xlabel('Time (UTC) [h]');
    datetick(gca,'x','HH-MM','keeplimits');
    set(gca,'XTickLabel',[]);
    legend({'HOLIMO (0-50 \mum)';'HOLIMO all';'CDP';'PVM'})
end

%Scatter plot wind measurements
if 1
    figure(16)
    clf
    
    subplot(1,3,1,'replace')
    markerColor = [1 69/255 0; 0 191/255 1];
    markerStyle = 'oo';
    gscatter(anData2013.meteoWindDir(goodInt),anData2013.measMeanAzimutSonic(goodInt) , oWindDirection(goodInt),...
        markerColor, markerStyle)
    hold on
    markerColor = [ 1 165/255 0;0 0 205/255];
    markerStyle = 'ss';
    gscatter(anData2013.meteoWindDir(goodInt), anData2013.ManchMetekDirAzimuthMeanMean(goodInt) , oWindDirection(goodInt),...
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
    gscatter(anData2013.meteoWindVel(goodInt),anData2013.measMeanVAzimut(goodInt) , oWindDirection(goodInt),...
        markerColor, markerStyle)
    hold on
    markerColor = [ 1 165/255 0;0 0 205/255];
    markerStyle = 'ss';
    gscatter(anData2013.meteoWindVel(goodInt), anData2013.ManchMetekVAzimuthMean(goodInt) , oWindDirection(goodInt),...
        markerColor, markerStyle)
    xlim([0 22]);
    ylim([0 22]);
    refline(1,0)
    title('horizontal Wind velocity [m s^{-1}]')
    ylabel('Sonic');
    xlabel('Meteo Swiss');
    h=legend('ETH - South wind','ETH - North wind','Manchester - South wind',...
        'Manchester - North wind','Location','NorthWest')
    set(h,'FontSize',8);
    box on
    
    
    subplot(1,3,3,'replace')
    markerColor = [1 69/255 0; 0 191/255 1];
    markerStyle = 'oo';
    gscatter(-anData2013.ManchMetekDirElevationMeanMean(goodInt),anData2013.meanElevSonic(goodInt) , oWindDirection(goodInt),...
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
    
    %      subplot(1,3,3,'replace')
    %      xdata = -anData2013.ManchMetekDirElevationMeanMean(goodInt);
    %      scatter(xdata, anData2013.meanElevSonic(goodInt))
    %     xlim([-40 5]);
    %     ylim([-40 5]);
    %      refline(1,0)
    %     title('Wind direction Elevation [°]')
    %     ylabel('Sonic ETH');
    %     xlabel('Sonic Manchester');
    %     box on
    
    
    
    
    
end
%Spectrum
if 1
    figure(15)
    clf
    
    subplot(1,2,1,'replace')
    hold on
    
    plotData = anData2013.water.histRealCor(:,goodInt);
    plotData(~isfinite(plotData)) = nan;
    plotData = nanmean(plotData,2);
    p1 = plot(anData2013.Parameter.histBinMiddle(3:end), ...
        plotData(3:end), ...
        'LineWidth',2,'Color','k');
    
    plotData = anData2013.ice.histRealCor(:,goodInt);
    plotData(~isfinite(plotData)) = nan;
    plotData = nanmean(plotData,2);
    p2 = plot(anData2013.Parameter.histBinMiddle(3:end), ...
        plotData(3:end), ...
        'LineWidth',2,'LineStyle','--','Color','k');
    %
    %     plotData = nanmean(anData2013.ManchCDPConcArrayMean);
    %     p2 = plot( anData2013.Parameter.ManchCDPBinSizes, ...
    %        plotData, ...
    %         'LineWidth',2,'Color','b');
    
    plotData = nanmean(anData2013.ManchCDPConcArrayMeanNorm(goodInt,:));
    p2 = plot( anData2013.Parameter.ManchCDPBinSizes, ...
        plotData, ...
        'LineWidth',2,'Color','b');
    
    
    
    h_legend = legend({'HOLIMO Liquid', 'HOLIMO Ice', 'CDP'}, 'Location', 'NorthEast');
    set(h_legend,'FontSize',11);
    ylabel('Number density d(N)/d(log d) [cm^{-3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    title('All cases');
    %title([datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'dd/mm/yyyy') ' ' ...
    %    datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'HH:MM') '-'...
    %    datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(2)),'HH:MM')]);
    xlim(gca, [3 250]);
    ylim(gca, [5e-2 8e2]);
    set(gca,'XTick',[10 20 50 100 200])
    set(gca,'YTick',[1e-2 1e-1 1e0 1e1 1e2 1e3])
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    box on
    
    
    
    
    subplot(1,2,2,'replace')
    hold on
    
    %plotStartTime = [2013 01 29 0 0 0];
    plotStartTime = [2013 02 08 0 0 0];
    plotEndTime = plotStartTime + [0 0 1 0 0 0];
    plotInt = anData2013.timeStart > datenum(plotStartTime) & anData2013.timeStart < datenum(plotEndTime);
    
    plotData = anData2013.water.histRealCor(:,plotInt);
    plotData(~isfinite(plotData)) = nan;
    plotData = nanmean(plotData,2);
    p1 = plot(anData2013.Parameter.histBinMiddle(3:end), ...
        plotData(3:end), ...
        'LineWidth',2,'Color','k');
    plotData = anData2013.ice.histRealCor(:,plotInt);
    plotData(~isfinite(plotData)) = nan;
    plotData = nanmean(plotData,2);
    p2 = plot(anData2013.Parameter.histBinMiddle(3:end), ...
        plotData(3:end), ...
        'LineWidth',2,'LineStyle','--','Color','k');
    
    plotData = nanmean(anData2013.ManchCDPConcArrayMeanNorm(plotInt,:));
    
    p2 = plot(anData2013.Parameter.ManchCDPBinSizes, ...
        plotData, ...
        'LineWidth',2,'Color','b');
    
    
    h_legend = legend({'HOLIMO Liquid', 'HOLIMO Ice', 'CDP'}, 'Location', 'NorthEast');
    set(h_legend,'FontSize',11);
    ylabel('Number density d(N)/d(log d) [cm^{-3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    title(['Case: ' datestr(plotStartTime)]);
    %title([datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'dd/mm/yyyy') ' ' ...
    %    datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'HH:MM') '-'...
    %    datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(2)),'HH:MM')]);
    xlim(gca, [3 250]);
    ylim(gca, [5e-2 8e2]);
    set(gca,'XTick',[10 20 50 100 200])
    set(gca,'YTick',[1e-2 1e-1 1e0 1e1 1e2 1e3 1e4])
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    box on
    
end


if 0
    figure(8)
    clf
    %     startInt = 70;
    %     endInt = 90;
    %     startTime = anData2013.timeStart(startInt);
    %     endTime = anData2013.timeEnd(endInt);
    startTime = datenum([2013 02 11 16 00 00]);
    endTime =     datenum([2013 02 11 17 00 00]);
    
    subplot (3,1,1)
    plot(dataManchester.cdp.dateNum, dataManchester.cdp.data);
    hold on
    plot(anData2013.timeStart, anData2013.ManchCDPLWCMean./1000,'--'...
        , anData2013.timeStart, anData2013.PSIManchCDPMean,'--'...
        , anData2013.timeStart, anData2013.TWContent,'--');
    xlabel('Time (UTC)');
    legend({'CDP PSI'; 'CDP Manch'});
    set(gca,'XLim',[startTime endTime]);
    %set(gca,'YLim',[-10 370]);
    datetick(gca,'x','DD/mm HH:MM','keeplimits');
    
    subplot(3,1,2)
    plot(dataManchester.pvm.dateNum, dataManchester.pvm.data,...
        dataManchesterMetek.dateNum,dataManchesterMetek.dirAzimuth);
    hold on
    plot(anData2013.timeStart, anData2013.ManchMetekDirAzimuthMeanMean,'--',...
        anData2013.timeStart, anData2013.ManchMetekDirAzimuthMean,'--');
    
    
    xlabel('Time (UTC)');
    legend({'Metek'; 'Metek Mean'});
    set(gca,'XLim',[startTime endTime]);
    set(gca,'YLim',[-10 370]);
    datetick(gca,'x','mm/DD','keeplimits');
    
    subplot(3,1,3)
    plot(dataMeteo.dateNum, dataMeteo.windDir);
    hold on
    plot(anData2013.timeStart, anData2013.meteoWindDir,'--');
    
    
    xlabel('Time (UTC)');
    legend({'Metek'; 'Metek Mean'});
    set(gca,'XLim',[startTime endTime]);
    set(gca,'YLim',[-10 370]);
    datetick(gca,'x','mm/DD','keeplimits');
    %dataManchesterRotor.dateNum,dataManchesterRotor.wingAzimuth);
    %      anData2013.timeStart, anData2013.meteoWindDir,'--',...
    
    
end

if 0
    figure(7)
    clf
    %     startInt = 70;
    %     endInt = 90;
    %     startTime = anData2013.timeStart(startInt);
    %     endTime = anData2013.timeEnd(endInt);
    startTime = datenum([2013 02 11 16 00 00]);
    endTime =     datenum([2013 02 11 17 00 00]);
    subplot (3,1,1)
    plot(dataManchesterRotor.dateNum, dataManchesterRotor.windAzimuth,...
        dataSonic.Date_Num, dataSonic.Mean_WD_azimut);
    hold on
    plot(anData2013.timeStart, anData2013.ManchRotorWindAzimuthMean,'--',...
        anData2013.timeStart, anData2013.measMeanAzimutSonic,'--');
    xlabel('Time (UTC)');
    legend({'Wind'; 'Sonic'});
    set(gca,'XLim',[startTime endTime]);
    set(gca,'YLim',[-10 370]);
    datetick(gca,'x','mm/DD','keeplimits');
    
    subplot(3,1,2)
    plot(dataManchesterMetek.dateNum,dataManchesterMetek.dirAzimuthMean,...
        dataManchesterMetek.dateNum,dataManchesterMetek.dirAzimuth);
    hold on
    plot(anData2013.timeStart, anData2013.ManchMetekDirAzimuthMeanMean,'--',...
        anData2013.timeStart, anData2013.ManchMetekDirAzimuthMean,'--');
    
    
    xlabel('Time (UTC)');
    legend({'Metek'; 'Metek Mean'});
    set(gca,'XLim',[startTime endTime]);
    set(gca,'YLim',[-10 370]);
    datetick(gca,'x','mm/DD','keeplimits');
    
    subplot(3,1,3)
    plot(dataMeteo.dateNum, dataMeteo.windDir);
    hold on
    plot(anData2013.timeStart, anData2013.meteoWindDir,'--');
    
    
    xlabel('Time (UTC)');
    legend({'Metek'; 'Metek Mean'});
    set(gca,'XLim',[startTime endTime]);
    set(gca,'YLim',[-10 370]);
    datetick(gca,'x','mm/DD','keeplimits');
    %dataManchesterRotor.dateNum,dataManchesterRotor.wingAzimuth);
    %      anData2013.timeStart, anData2013.meteoWindDir,'--',...
    
end


if 0
    figure(6)
    clf
    diff_rotor = difference_azimuth(anData2013.ManchRotorWingAzimuthMean,anData2013.meteoWindDir);
    diff_wind = difference_azimuth(anData2013.ManchRotorWindAzimuthMean,anData2013.meteoWindDir);
    diff_sonic =  difference_azimuth(anData2013.measMeanAzimutSonic,anData2013.meteoWindDir);
    diff_Metek =  difference_azimuth(anData2013.ManchMetekDirAzimuthMean,anData2013.meteoWindDir);
    plotdataX = [diff_rotor; diff_wind; diff_sonic; diff_Metek]';
    %     plotdataX = [anData2013.ManchRotorWingAzimuthMean;  anData2013.ManchRotorWindAzimuthMean; ...
    %          anData2013.measMeanAzimutSonic; anData2013.meteoWindDir; anData2013.ManchMetekDirAzimuthMean;]';
    %      anData2013.ManchMetekDirAzimuthMean;
    plotmatrix(plotdataX);
    % xlabel('Time (UTC)');
    % legend({'Rotor'; 'Rotor Wind'; 'Metek'; 'Sonic'; 'Meteo'});
    % set(gca,'XLim',plotXLim);
    % datetick(gca,'x','mm/DD','keeplimits');
end

%Comparision Rotor / Sonic
if 0
    figure(5)
    clf
    plotXLim = [min(anData2013.timeStart) max(anData2013.timeStart)];
    
    
    h1=subplot(3,1,1);
    plotdataX = [anData2013.ManchRotorWingAzimuthMean; anData2013.ManchRotorWindAzimuthMean; ...
        anData2013.ManchMetekDirAzimuthMean; anData2013.measMeanAzimutSonic; anData2013.meteoWindDir]';
    plot(anData2013.timeStart, plotdataX);
    xlabel('Time (UTC)');
    legend({'Rotor'; 'Rotor Wind'; 'Metek'; 'Sonic'; 'Meteo'});
    set(gca,'XLim',plotXLim);
    datetick(gca,'x','mm/DD','keeplimits');
    
    h2=subplot(3,1,2);
    diff_rotor = difference_azimuth(anData2013.ManchRotorWingAzimuthMean,anData2013.ManchRotorWindAzimuthMean);
    nanmean(diff_rotor)
    diff_sonic = difference_azimuth(anData2013.measMeanAzimutSonic ,anData2013.ManchRotorWindAzimuthMean);
    nanmean(diff_sonic)
    diff_ro_meteo = difference_azimuth(anData2013.ManchRotorWingAzimuthMean,anData2013.meteoWindDir);
    nanmean(diff_ro_meteo)
    diff_so_meteo = difference_azimuth(anData2013.measMeanAzimutSonic2,anData2013.meteoWindDir);
    nanmean(diff_so_meteo)
    
    plotdataX = [diff_rotor]';%; diff_sonic; diff_ro_meteo; diff_so_meteo]';
    scatter(anData2013.timeStart, plotdataX);
    xlabel('Time (UTC)');
    legend({'Rotor - RotorWind'; 'Sonic - Rotor Wind'; 'Rotor - Meteo'; 'Sonic - Meteo'});
    set(gca,'XLim',plotXLim);
    set(gca,'YLim',[-180 180]);
    datetick(gca,'x','mm/DD','keeplimits');
    
    h3=subplot(3,1,3);
    scatter(anData2013.timeStart,anData2013.ManchRotorWingElevationMean-anData2013.ManchRotorWindElevationMean);
    set(gca,'XLim',plotXLim);
    set(gca,'YLim',[-90 90]);
    datetick(gca,'x','mm/DD','keeplimits');
    
    linkaxes([h1 h2 h3],'x')
    %
end

%Comparision Time Serie
if 0
    figure(4)
    clf
    plotXLim = [min(anData2013.timeStart) max(anData2013.timeStart)];
    
    h1 = subplot(3,1,1);
    plotdataX = [anData2013.cdpMean;  anData2013.PSIManchCDPMean; anData2013.pvmMean; ...
        anData2013.PSIManchPVMMean; anData2013.PSIPSIPVMMean]';
    plot(anData2013.timeStart, plotdataX);
    xlabel('Time (UTC)');
    legend({'Man CDP raw'; 'Man CDP'; 'Man PVM raw'; 'Man PVM'; 'PSI PVM'});
    set(gca,'XLim',plotXLim);
    datetick(gca,'x','mm/DD','keeplimits');
    
    h2 = subplot(3,1,2);
    plotdataX = [anData2013.TWContent;  anData2013.TWContent2; anData2013.TWContentRaw; ...
        anData2013.TWContentRaw2]';
    plot(anData2013.timeStart, plotdataX);
    xlabel('Time (UTC)');
    legend({'TWC'; 'TWC >50um'; 'TWC raw'; 'TWC raw <50um'});
    set(gca,'XLim',plotXLim);
    datetick(gca,'x','mm/DD','keeplimits');
    
    h3 = subplot(3,1,3);
    plotdataX = [anData2013.TWContent; anData2013.TWContent2; anData2013.PSIManchCDPMean; anData2013.PSIManchPVMMean; anData2013.PSIPSIPVMMean]';
    plot(anData2013.timeStart, plotdataX);
    xlabel('Time (UTC)');
    legend({'TWC'; 'TWC >50um'; 'Man CDP'; 'Man PVM'; 'PSI PVM'});
    set(gca,'XLim',plotXLim);
    datetick(gca,'x','mm/DD','keeplimits');
    
    
    linkaxes([h1 h2 h3])
    
    %     plotdataY = [anData2013.TWContent;  anData2013.TWContent2; anData2013.TWContentRaw; ...
    %        anData2013.TWContentRaw2]';
    
end
%Comparsion PSI
if 0
    figure (3)
    clf
    plotdata = [anData2013.cdpMean;  anData2013.PSIManchCDPMean; anData2013.pvmMean; ...
        anData2013.PSIManchPVMMean; anData2013.PSIPSIPVMMean]';
    plotnames = {'Man CDP raw'; 'Man CDP'; 'Man PVM raw'; 'Man PVM'; 'PSI PVM'};
    gplotmatrix(plotdata,[],[],...
        'br','.o',5,'on','',plotnames,plotnames);
    %     [H,AX,BigAx,P] = plotmatrix(plotdata)
    %     h = get(AX(end,6),'xlabel');
    % set(h, 'String', 'Spaltenbeschriftung unten')
    % h = get(AX(3,1),'ylabel');
    % set(h, 'String', 'Zeilenbeschriftung links')
end

%Comparsion PSI to HOLIMO
if 0
    figure (2)
    clf
    plotdataX = [anData2013.cdpMean;  anData2013.PSIManchCDPMean; anData2013.pvmMean; ...
        anData2013.PSIManchPVMMean; anData2013.PSIPSIPVMMean]';
    plotdataY = [anData2013.TWContent;  anData2013.TWContent2; anData2013.TWContentRaw; ...
        anData2013.TWContentRaw2]';
    plotnamesX = {'Man CDP raw'; 'Man CDP'; 'Man PVM raw'; 'Man PVM'; 'PSI PVM'};
    plotnamesY = {'TWC'; 'TWC >50um'; 'TWC raw'; 'TWC raw <50um'};
    
    gplotmatrix(plotdataX,plotdataY,[],...
        'br','.o',5,'on','',plotnamesX,plotnamesY);
    %     [H,AX,BigAx,P] = plotmatrix(plotdata)
    %     h = get(AX(end,6),'xlabel');
    % set(h, 'String', 'Spaltenbeschriftung unten')
    % h = get(AX(3,1),'ylabel');
    % set(h, 'String', 'Zeilenbeschriftung links')
end

%Comparsion new Manchester / HOLIMO (only good Intervalss)
if 0
    figure(5)
    clf
    
    subplot(2,2,1)
    hold on
    
    x=anData2013.ManchCDPLWCMean(goodInt);
    y=anData2013.TWContent(goodInt);
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('CDP');
    ylabel('HOLIMO II (6-250 um)');
    title('Water Content [g m^{-3}]')
    box on
    
    subplot(2,2,2)
    hold on
    x=anData2013.ManchCDPMVDMean(goodInt);
    y=anData2013.meanD(goodInt)*1e6;
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('CDP');
    ylabel('HOLIMO II');
    title('Mean Diameter [/mum]')
    box on
    
    subplot(2,2,3)
    hold on
    
    x=anData2013.ManchCDPLWCMean(goodInt);
    y=anData2013.TWContent2(goodInt);
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('CDP');
    ylabel('HOLIMO II (6-50 um)');
    title('Water Content [g m^{-3}]')
    box on
    
    subplot(2,2,4)
    hold on
    x=anData2013.ManchCDPConcMean(goodInt);
    y=anData2013.TWConcentraction(goodInt);
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('CDP');
    ylabel('HOLIMO II (6-50 um)');
    title('Water Concentration [g m^{-3}]')
    box on
    
end


%Comparsion PSI / HOLIMO (only good Intervalss)
if 0
    figure(4)
    clf
    
    subplot(2,2,1)
    hold on
    
    x=anData2013.PSIManchCDPMean(goodInt);
    y=anData2013.TWContent(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 0.7%1.05*max(max(x),max(y));
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('CDP');
    ylabel('HOLIMO II (6-250 um)');
    title('Water Content [g m^{-3}]')
    box on
    
    subplot(2,2,2)
    hold on
    x=anData2013.PSIManchPVMMean(goodInt);
    y=anData2013.TWContent(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 0.7%1.05*max(max(x),max(y));
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('PVM');
    ylabel('HOLIMO II (6-250 um)');
    title('Water Content [g m^{-3}]')
    box on
    
    subplot(2,2,3)
    hold on
    
    x=anData2013.PSIManchCDPMean(goodInt);
    y=anData2013.TWContent2(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 0.7%1.05*max(max(x),max(y));
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('CDP');
    ylabel('HOLIMO II (6-50 um)');
    title('Water Content [g m^{-3}]')
    box on
    
    subplot(2,2,4)
    hold on
    x=anData2013.PSIManchPVMMean(goodInt);
    y=anData2013.TWContent2(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 0.7%1.05*max(max(x),max(y));
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('PVM');
    ylabel('HOLIMO II (6-50 um)');
    title('Water Content [g m^{-3}]')
    box on
    
end

%Comparsion old Manchester / HOLIMO (only good Intervalss)
if 1
    
    figure(3)
    clf
    %goodInt = goodInt & isSouth;
    
    subplot(2,2,1)
    hold on
    
    x=anData2013.cdpMean(goodInt);
    y=anData2013.TWContent2(goodInt);
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
    x=anData2013.pvmMean(goodInt);
    y=anData2013.TWContent2(goodInt);
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
    x=anData2013.ManchCDPConcArrayMean(goodInt,:);
    x=x(:,4:end);
    x=sum(x,2);
    x=x';
    y=anData2013.TWConcentraction2(goodInt);
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
    
    x=anData2013.cdpMean(goodInt);
    y=anData2013.pvmMean(goodInt);
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
    ylim([0, .6]);
    xlabel('CDP');
    ylabel('PVM');
    title('Total Water Content [g m^{-3}]')
    box on
    
    
end

%Comparsion old Manchester / HOLIMO (only good Intervalss)
%Through origin
if 1
    
    figure(33)
    clf
    
    
    subplot(2,2,1)
    hold on
    
    x=anData2013.cdpMean(goodInt);
    y=anData2013.TWContent2(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    
    plotLimit = 1.05*max(max(x),max(y));
    scatter(x, y);
    
    m = y/x;
    xfit = linspace(0,plotLimit);
    plot(xfit,m.*xfit);
    plot(xfit,xfit,'k-');
    R=corrcoef(x,y);

    
    str1(2) = {[num2str(m,'%4.2g') '*x']};
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
    x=anData2013.pvmMean(goodInt);
    y=anData2013.TWContent2(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 1.05*max(max(x),max(y));
    scatter(x, y);
    
    m = y/x;
    xfit = linspace(0,plotLimit);
    plot(xfit,m.*xfit);
    plot(xfit,xfit,'k-');
    R=corrcoef(x,y);
    
    str1(2) = {[num2str(m,'%4.2g') '*x']};
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
    x=anData2013.ManchCDPConcArrayMean(goodInt,:);
    x=x(:,4:end);
    x=sum(x,2);
    x=x';
    y=anData2013.TWConcentraction2(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 1.05*max(max(x),max(y));
    scatter(x, y);
    
    m = y/x;
    xfit = linspace(0,plotLimit);
    plot(xfit,m.*xfit);
    plot(xfit,xfit,'k-');
    R=corrcoef(x,y);
    
    str1(2) = {[num2str(m,'%4.2g') '*x']};
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
    
    x=anData2013.cdpMean(goodInt);
    y=anData2013.TWContent(goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    
    plotLimit = 1.05*max(max(x),max(y));
    scatter(x, y);
    
    m = y/x;
    xfit = linspace(0,plotLimit);
    plot(xfit,m.*xfit);
    plot(xfit,xfit,'k-');
    R=corrcoef(x,y);
    
    str1(2) = {[num2str(m,'%4.2g') '*x']};
    str1(1) = {['R-value: ' num2str(R(1,2),'%4.2g')]};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, 1.2]);
    ylim([0, .6]);
    xlabel('CDP');
    ylabel('HOLIMO II (6-250 um)');
    title('Total Water Content [g m^{-3}]')
    box on
    
    
end

%Comparsion old Manchester / HOLIMO (only bad Intervalss)
if 0
    
    figure(2)
    clf
    
    subplot(2,2,1)
    hold on
    
    x=anData2013.cdpMean(~goodInt);
    y=anData2013.TWContent(~goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 0.7%1.05*max(max(x),max(y));
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('CDP');
    ylabel('HOLIMO II (6-250 um)');
    title('Water Content [g m^{-3}]')
    box on
    
    subplot(2,2,2)
    hold on
    x=anData2013.pvmMean(~goodInt);
    y=anData2013.TWContent(~goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 0.7%1.05*max(max(x),max(y));
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('PVM');
    ylabel('HOLIMO II (6-250 um)');
    title('Water Content [g m^{-3}]')
    box on
    
    subplot(2,2,3)
    hold on
    
    x=anData2013.cdpMean(~goodInt);
    y=anData2013.TWContent2(~goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 0.7%1.05*max(max(x),max(y));
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('CDP');
    ylabel('HOLIMO II (6-50 um)');
    title('Water Content [g m^{-3}]')
    box on
    
    subplot(2,2,4)
    hold on
    x=anData2013.pvmMean(~goodInt);
    y=anData2013.TWContent2(~goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 0.7%1.05*max(max(x),max(y));
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('PVM');
    ylabel('HOLIMO II (6-50 um)');
    title('Water Content [g m^{-3}]')
    box on
    
end

%Comparsion Water content Manchester CDP + PVM / HOLIMO
if 0
    figure(1)
    clf
    subplot(1,2,1)
    hold on
    
    x=anData2013.cdpMean;
    y=anData2013.TWContent;
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 1.5%1.05*max(max(x),max(y));
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('CDP');
    ylabel('HOLIMO II');
    title('Water Content [g m^{-3}]')
    box on
    
    subplot(1,2,2)
    hold on
    x=anData2013.pvmMean;
    y=anData2013.TWContent;
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 1.5%1.05*max(max(x),max(y));
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
    xlim([0, plotLimit]);
    ylim([0, plotLimit]);
    xlabel('PVM');
    ylabel('HOLIMO II');
    title('Water Content [g m^{-3}]')
    box on
end