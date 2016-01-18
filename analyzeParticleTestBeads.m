%% Start up
choosePlots = [1];
runNr = [8 52 53];

cd('F:\TestCaseBeads\ParticleStats');
set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);
if ~exist('data', 'var')
    HOLIMOfileNames = dir('*_ps.mat');
    HOLIMOfileNames = {HOLIMOfileNames.name};    
    for cnt = 1:numel(HOLIMOfileNames)
        tmp = load(HOLIMOfileNames{cnt});
        HOLIMOData{cnt} = tmp.dataParticle;
        clear tmp
        
        HOLIMOData{cnt}.sampleSize.x      = (HOLIMOData{cnt}.Nx - HOLIMOData{cnt}.parameter.borderPixel)*HOLIMOData{cnt}.cfg.dx;
        HOLIMOData{cnt}.sampleSize.y      = (HOLIMOData{cnt}.Ny - HOLIMOData{cnt}.parameter.borderPixel)*HOLIMOData{cnt}.cfg.dy;
        HOLIMOData{cnt}.sampleSize.z      = HOLIMOData{cnt}.parameter.lmaxZ - HOLIMOData{cnt}.parameter.lminZ;
        HOLIMOData{cnt}.sampleVolumeHolo  = HOLIMOData{cnt}.sampleSize.x * HOLIMOData{cnt}.sampleSize.y * HOLIMOData{cnt}.sampleSize.z;
        HOLIMOData{cnt}.sampleNumber      = HOLIMOData{cnt}.indHolo(end);
        HOLIMOData{cnt}.sampleVolumeAll   = HOLIMOData{cnt}.sampleVolumeHolo * HOLIMOData{cnt}.sampleNumber;
        
        nanParticleInd = find(isnan(HOLIMOData{cnt}.partIsSatelite));
        HOLIMOData{cnt}.partIsSatelite(nanParticleInd) = 1;
        HOLIMOData{cnt}.partIsBorder(nanParticleInd) = 1;
        
        HOLIMOData{cnt}.partIsReal     = ~HOLIMOData{cnt}.partIsSatelite & ~HOLIMOData{cnt}.partIsBorder;
        HOLIMOData{cnt}.realInd = find(HOLIMOData{cnt}.partIsReal);
        HOLIMOData{cnt}.timeVec = conTime2Vec(HOLIMOData{cnt}.timeHolo);
        
        indParticle = numel(HOLIMOData{cnt}.timeHolo);
        year = 2012;
        month = 11;
        
        temp1 = ones(1, indParticle)*year;
        temp2 = ones(1, indParticle)*month;
        temp3 = [temp1; temp2];
        HOLIMOData{cnt}.timeVec=[temp3; HOLIMOData{cnt}.timeVec];
