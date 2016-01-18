for cnt = 1:numel(anData.sample)
    sampleVolumeReal(cnt)=anData.sample{1,cnt}.VolumeReal;
end

chooseDay = 6;
plotXLimRaw  = [datenum([2013 2 chooseDay 0 0 0]) datenum([2013 2 chooseDay+1 0 0 0])];
plotXLimInd = [find(anData.timeStart >= plotXLimRaw(1),1,'first') find(anData.timeStart <= plotXLimRaw(2),1,'last')];
plotXLim = [anData.timeStart(plotXLimInd(1)),...
    anData.timeStart(plotXLimInd(2))];
figure(1)
clf
%n = ceil(intervall);
clear s;

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

meanNum = 20;
markerSize=60;
scLineWidht = 1;

anData.TWConcentraction(isnan(anData.TWConcentraction))=0;
anData.IWConcentraction(isnan(anData.IWConcentraction))=0;
anData.LWConcentraction(isnan(anData.LWConcentraction))=0;
anData.TWConcentraction(isinf(anData.TWConcentraction))=max(anData.TWConcentraction(isfinite(anData.TWConcentraction)));
anData.IWConcentraction(isinf(anData.IWConcentraction))=max(anData.IWConcentraction(isfinite(anData.IWConcentraction)));
anData.LWConcentraction(isinf(anData.LWConcentraction))=max(anData.LWConcentraction(isfinite(anData.LWConcentraction)));

anData.TWContent(isnan(anData.TWContent))=0;
anData.IWContent(isnan(anData.IWContent))=0;
anData.LWContent(isnan(anData.LWContent))=0;
anData.TWContent(isinf(anData.TWContent))=max(anData.TWContent(isfinite(anData.TWContent)));
anData.IWContent(isinf(anData.IWContent))=max(anData.IWContent(isfinite(anData.IWContent)));
anData.LWContent(isinf(anData.LWContent))=max(anData.LWContent(isfinite(anData.LWContent)));

anData.TWError = anData.TWCountRaw.^(-0.5);
anData.LWError = anData.LWCountRaw.^(-0.5);
anData.IWError = anData.IWCountRaw.^(-0.5);

anData.TWError(isinf(anData.TWError)) = max(anData.TWError(isfinite(anData.TWError)));
anData.LWError(isinf(anData.LWError)) = max(anData.LWError(isfinite(anData.LWError)));
anData.IWError(isinf(anData.IWError)) = max(anData.IWError(isfinite(anData.IWError)));

anData.TWErrorMean = nanmoving_average(anData.TWCountRaw,meanNum,2,1).^(-0.5);
anData.LWErrorMean = nanmoving_average(anData.LWCountRaw,meanNum,2,1).^(-0.5);
anData.IWErrorMean = nanmoving_average(anData.IWCountRaw,meanNum,2,1).^(-0.5);

anData.TWErrorMean(isinf(anData.TWErrorMean)) = max(anData.TWErrorMean(isfinite(anData.TWErrorMean)));
anData.LWErrorMean(isinf(anData.LWErrorMean)) = max(anData.LWErrorMean(isfinite(anData.LWErrorMean)));
anData.IWErrorMean(isinf(anData.IWErrorMean)) = max(anData.IWErrorMean(isfinite(anData.IWErrorMean)));

% for cnt2 = 1:numel(anData.sample)
%     anData.sampleVolume(cnt2)=anData.sample{cnt2}.VolumeReal;
% end
% anData.sampleVolumeMean = nanmoving_average(anData.sampleVolume,meanNum);
% 
% anData.TWconstantD = nanmoving_average(pi/6*anData.TWMeanD.^3,meanNum);
% anData.LWconstantD = nanmoving_average(pi/6*anData.TWMeanD.^3,meanNum);
% anData.IWconstantD = nanmoving_average(pi/6*anData.TWMeanD.^3,meanNum);
% 
% anData.TWconstantD(isinf(anData.TWconstantD)) = 0;
% anData.LWconstantD(isinf(anData.LWconstantD)) = 0;
% anData.IWconstantD(isinf(anData.IWconstantD)) = 0;
% 
% anData.TWContentMean = anData.TWconstantD.*nanmoving_average(anData.TWCount,meanNum)./...
%     anData.sampleVolumeMean;
% anData.LWContentMean = anData.LWconstantD.*nanmoving_average(anData.LWCount,meanNum)./...
%     anData.sampleVolumeMean;
% anData.IWContentMean = anData.IWconstantD.*nanmoving_average(anData.IWCount,meanNum)./...
%     anData.sampleVolumeMean;



s(3)=axes('position',axPos(1,:));
[ax,h1,h2]= plotyy(anData.timeStart, nanmoving_average(anData.LWContent,meanNum),...
    anData.timeStart, nanmoving_average(anData.IWContent,meanNum));
hold(ax(1),'on')
hold(ax(2),'on')

set(gcf,'CurrentAxes',ax(2))
lowerBound = (1-anData.IWErrorMean).*nanmoving_average(anData.IWContent,meanNum,2,1);
lowerBound = lowerBound(plotXLimInd(1):plotXLimInd(2));
upperBound = (1+anData.IWErrorMean).*nanmoving_average(anData.IWContent,meanNum,2,1);
upperBound = upperBound(plotXLimInd(1):plotXLimInd(2));
ciplot(lowerBound,...
     upperBound,...
     anData.timeStart(plotXLimInd(1):plotXLimInd(2)),[.7 1 .7]);

