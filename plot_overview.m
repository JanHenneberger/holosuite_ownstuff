function plot_overview(anData, varargin)

if nargin >= 2
    startTime = varargin{1};
else
    startTime = datenum([2014 2 1 0 0 0]);
end

if nargin >= 3
    endTime = varargin{2};
else
    endTime = datenum([2014 3 1 0 0 0]);
end

set(0,'DefaultAxesFontSize',14);
set(0,'DefaultAxesLineWidth',2);
set(0,'DefaultLineLineWidth',2);

%%wind rose
if 1
    figure(704)
    clf
    wind_rose(anData.measMeanAzimutSonic+180,anData.measMeanV,'dtype','meteo','bcolor','k','quad',3)


end
if 1
    figure(703)
    clf
    wind_rose(anData.meteoWindDir+180,anData.meteoWindVel,'dtype','meteo','bcolor','k','quad',3)
end

%% hist of Temperature
if 1
    figure(702)
    clf
    borders = -24:2:-2;
    [a, ~] = histc(anData.meteoTemperature,borders);
    [a2, ~] = histc(anData.meteoTemperature(isfinite(anData.timeStart)),borders);
    bar(borders, [a/12;  a2/12]','histc');

    legend({'All periods'; 'With clouds'});
    xlabel('Temperature [°C]');
    ylabel('Duration [h]');
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 15 10]);
    set(gcf, 'PaperSize', [15 10]);
    
    if anData.savePlots
        fileName = ['Hist_Temperature'];        
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
    
end
%% time serie
if 1
    
    figure(701)
    clf
    
    plotInt = anData.oIsValid == 'Valid';    
    clear s;
    
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
    plot(anData.timeStart, nanmoving_average(anData.IWContent./anData.TWContent,meanNum));
    ylabel('IWC/TWC');  
    set(gca,'XLim',plotXLim, 'YLim',[0 1.1],'YTick',[0 0.2 .4 .6 .8 1 ]);    
    xlabel('Day in February 2014');
    
    
    %set(gca,'XTick',linspace(startTime,endTime,29))
    datetick(gca,'x','dd/hh','keepticks','keeplimits');
    plotXTick = get(gca,'XTick');
    
    
    s(3)=axes('position',axPos(2,:));
    plot(anData.timeStart, nanmoving_average(anData.TWContent,meanNum));
    ylabel({'Water Content' '[g*m^{-3}]'}); 
    set(gca,'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 .12],'YTick',[0 0.02 0.04 0.06 0.08 0.1]);
    
    s(2)=axes('position',axPos(3,:));
    plot(anData.timeStart, nanmoving_average(anData.TWConcentraction,meanNum));
    ylabel({'Number Concentration' '[cm^{-3}]'});    
    set(gca,'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 45],'YTick',[0 10 20 30 40 50]);
   
    
    s(1)=axes('position',axPos(4,:));
    [ax,h1,h2]= plotyy(anData.intTimeStart, nanmoving_average(anData.meteoWindDir, meanNum),...
      anData.intTimeStart, nanmoving_average(anData.meteoTemperature, meanNum));
        hold(ax(1),'on')
        hold(ax(2),'on')     
    
   set(get(ax(1),'Ylabel'),'String',{'Wind Direction', 'Azimut [°]'},'fontsize',14,'lineWidth',scLineWidht,'Color','b');
   set(get(ax(2),'Ylabel'),'String',{'Air Temperature', '[°C]'},'fontsize',14,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
   set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]); 
   set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[-25 0]);

         
    set(ax(1),'XTickLabel',[]);
    set(ax(2),'XTickLabel',[]);
    
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 30 20]);
    set(gcf, 'PaperSize', [30 20]);
    
    if anData.savePlots
        fileName = ['TimeSerie_Overview'];        
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
    
end