%         %Shift HOLIMO timeVec 2h ahead
%         HOLIMOData{cnt}.timeVec=[HOLIMOData{cnt}.timeVec(1,:); HOLIMOData{cnt}.timeVec(2,:);
%             HOLIMOData{cnt}.timeVec(3,:); HOLIMOData{cnt}.timeVec(4,:)+2; HOLIMOData{cnt}.timeVec(5,:); ...
%             HOLIMOData{cnt}.timeVec(6,:); HOLIMOData{cnt}.timeVec(7,:)];
%         divideSize = 8;
%         maxSize = 30;
%         bigInd = 20;
%         
%         smallBorder = (( 0.5 : 2389.5)*HOLIMOData{cnt}.cfg.dx*HOLIMOData{cnt}.cfg.dy*4/pi).^(1/2)*1000000;
%         divideInd = find(smallBorder > divideSize, 1 ,'first');
%         bigBorder = logspace(log10(smallBorder(divideInd)),log10(maxSize),bigInd);
%         partBorder = [smallBorder(1:(divideInd-1)) bigBorder];
        partBorder = (( 0.5 : 99.5)*HOLIMOData{cnt}.cfg.dx*HOLIMOData{cnt}.cfg.dy*4/pi).^(1/2)*1000000;
        
        HOLIMOData{cnt}.partIs18 = HOLIMOData{cnt}.timeVec(4,:) == 12;
        HOLIMOData{cnt}.partIs06 = HOLIMOData{cnt}.timeVec(4,:) == 14;
        HOLIMOData{cnt}.partIs10 = HOLIMOData{cnt}.timeVec(4,:) == 15;
        [HOLIMOData{cnt}.histAll, HOLIMOData{cnt}.edges2, HOLIMOData{cnt}.middle2, HOLIMOData{cnt}.limit2] = ...
            histogram(HOLIMOData{cnt}.pDiam(HOLIMOData{cnt}.partIsReal)*1000000, ...
            HOLIMOData{cnt}.sampleVolumeAll, partBorder);
        HOLIMOData{cnt}.hist06 = histogram(HOLIMOData{cnt}.pDiam(HOLIMOData{cnt}.partIsReal & HOLIMOData{cnt}.partIs06)...
            *1000000, HOLIMOData{cnt}.sampleVolumeAll, partBorder);
        HOLIMOData{cnt}.hist10 = histogram(HOLIMOData{cnt}.pDiam(HOLIMOData{cnt}.partIsReal & HOLIMOData{cnt}.partIs10)...
            *1000000, HOLIMOData{cnt}.sampleVolumeAll, partBorder);
        HOLIMOData{cnt}.hist18 = histogram(HOLIMOData{cnt}.pDiam(HOLIMOData{cnt}.partIsReal & HOLIMOData{cnt}.partIs18)...
            *1000000, HOLIMOData{cnt}.sampleVolumeAll, partBorder);
        HOLIMO.int06(cnt) =  sum(HOLIMOData{cnt}.pDiam > 6e-6 & HOLIMOData{cnt}.partIs06);
        HOLIMO.int10(cnt) =  sum(HOLIMOData{cnt}.pDiam > 6e-6 & HOLIMOData{cnt}.partIs10);
        HOLIMO.int18(cnt) =  sum(HOLIMOData{cnt}.pDiam > 6e-6 & HOLIMOData{cnt}.partIs18);
        HOLIMO.intAll(cnt) =  sum(HOLIMOData{cnt}.pDiam > 6e-6);
        HOLIMO.ampThresh(cnt) = -HOLIMOData{cnt}.cfg.ampLowThresh;
        HOLIMO.phaseThresh(cnt) = HOLIMOData{cnt}.cfg.phaseHighThresh;
        HOLIMO.phaseThresh(HOLIMO.phaseThresh > 1) = 0;
    end
end


%% Histogram
if any(choosePlots == 1)
    a=figure(1);    
    clf
    hold on
    plotColor = ['r' 'g' 'b' 'c' 'm' 'y'];    
    set(0,'DefaultAxesLineStyleOrder',{'-','--',':'})
    clear handleGraph
    
    for cnt = 1:numel(runNr)    
    %handleGraph(1,runNr(cnt)) = plot(HOLIMOData{runNr(cnt)}.middle2, HOLIMOData{runNr(cnt)}.histAll, '-','Color',plotColor(cnt),'LineWidth',2);
    %handleGraph(1,runNr(cnt)) = plot(HOLIMOData{runNr(cnt)}.middle2, HOLIMOData{runNr(cnt)}.hist06./max(HOLIMOData{runNr(cnt)}.hist06), '--','Color',plotColor(cnt),'LineWidth',2);
    handleGraph(2,runNr(cnt)) = plot(HOLIMOData{runNr(cnt)}.middle2, HOLIMOData{runNr(cnt)}.hist10./max(HOLIMOData{runNr(cnt)}.hist10), '-','Color',plotColor(cnt),'LineWidth',2);
    
    %handleGraph(3,runNr(cnt)) = plot(HOLIMOData{runNr(cnt)}.middle2, HOLIMOData{runNr(cnt)}.hist18./max(HOLIMOData{runNr(cnt)}.hist18), '-.','Color',plotColor(cnt),'LineWidth',2);
    hGroup(runNr(cnt)) = hggroup;
    
    sum(HOLIMOData{runNr(cnt)}.middle2.*HOLIMOData{runNr(cnt)}.hist06)/sum(HOLIMOData{runNr(cnt)}.hist06)
    sum(HOLIMOData{runNr(cnt)}.middle2.*HOLIMOData{runNr(cnt)}.hist10)/sum(HOLIMOData{runNr(cnt)}.hist10)
    sum(HOLIMOData{runNr(cnt)}.middle2.*HOLIMOData{runNr(cnt)}.hist18)/sum(HOLIMOData{runNr(cnt)}.hist18)
    %     set(handleGraph(:,runNr(cnt)),'Parent',hGroup(runNr(cnt)));