set(gcf,'CurrentAxes',ax(1))
lowerBound = (1-anData.LWErrorMean).*nanmoving_average(anData.LWContent,meanNum,2,1);
lowerBound = lowerBound(plotXLimInd(1):plotXLimInd(2));
upperBound = (1+anData.LWErrorMean).*nanmoving_average(anData.LWContent,meanNum,2,1);
upperBound = upperBound(plotXLimInd(1):plotXLimInd(2));
ciplot(lowerBound,...
     upperBound,...
     anData.timeStart(plotXLimInd(1):plotXLimInd(2)),[.7 .7 1]);
scatter(ax(1),anData.timeStart, anData.LWContent, ...
    markerSize,'bx','lineWidth',scLineWidht);
%    plot(ax(1), BTplotData.timeUTC, BTplotData.LWC,'b--');
%    plot(ax(2), BTplotData.timeUTC, BTplotData.IWC,'--','Color',[0 0.5 0]);
scatter(ax(2),anData.timeStart, anData.IWContent, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
set(get(ax(1),'Ylabel'),'String',{'Water Content', 'Liquid [g*m^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color','b');
set(get(ax(2),'Ylabel'),'String',{'Water Content', 'Ice [g*m^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
set(ax(1),'XLim',plotXLim);
%'YLim',[0 1],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
set(ax(2),'XLim',plotXLim,'XTickLabel',[]);%'YLim',[0 0.8],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);

xlabel('Time (UTC) [h]');
datetick(ax(1),'x','HH-MM','keeplimits');
datetick(ax(2),'x','HH-MM','keeplimits');
plotXTick = get(ax(1),'XTick');

s(2)=axes('position',axPos(2,:));
[ax, h1, h2]= plotyy(anData.timeStart, nanmoving_average(anData.LWConcentraction,meanNum),...
    anData.timeStart, nanmoving_average(anData.IWConcentraction*1000,meanNum));
hold(ax(1),'on')
hold(ax(2),'on')
set(gcf,'CurrentAxes',ax(2))
lowerBound = (1-anData.IWErrorMean).*nanmoving_average(anData.IWConcentraction,meanNum,2,1);
lowerBound = lowerBound(plotXLimInd(1):plotXLimInd(2));
upperBound = (1+anData.IWErrorMean).*nanmoving_average(anData.IWConcentraction,meanNum,2,1);
upperBound = upperBound(plotXLimInd(1):plotXLimInd(2));
ciplot(lowerBound*1000,...
     upperBound*1000,...
     anData.timeStart(plotXLimInd(1):plotXLimInd(2)),[.7 1 .7]);
%  ciplot(lowerBound*1000,...
%      upperBound*1000,...
%      anData.timeStart,[.7 1 .7]);
 xlim(plotXLimInd);
 
set(gcf,'CurrentAxes',ax(1))
lowerBound = (1-anData.LWErrorMean).*nanmoving_average(anData.LWConcentraction,meanNum,2,1);
lowerBound = lowerBound(plotXLimInd(1):plotXLimInd(2));
upperBound = (1+anData.LWErrorMean).*nanmoving_average(anData.LWConcentraction,meanNum,2,1);
upperBound = upperBound(plotXLimInd(1):plotXLimInd(2));
ciplot(lowerBound,...
     upperBound,...
     anData.timeStart(plotXLimInd(1):plotXLimInd(2)),[.7 .7 1]);
 
 % plot(ax(2), anData.timeStart, (1+anData.IWErrorMean).*nanmoving_average(anData.IWConcentraction*1000,meanNum),...
%     anData.timeStart, (1-anData.IWErrorMean).*nanmoving_average(anData.IWConcentraction*1000,meanNum));
scatter(ax(1),anData.timeStart, anData.LWConcentraction,markerSize,'bx','lineWidth',scLineWidht);
scatter(ax(2),anData.timeStart, anData.IWConcentraction*1000,markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);
set(get(ax(1),'Ylabel'),'String',{'Number Concentration', 'Liquid [cm^{-3}]'},'fontsize',18,'lineWidth',scLineWidht,'Color','b');
set(get(ax(2),'Ylabel'),'String',{'Number Concentration', 'Ice [l^{-1}]'},'fontsize',18,'lineWidth',scLineWidht,'Color',[0 0.5 0]);
set(ax(1),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %'YLim',[0 200],'YTick',[0 50 100 150 200 250 300 350 400 450]);
set(ax(2),'XLim',plotXLim,'XTick',plotXTick,'XTickLabel',[]);
    %'YLim',[0 2000],'YTick',[0 200 400 600 800 1000 1200 1400 1600 1800 2000 2200]);

s(1)=axes('position',axPos(3,:));
plot(anData.timeStart, nanmoving_average(anData.TWContent,meanNum),'k');
hold on
plot(anData.timeStart, anData.cdpMean,'b');
plot(anData.timeStart, anData.pvmMean,'Color',[0 0.5 0]);
legend('HOLIMO','CDP','PVM');

%     [ax,h1,h2]= plotyy(anData.timeStart, nanmoving_average(rem(anData.measMeanAzimutSonic+180,360), meanNum),...
%         anData.timeStart, nanmoving_average(anData.measMeanT, meanNum));
%     hold(ax(1),'on')
%     hold(ax(2),'on')
%     scatter(ax(1),anData.timeStart, rem(anData.measMeanAzimutSonic+180,360),markerSize,'bx','lineWidth',scLineWidht);
%     scatter(ax(2),anData.timeStart, anData.measMeanT, markerSize,'x','lineWidth',scLineWidht,'MarkerEdgeColor',[0 0.5 0]);

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
