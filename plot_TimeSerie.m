function plot_TimeSerie(anData2013All,startTime, endTime)

    clf
    
    
    plotColor =flipud(lbmap(2,'RedBlue'));
    plotInt =ones(1,numel(anData2013All.intTimeStart)); 
    goodInt2 = plotInt;

    clear s;
    set(gcf,'DefaultLineLineWidth',1.7);
    axnumber = 6;
    for m=1:axnumber
        axleft = 0.11;
        axright = 0.09;
        axtop = -0.22;
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
    
    s(6)=axes('position',axPos(1,:));
    plot(anData2013All.intTimeStart, nanmoving_average(anData2013All.IWContent./anData2013All.TWContent,meanNum),...
        'LineWidth',1, 'Color',plotColor(1,:))  
    set(gca,'XLim',plotXLim ,'YLim',[0 1.1],'YTick',[0 0.25 0.5 0.75 1],'ycolor', plotColor(1,:));
 
    hold on

    xlabel('Time (UTC) [h]');
    datetick(gca,'x','HH-MM','keeplimits');
    ylabel('IWC/TWC')
    plotXTick = get(gca,'XTick');
    
    
    s(5)=axes('position',axPos(2,:));
    [ax,h1,h2]= plotyy(anData2013All.intTimeStart, nanmoving_average(anData2013All.LWContent,meanNum),...
        anData2013All.intTimeStart, nanmoving_average(anData2013All.IWContent,meanNum));
    set(h1,'LineWidth',1, 'Color',plotColor(1,:))  
    set(h2,'LineWidth',1, 'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[], 'ycolor',plotColor(1,:));
     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[], 'ycolor',plotColor(2,:));  
    hold(ax(1),'on')
    hold(ax(2),'on')
    set(get(ax(1),'Ylabel'),'String',{'Water Content', 'Liquid [g*m^{-3}]'},'fontsize',11,'lineWidth',scLineWidht);
    set(get(ax(2),'Ylabel'),'String',{'Water Content', 'Ice [g*m^{-3}]'},'fontsize',11,'lineWidth',scLineWidht);
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[], 'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[], 'ycolor',plotColor(2,:));   

  
      s(4)=axes('position',axPos(3,:));
    [ax, h1, h2]= plotyy(anData2013All.intTimeStart, nanmoving_average(anData2013All.LWMeanD*1e6,meanNum),...
        anData2013All.intTimeStart, nanmoving_average(anData2013All.IWMeanD*1e6,meanNum));
    set(h1,'LineWidth',1,'Color',plotColor(1,:))  
    set(h2,'LineWidth',1,'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'ycolor',plotColor(2,:));
    hold(ax(1),'on')
    hold(ax(2),'on')

    set(get(ax(1),'Ylabel'),'String',{'Diameter', 'Liquid [cm^{-3}]'},'fontsize',11,'lineWidth',scLineWidht,'Color',plotColor(1,:));
    set(get(ax(2),'Ylabel'),'String',{'Diameter', 'Ice [cm^{-3}]'},'fontsize',11,'lineWidth',scLineWidht,'Color',plotColor(2,:));
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'ycolor',plotColor(1,:));
     set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'ycolor',plotColor(2,:));
      
     
    s(3)=axes('position',axPos(4,:));
    [ax, h1, h2]= plotyy(anData2013All.intTimeStart, nanmoving_average(anData2013All.LWConcentraction,meanNum),...
        anData2013All.intTimeStart, nanmoving_average(anData2013All.IWConcentraction,meanNum));
    set(h1,'LineWidth',1,'Color',plotColor(1,:))  
    set(h2,'LineWidth',1,'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 40],'YTick',[0 20 40],'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'YLim',[0 4],'YTick',[0 2 4 6 8],'ycolor',plotColor(2,:));
    hold(ax(1),'on')
    hold(ax(2),'on')
       axes(ax(1))
     %plot(anData2013All.intTimeStart, nanmoving_average(anData2013All.ManchCDPConcMean,meanNum));
     axes(ax(2))
     %plot(anData2013All.intTimeStart, nanmoving_average(anData2013All.Manch_2DS*1000,meanNum));
  


    set(get(ax(1),'Ylabel'),'String',{'Number Concentration', 'Liquid [cm^{-3}]'},'fontsize',11,'lineWidth',scLineWidht,'Color',plotColor(1,:));
    set(get(ax(2),'Ylabel'),'String',{'Number Concentration', 'Ice [cm^{-3}]'},'fontsize',11,'lineWidth',scLineWidht,'Color',plotColor(2,:));

      s(2)=axes('position',axPos(5,:));
    [ax, h1, h2]= plotyy(anData2013All.intTimeStart, anData2013All.meteoTemperature,...
        anData2013All.intTimeStart, anData2013All.meteoWindVel);
    set(h1,'Color',plotColor(1,:))  
    set(h2,'Color',plotColor(2,:))
    set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'ycolor',plotColor(1,:));
    set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[],'ycolor',plotColor(2,:));
    hold(ax(1),'on')
    hold(ax(2),'on')
     set(get(ax(1),'Ylabel'),'String',{'Temp. Meteo', '[°C]'},'fontsize',11,'lineWidth',scLineWidht,'Color',plotColor(1,:));
     set(get(ax(2),'Ylabel'),'String',{'Horz. Wind Vel.', 'Meteo [m s^{-1}]'},'fontsize',11,'lineWidth',scLineWidht,'Color',plotColor(2,:));


     
    
    plotColor = lbmap(4,'BrownBlue');
    s(1)=axes('position',axPos(6,:));
    hold on
    plot(anData2013All.intTimeStart, anData2013All.cdpMean,'r','LineWidth',1, 'Color',plotColor(2,:));
    plot(anData2013All.intTimeStart, anData2013All.pvmMean-0.0919,'c','LineWidth',1, 'Color',plotColor(1,:));
    
    plot(anData2013All.intTimeStart, anData2013All.TWContent,'k','LineWidth',1);
  
    legend('CDP','PVM','HOLIMO');
    set(get(gca,'Ylabel'),'String',{'Water Content', 'Total [g*m^{-3}]'},'fontsize',11,'lineWidth',scLineWidht,'Color','k');
    set(gca,'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);

    
    set(gca,'XTickLabel',[]);
    box(s(1))
  
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 31 24.5]);
    set(gcf, 'PaperSize', [31 24.5]);
    
    if anData2013All.savePlots
        fileName = ['Comparision_TimeSerie_' datestr(startTime, 'yy-mm-dd')];         
        print(gcf,'-dpdf','-r600', fullfile(anData2013All.saveDir,fileName));
    end


end