%     set(get(get(hGroup(runNr(cnt)),'Annotation'),'LegendInformation'),...
%     'IconDisplayStyle','on'); 
    end
    
    
    hold off
    
%     line([6.29 6.29],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');
%     line([6.4 6.4],[0.001 100],'LineStyle','-','LineWidth',2,'Color','c');
%     line([6.51 6.51],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');
%     line([10.06 10.06],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');
    line([10.25 10.25],[0.001 100],'LineStyle','-','LineWidth',2,'Color','k');
%     line([10.44 10.44],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');
%     line([17.89 17.89],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');
%     line([18.23 18.23],[0.001 100],'LineStyle','-','LineWidth',2,'Color','c');
%     line([18.57 18.57],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');

   % title('Histogram');
%     legend('Org Amp', 'Org Phase', '8 Phase', '10 Phase' , '8 Amp', '10 Amp','.1 Phase','.15 Phase','.1 Amp','.15 Amp');
     legendString = [];
    colorName = {'red', 'green', 'blue', 'cyan', 'magenta', 'yellow'}; 
%     for  cnt = 1:numel(runNr) 
%         legendString = [legendString ''',''  minAmp: ' num2str(HOLIMOData{runNr(cnt)}.cfg.ampLowThresh, '%03d') ...
%              ', minPh/maxPh: ' num2str(HOLIMOData{runNr(cnt)}.cfg.phaseHighThresh, '%03.2f')];
%     end
%     legendString(1:3) = [];
%    eval(['legend(''' legendString ''',''Location'',''NorthOutside'')'])
legend('dz = 50 \mum','dz = 25 \mum','dz = 10 \mum','Location','NorthOutside');
    %legend('6 \mum','10 \mum','18 \mum');
    ylabel('Relative concentraction');
    xlabel('Diameter [\mum]')
    xlim([5 20]);
    %ylim([0 12]);
    ylim([1e-1 1.05]);
    %set(gca,'YScale','log');
    titleString = [];
    colorName = {'red', 'green', 'blue', 'cyan', 'magenta', 'yellow'}; 
    for  cnt = 1:numel(runNr) 
        titleString = [titleString ', \color{' colorName{cnt} '}' ... 
             'A: ' num2str(HOLIMOData{runNr(cnt)}.cfg.ampLowThresh, '%03d') ...
             ' Ph: ' num2str(HOLIMOData{runNr(cnt)}.cfg.phaseHighThresh, '%03.2f')];
    end
    titleString(1) = [];
    %title(titleString);
    %set(gca,'XScale','log');
    
%     set(gcf, 'Units', 'centimeters');
%     set(gcf, 'OuterPosition', [5 5 12 14]);
%     ax = get(gcf, 'CurrentAxes');
%     
%     % make it tight
%     ti = get(ax,'TightInset');
%     set(ax,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
%     
%     % adjust the papersize
%     set(ax,'units','centimeters');
%     pos = get(ax,'Position');
%     ti = get(ax,'TightInset');
%     set(gcf, 'PaperUnits','centimeters');
%     set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
%     set(gcf, 'PaperPositionMode', 'manual');
%     set(gcf, 'PaperPosition',[0 0  pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    
    %print('-dpng','-r600', [num2str(chooseDay) '_05_HistogrammNumberFog'])
end

%% Spatial Analysis
if any(choosePlots == 2)
figure(2);
clf;

subplot(3,2,1);
hold on;
data = HOLIMOData{runNr(1)};
[a b] = hist(data.xPos(data.partIsReal).*1e3,40);
% [c d] = hist(data.xPos(data.partIsRealAll).*1e3,b);
a = a./(sum(a)/numel(a))-1;
% c = c./(sum(c)/numel(c))-1;
% e = [a;c]';
bar(b,a)
% hold on
% bar(b,e)
xlim([-2.15 2.15]);
ylim([-.3 .3]);
title('Y position frequency');
xlabel('Y Position (mm)');
ylabel('Relative Count');

subplot(3,2,3);
hold on;
[a b] = hist(data.yPos(data.partIsReal).*1e3,40);
% [c d] = hist(data.yPos(data.partIsRealAll).*1e3,b);
a = a./(sum(a)/numel(a))-1;
% c = c./(sum(c)/numel(c))-1;
% e = [a;c]';
bar(b,a)
% hold on
% bar(b,e)
xlim([-1.6 1.6]);
ylim([-.3 .3]);
title('X position frequency');
xlabel('X Position (mm)');
ylabel('Relative Count');

subplot(3,2,5);
hold on;
[a b] = hist(data.zPos(data.partIsReal).*1e3,40);
% [c d] = hist(data.zPos(data.partIsRealAll).*1e3,b);
a = a./(sum(a)/numel(a))-1;
% c = c./(sum(c)/numel(c))-1;
% e = [a;c]';
bar(b,a)
% hold on
% bar(b,e)
ylim([-.5 .5]);
title('Z position frequency');
xlabel('Z Position (mm)');
ylabel('Relative Count');

subplot(3,2,[2 4 6]);
bln = 1e-3;
x = data.xPos(data.partIsReal);
y = data.yPos(data.partIsReal);
xrange = min(x):bln:max(x);
yrange = min(y):bln:max(y);
count = hist2([x;y]',xrange,yrange);
count = count./(sum(count(:))/numel(count)) - 1;
count = interp2(count,4);
[nx ny] = size(count);
xrange = linspace(min(x),max(x),nx).*1e3;
yrange = linspace(min(y),max(y),ny).*1e3;
%xrange = (xrange(2:end) - bln/2).*1e3; 
%yrange = (yrange(2:end) - bln/2).*1e3;
contourf(yrange,xrange,count);

title('Relative Frequency of Occurance');
xlabel('X position (mm)');
ylabel('Y position (mm)');
caxis([-.3 .3]);
end

%% Total Number of found Particles
if any(choosePlots == 3)
figure(3);
clf;
hold on

runs = 1:numel(runNr);
scatter(runs, HOLIMO.int06(runNr),'b','filled'); 
scatter(runs, HOLIMO.int10(runNr),'r','filled'); 
scatter(runs, HOLIMO.int18(runNr),'g','filled'); 
scatter(runs, HOLIMO.intAll(runNr),'y','filled'); 
xlim([0 numel(runNr)+1]);

xTicksString = [];
for  cnt = 1:numel(runNr)
    xTicksString = [xTicksString ; [num2str(HOLIMOData{runNr(cnt)}.cfg.ampLowThresh, '%03d') ...
        '/' num2str(HOLIMOData{runNr(cnt)}.cfg.phaseHighThresh, '%03.2f')]];
end
%xTicksString(1) = [];
set(gca,'XTick',runs);
set(gca,'XTickLabel',xTicksString);
legend('6 \mum','10 \mum','18 \mum', 'All');
ylabel('total count');
end

%% 3D Total Number of found Particles
if any(choosePlots == 4)
figure(4);
clf;
hold on

stem3(HOLIMO.ampThresh, HOLIMO.phaseThresh, HOLIMO.int06,'b','filled');
stem3(HOLIMO.ampThresh, HOLIMO.phaseThresh, HOLIMO.int10,'r','filled');
stem3(HOLIMO.ampThresh, HOLIMO.phaseThresh, HOLIMO.int18,'g','filled');
stem3(HOLIMO.ampThresh, HOLIMO.phaseThresh, HOLIMO.intAll,'y','filled');

legend('6 \mum','10 \mum','18 \mum', 'All');
xlabel('Amplitude Threshold');
ylabel('Phase Threshold');
zlabel('Total Count');
grid on
end

%% Total Number vs. Amplitude Threshold
if any(choosePlots == 5)
figure(5);
clf;
hold on

scatter(HOLIMO.ampThresh,  HOLIMO.int06,'b','filled');
scatter(HOLIMO.ampThresh,  HOLIMO.int10,'r','filled');
scatter(HOLIMO.ampThresh, HOLIMO.int18,'g','filled');
scatter(HOLIMO.ampThresh,  HOLIMO.intAll,'y','filled');

legend('6 \mum','10 \mum','18 \mum', 'All');
xlabel('Amplitude Threshold');
ylabel('Total Count');
grid on
end

%% Total Number vs. Phase Threshold
if any(choosePlots ==6)
figure(6);
clf;
hold on

scatter(HOLIMO.phaseThresh,  HOLIMO.int06,'b','filled');
scatter(HOLIMO.phaseThresh,  HOLIMO.int10,'r','filled');
scatter(HOLIMO.phaseThresh, HOLIMO.int18,'g','filled');
scatter(HOLIMO.phaseThresh,  HOLIMO.intAll,'y','filled');

legend('6 \mum','10 \mum','18 \mum', 'All');
xlabel('Phase Threshold');
ylabel('Total Count');
grid on
end