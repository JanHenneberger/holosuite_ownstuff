allFiles = dir('All*');
allFiles = {allFiles.name;};


if ~exist('allData','var');
    for cnt =1:numel(allFiles)
        allData{cnt} = load(allFiles{cnt});
        allData{cnt} = allData{cnt}.anDataAll;        
    end
end


% for cnt = 1:numel(allData.sample)
%     sampleVolumeReal(cnt)=allData.sample{1,cnt}.VolumeReal;
% end

chooseDay = 6;
plotXLimRaw  = [datenum([2013 2 chooseDay 0 0 0]) datenum([2013 2 chooseDay+1 0 0 0])];
for cnt = 1:numel(allFiles)
anData2{cnt}.plotXLimInd = [find(allData{cnt}.timeStart >= plotXLimRaw(1),1,'first') find(allData{cnt}.timeStart <= plotXLimRaw(2),1,'last')];
anData2{cnt}.plotXLim = [allData{cnt}.timeStart(anData2{cnt}.plotXLimInd(1)),...
    allData{cnt}.timeStart(anData2{cnt}.plotXLimInd(2))];
end

figure(1)
clf
clear s;

set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);
set(gcf,'DefaultLineLineWidth',2);
axnumber = 3;
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

markerSize=40;
scLineWidht=1;
anParameter2.plotColors = {'k','b','r','c','c','m','y'};
s(3)=axes('position',axPos(1,:));
hold on 
for cnt = 1:numel(allFiles)
    if cnt == 1
        scatter(allData{cnt}.timeStart, allData{cnt}.IWContent, markerSize,'x','MarkerEdgeColor',[0 0.5 0]);
    else
    plot(allData{cnt}.timeStart, allData{cnt}.IWContent,'Color',anParameter2.plotColors{cnt});
    end
hold on 
end

ylabel({'Water Content', 'Ice [g*m^{-3}]'},'fontsize',18,'lineWidth',scLineWidht);
set(gca,'XLim',anData2{1}.plotXLim,'XTickLabel',[],'YLim',[0 3],'YTick',[0 0.5 1 1.5 2 2.5]);
xlabel('Time (UTC) [h]');
datetick(gca,'x','HH-MM','keeplimits');
box on
 
s(2)=axes('position',axPos(2,:));
hold on 
for cnt = 1:numel(allFiles)
    if cnt == 1
        scatter(allData{cnt}.timeStart, allData{cnt}.LWContent, markerSize,'x','MarkerEdgeColor',[0 0.5 0]);
    else
    plot(allData{cnt}.timeStart, allData{cnt}.LWContent,'Color',anParameter2.plotColors{cnt});
    end
hold on 
end

ylabel({'Water Content', 'Liquid [g*m^{-3}]'},'fontsize',18,'lineWidth',scLineWidht);
%'YLim',[0 1],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
set(gca,'XLim',anData2{1}.plotXLim,'YLim',[0 .4],'YTick',[0 .1 .2 .3 .4]);
%xlabel('Time (UTC) [h]');
datetick(gca,'x','HH-MM','keeplimits');
set(gca,'XTickLabel',[]);
box on

s(1)=axes('position',axPos(3,:));
hold on 
for cnt = 1:numel(allFiles)
    if cnt == 1
        scatter(allData{cnt}.timeStart, allData{cnt}.TWContent, markerSize,'x','MarkerEdgeColor',[0 0.5 0]);
    else
    plot(allData{cnt}.timeStart, allData{cnt}.TWContent,'Color',anParameter2.plotColors{cnt});
    end
hold on 
end

ylabel({'Water Content', 'Total [g*m^{-3}]'},'fontsize',18,'lineWidth',scLineWidht);
%'YLim',[0 1],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
set(gca,'XLim',anData2{1}.plotXLim,'YLim',[0 3],'YTick',[0 0.5 1 1.5 2 2.5]);
%xlabel('Time (UTC) [h]');
datetick(gca,'x','HH-MM','keeplimits');
set(gca,'XTickLabel',[]);
box on
% 
% s(1)=axes('position',axPos(3,:));
% plot(anData.timeStart, nanmoving_average(anData.TWContent,meanNum),'k');
% hold on
% plot(anData.timeStart, anData.cdpMean,'b');
% plot(anData.timeStart, anData.pvmMean,'Color',[0 0.5 0]);
% legend('HOLIMO','CDP','PVM');
% 
% %     [ax,h1,h2]= plotyy(anData.timeStart, nanmoving_average(rem(anData.measMeanAzimutSonic+180,360), meanNum),...
% %         anData.timeStart, nanmoving_average(anData.measMeanT, meanNum));
% %     hold(ax(1),'on')
% %     hold(ax(2),'on')
% %     scatter(ax(1),anData.timeStart, rem(anData.measMeanAzimutSonic+180,360),markerSize,'bx','lineWidth',scLineWidht);
% %     scatter(ax(2),anData.timeStart, anData.measMeanT, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
% 
% %    plot(ax(1), BTplotData.timeUTC, BTplotData.winddirection,'b--');
% %    plot(ax(2), BTplotData.timeUTC, BTplotData.temp,'--','Color',[0 0.5 0]);
% %set(get(ax(1),'Ylabel'),'String',{'Wind Direction', 'Azimut [°]'},'fontsize',18,'lineWidth',scLineWidht,'Color','b');
% %set(get(ax(2),'Ylabel'),'String',{'Air Temperature', '[°C]'},'fontsize',18,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
% 
% 
% 
% 
% set(get(gca,'Ylabel'),'String',{'Water Content', 'Total [g*m^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color','k');
% set(gca,'XLim',anData2{1}.plotXLim,'XTick',plotXTick,'XTickLabel',[]);
% %    'YLim',[0 360],'YTick',[0 90 180 270 360]);
% %     set(ax(2),'XLim',anData2{1}.plotXLim,'XTick',plotXTick,'XTickLabel',[]);
% %     %    'YLim',[-10 -6],'YTick',[-10 -9 -8 -7 -6]);
% 
% set(gca,'XTickLabel',[]);
% %     set(ax(2),'XTickLabel',[]);
% 
% 
% set(gcf, 'PaperUnits','centimeters');
% set(gcf, 'PaperPosition',[0 0 30 20]);
% set(gcf, 'PaperSize', [30 20]);
