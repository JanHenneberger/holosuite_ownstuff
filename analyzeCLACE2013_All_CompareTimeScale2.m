

if ~exist('allDataRaw','var');
    
    allDataRaw = load('cleanTimeSerieN2.mat');
    allDataRaw = allDataRaw.anDataOut;
    
    for cnt = 1:numel(allDataRaw)
        meanIntervall(cnt) = allDataRaw{cnt}.meanIntervall;
    end
    [~, sortInd]=sort(meanIntervall);
    allDataRaw= allDataRaw(sortInd);
    meanIntervall= meanIntervall(sortInd);
    clear sortInd
    
end


%choose Data
%choosenInd = [1 2 4 6 10 11 12 13 17];
%choosenInd = [2 7 11];
choosenInd = [1 2 3];
allData = allDataRaw(1,choosenInd);
allIntervall = meanIntervall(choosenInd);
%sort out intervall with to less data or difference between LWC/IWC/TWC
clear meanNumberReal validIntervallPerc
for cnt = 1:numel(allData)
    meanNumberReal(cnt) = mean(allData{cnt}.NumberReal);
    cond1 = allData{cnt}.NumberReal >= 0.2*meanNumberReal(cnt);
    cond2 = allData{cnt}.NumberReal > 10;
    cond3 = (allData{cnt}.TWContent-allData{cnt}.LWContent- allData{cnt}.IWContent)./allData{cnt}.TWContent <.5;
    cond4 = (allData{cnt}.TWContent-allData{cnt}.LWContent- allData{cnt}.IWContent) <.3;
    allData{cnt}.isValidIntervall =  cond1 & cond2 & cond3 & cond4;
    
    validIntervallPerc(1,cnt) = sum(cond1/numel(allData{cnt}.isValidIntervall));
    validIntervallPerc(2,cnt) = sum(cond2/numel(allData{cnt}.isValidIntervall));
    validIntervallPerc(3,cnt) = sum(cond3/numel(allData{cnt}.isValidIntervall));
    validIntervallPerc(4,cnt) = sum(cond4/numel(allData{cnt}.isValidIntervall));
    validIntervallPerc(5,cnt) = sum(allData{cnt}.isValidIntervall)/numel(allData{cnt}.isValidIntervall);
    
end
if 0
    figure(99)
    plot(1:size(validIntervallPerc,2),validIntervallPerc(1,:),...
        1:size(validIntervallPerc,2),validIntervallPerc(2,:),...
        1:size(validIntervallPerc,2),validIntervallPerc(3,:),...
        1:size(validIntervallPerc,2),validIntervallPerc(4,:),...
        1:size(validIntervallPerc,2),validIntervallPerc(5,:))
    legend({'minRealNum','minAbsNum','minRelDiff','minAbsDiff','All'})
end



chooseCase =12;
plotXLimAll(1,:)  = [datenum([2013 1 29 0 0 0]) datenum([2013 1 30 0 0 0])];
plotXLimAll(2,:)  = [datenum([2013 2 4 9 0 0]) datenum([2013 2 4 12 0 0])];
plotXLimAll(3,:)  = [datenum([2013 2 4 12 0 0]) datenum([2013 2 4 23 0 0])];
plotXLimAll(4,:)  = [datenum([2013 2 5 0 0 0]) datenum([2013 2 5 23 0 0])];
plotXLimAll(5,:)  = [datenum([2013 2 7 0 0 0]) datenum([2013 2 7 15 0 0])];
plotXLimAll(6,:)  = [datenum([2013 2 7 15 0 0]) datenum([2013 2 7 19 0 0])];
plotXLimAll(7,:)  = [datenum([2013 2 7 21 3 20]) datenum([2013 2 7 21 8 0])];
plotXLimAll(8,:)  = [datenum([2013 2 7 21 30 0]) datenum([2013 2 8 0 0 0])];
plotXLimAll(9,:)  = [datenum([2013 2 11 0 0 0]) datenum([2013 2 11 15 30 0])];
plotXLimAll(10,:)  = [datenum([2013 2 11 15 30 0]) datenum([2013 2 11 17 0 0])];
plotXLimAll(11,:)  = [datenum([2013 2 11 17 0 0]) datenum([2013 2 12 0 0 0])];
plotXLimAll(12,:)  = [datenum([2013 2 12 0 0 0]) datenum([2013 2 13 0 0 0])];
plotXLimRaw = plotXLimAll(chooseCase,:);

clear anData2
for cnt = 1:numel(allData)
    anData2{cnt}.plotXLimInd = [find(allData{cnt}.timeStart >= plotXLimRaw(1),1,'first') find(allData{cnt}.timeStart <= plotXLimRaw(2),1,'last')];
    
    if numel(anData2{cnt}.plotXLimInd)==1
        anData2{cnt}.plotXLimInd = [1 1];
    end
    anData2{cnt}.plotXLim = [allData{cnt}.timeStart(anData2{cnt}.plotXLimInd(1)),...
        allData{cnt}.timeStart(anData2{cnt}.plotXLimInd(2))];
end
if 0
    figure(5)
    caseforPlot = 2;
    histfit(allData{caseforPlot}.LWCount(...
        anData2{caseforPlot}.plotXLimInd(1):anData2{caseforPlot}.plotXLimInd(2))...
        ,20,'poisson');
    dfittool(allData{caseforPlot}.LWCountRaw(...
        anData2{caseforPlot}.plotXLimInd(1):anData2{caseforPlot}.plotXLimInd(2)));
end


if 0
    figure(2)
    set(gcf,'DefaultAxesFontSize',12);
    subplot(3,4,1)
    clear data  
    clear dataLimit
    for cnt = 1:numel(allData)
       data{cnt} = allData{cnt}.TWConcentraction(allData{cnt}.isValidIntervall);
       dataLimit(cnt) = 1/mean(allData{cnt}.sampleVolumeReal)/1000000;
    end
    
    plotDependencyOnIntervall2(data, allIntervall, dataLimit)
    set(gca,'YScale','log')
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    set(gca,'YLim',[dataLimit(5) 2e2])
    ylabel('Total Conc. [cm^{-3}]')
    set(gca, 'Layer','top')
    box on
    
    subplot(3,4,2)
    clear data  
    for cnt = 1:numel(allData)
       data{cnt} = allData{cnt}.LWConcentraction(allData{cnt}.isValidIntervall);
       dataLimit(cnt) = 1/mean(allData{cnt}.sampleVolumeReal)/1000000;
    end
    plotDependencyOnIntervall2(data, allIntervall, dataLimit)
    set(gca,'YScale','log')
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    set(gca,'YLim',[dataLimit(5) 2e2])
    ylabel('Liquid Conc. [cm^{-3}]')
        set(gca, 'Layer','top')
    box on
    
    subplot(3,4,3)
    clear data  
    for cnt = 1:numel(allData)
       data{cnt} = allData{cnt}.IWConcentraction(allData{cnt}.isValidIntervall);
       dataLimit(cnt) = 1/mean(allData{cnt}.sampleVolumeReal)/1000000;
    end
    plotDependencyOnIntervall2(data, allIntervall, dataLimit)
    set(gca,'YScale','log')
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    set(gca,'YLim',[dataLimit(5) 5e0])
    ylabel('Ice Conc. [cm^{-3}]')
        set(gca, 'Layer','top')
    box on
    
    subplot(3,4,4)
    clear data  
    for cnt = 1:numel(allData)
       data{cnt} = allData{cnt}.IWConcentraction(allData{cnt}.isValidIntervall)./...
           allData{cnt}.TWConcentraction(allData{cnt}.isValidIntervall);
       dataLimit(cnt) = 1/mean(allData{cnt}.LWCountRaw);
    end
    plotDependencyOnIntervall2(data, allIntervall, dataLimit)
    ylabel('Ice/Total Conc.')
    set(gca,'YScale','log')
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    set(gca,'YLim',[dataLimit(5) 1.05])    
        set(gca, 'Layer','top')
    box on
    
    subplot(3,4,5)
    clear data  
    for cnt = 1:numel(allData)
       data{cnt} = allData{cnt}.TWContent(allData{cnt}.isValidIntervall);
       dataLimit(cnt) = 1/mean(allData{cnt}.sampleVolumeReal)*6/pi*nanmean(allData{cnt}.TWMeanD)^3*1e6
    end
    plotDependencyOnIntervall2(data, allIntervall, dataLimit)
    ylabel('Total Content [g m^{-3}]')
    set(gca,'YScale','log')
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    set(gca,'YLim',[dataLimit(5) 1e0])   
        set(gca, 'Layer','top')
    box on
    
        subplot(3,4,6)
    clear data  
    for cnt = 1:numel(allData)
       data{cnt} = allData{cnt}.LWContent(allData{cnt}.isValidIntervall);
       dataLimit(cnt) = 1/mean(allData{cnt}.sampleVolumeReal)*6/pi*nanmean(allData{cnt}.LWMeanD)^3*1e6
    end
    plotDependencyOnIntervall2(data, allIntervall, dataLimit)
    ylabel('Liquid Content [g m^{-3}]')
    set(gca,'YScale','log')
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    set(gca,'YLim',[dataLimit(5) 1e0])  
        set(gca, 'Layer','top')
    box on
    
        subplot(3,4,7)
    clear data  
    for cnt = 1:numel(allData)
       data{cnt} = allData{cnt}.IWContent(allData{cnt}.isValidIntervall);
       dataLimit(cnt) = 1/mean(allData{cnt}.sampleVolumeReal)*6/pi*nanmean(allData{cnt}.IWMeanD)^3*1e6
    end
    plotDependencyOnIntervall2(data, allIntervall, dataLimit)
    ylabel('Ice Content [g m^{-3}]')
    set(gca,'YScale','log')
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    set(gca,'YLim',[dataLimit(5) 1e0])  
        set(gca, 'Layer','top')
    box on
    
    subplot(3,4,8)
    clear data
    for cnt = 1:numel(allData)
        data{cnt} = allData{cnt}.IWContent(allData{cnt}.isValidIntervall)./...
            allData{cnt}.TWContent(allData{cnt}.isValidIntervall);
        dataLimit(cnt) = 0;
    end
     plotDependencyOnIntervall2(data, allIntervall, dataLimit)
    ylabel('Ice/Total Content')
    set(gca,'YLim',[0 1.05])  
        set(gca, 'Layer','top')
    box on
    
    subplot(3,4,9)
    clear data  
    for cnt = 1:numel(allData)
       data{cnt} = allData{cnt}.TWMeanD(allData{cnt}.isValidIntervall)*1e6;
        dataLimit(cnt) = 0;
    end
     plotDependencyOnIntervall2(data, allIntervall, dataLimit)
    ylabel('mean diameter total [\mum]')
    set(gca,'YTick',[10 20 50 100 200])
    set(gca,'YLim',[6 250])
    set(gca,'YScale','log')
    set(gca, 'Layer','top')
    box on
    
        subplot(3,4,10)
    clear data  
    for cnt = 1:numel(allData)
       data{cnt} = allData{cnt}.LWMeanD(allData{cnt}.isValidIntervall)*1e6;
        dataLimit(cnt) = 0;
    end
     plotDependencyOnIntervall2(data, allIntervall, dataLimit)
    ylabel('mean diameter water [\mum]')
    set(gca,'YTick',[10 20 50 100 200])
    set(gca,'YLim',[6 250])
    set(gca,'YScale','log')
        set(gca, 'Layer','top')
    box on
    
        subplot(3,4,11)
    clear data  
    for cnt = 1:numel(allData)
       data{cnt} = allData{cnt}.IWMeanD(allData{cnt}.isValidIntervall)*1e6;
        dataLimit(cnt) = 0;
    end
     plotDependencyOnIntervall2(data, allIntervall, dataLimit)
    ylabel('mean diameter ice [\mum]')
    set(gca,'YTick',[10 20 50 100 200])
    set(gca,'YLim',[6 250])
    set(gca,'YScale','log')
        set(gca, 'Layer','top')
    box on
    
%         subplot(3,4,12)
%     clear data
%     for cnt = 1:numel(allData)
%         data{cnt} = allData{cnt}.LWContent(allData{cnt}.isValidIntervall)./...
%             allData{cnt}.TWContent(allData{cnt}.isValidIntervall);
%         dataLimit(cnt) = 0;
%     end
%      plotDependencyOnIntervall2(data, allIntervall, dataLimit)
%     ylabel('Liquid/Total Content')
%     set(gca,'YLim',[0 1.05])  
%     
%     subplot(3,4,11)
%     clear data  
%     for cnt = 1:numel(allData)
%        data{cnt} = allData{cnt}.measMeanV(allData{cnt}.isValidIntervall);
%     end
%     plotDependencyOnIntervall(data, allIntervall)
%     ylabel('wind velocity [m s^{-1}]')
    legend({'2% - 98%';'5% - 95%';'25% - 75%';'50%';'Mean';'Detection Limit'},'Location','NorthEast')
%     subplot(3,3,9)
%        clear data  
%     for cnt = 1:numel(allData)
%        data{cnt} = allData{cnt}.measMeanAzimutSonic(allData{cnt}.isValidIntervall);
%     end
%     plotDependencyOnIntervall(data, allIntervall)
%     ylabel('wind direction [°]')
    
end

%for dissertation
if 0
    figure(1)
    clf
    clear s;
    
    set(0,'DefaultAxesFontSize',11);
    set(0,'DefaultAxesLineWidth',1.2);
    set(gcf,'DefaultLineLineWidth',1.6);
    axnumber = 5;
    for m=1:axnumber
        axleft = 0.07;
        axright = 0.02;
        axtop = -.3;
        axbottom = 0.07;
        axgap = 0.02;
        axwidth = 1-axleft-axright;
        axheight = (1-axbottom-axtop)./axnumber-axgap*(axnumber-1);
        axPos(m,:) = [axleft axbottom+(m-1)*(axheight+axgap) axwidth axheight];
    end
    
    markerSize=40;
    scLineWidht=1;
    anParameter2.plotColors = cool(numel(allData));      
    
    s(5)=axes('position',axPos(1,:));
    hold on
    clear intString
    for cnt = 1:numel(allData)
        if cnt == 1
            scatter(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.IWContent(allData{cnt}.isValidIntervall)./allData{cnt}.TWContent(allData{cnt}.isValidIntervall), markerSize,'x','MarkerEdgeColor',[0 0.5 0]);
        else
            plot(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), ...
                allData{cnt}.IWContent(allData{cnt}.isValidIntervall)./allData{cnt}.TWContent(allData{cnt}.isValidIntervall),...
                '-x',...
                'Color',anParameter2.plotColors(cnt,:),...                
                'MarkerSize',8,...
                'MarkerFaceColor',anParameter2.plotColors(cnt,:),...
                'MarkerEdgeColor',anParameter2.plotColors(cnt,:));
        end
        intString{cnt} = [num2str(allIntervall(cnt)) ' s']
        hold on
    end      
    ylabel({'IWC/TWC'},'fontsize',10,'lineWidth',scLineWidht);
    set(gca,'XLim',anData2{1}.plotXLim,'XTickLabel',[],'YLim',[0 1],'YTick',[0 0.2 0.4 0.6 0.8 1]);
    xlabel([datestr(plotXLimAll(chooseCase,1),'yyyy/mm/dd') ' - Time (UTC) [h]']);
    datetick(gca,'x','HH-MM','keeplimits');
    legend(intString);
    box on
    
    s(4)=axes('position',axPos(2,:));
    hold on
    clear intString
    for cnt = 1:numel(allData)
        if cnt == 1
            scatter(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.TWContent(allData{cnt}.isValidIntervall), markerSize,'x','MarkerEdgeColor',[0 0.5 0]);
        else
            plot(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.TWContent(allData{cnt}.isValidIntervall),...
                '-x',...
                'Color',anParameter2.plotColors(cnt,:),...                
                'MarkerSize',8,...
                'MarkerFaceColor',anParameter2.plotColors(cnt,:),...
                'MarkerEdgeColor',anParameter2.plotColors(cnt,:));
        end
        intString{cnt} = [num2str(allIntervall(cnt)) ' s']
        hold on
    end
    
    ylabel({'TWC','[g*m^{-3}]'},'fontsize',10,'lineWidth',scLineWidht);
    %'YLim',[0 1],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    set(gca,'XLim',anData2{1}.plotXLim);%,'YLim',[0 .4]);%,'YTick',[0 .2 .4 .6 .8]);
    %xlabel('Time (UTC) [h]');
    datetick(gca,'x','HH-MM','keeplimits');
    set(gca,'XTickLabel',[]);
     legend(intString)
    box on
    
    s(3)=axes('position',axPos(3,:));
    hold on
    clear intString

    for cnt = 1:numel(allData)
        if cnt == 1
            scatter(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.IWConcentraction(allData{cnt}.isValidIntervall), markerSize,'x','MarkerEdgeColor',[0 0.5 0]);
        else
            plot(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.IWConcentraction(allData{cnt}.isValidIntervall),...
                '-x',...
                'Color',anParameter2.plotColors(cnt,:),...                
                'MarkerSize',8,...
                'MarkerFaceColor',anParameter2.plotColors(cnt,:),...
                'MarkerEdgeColor',anParameter2.plotColors(cnt,:));
        end
        intString{cnt} = [num2str(allIntervall(cnt)) ' s (n = ' num2str(mean(allData{cnt}.IWCount(anData2{cnt}.plotXLimInd(1):anData2{cnt}.plotXLimInd(2))), '%10.3g') ')']
        hold on
    end
    ylabel({'Number Conc.', 'Ice [cm^{-3}]'},'fontsize',10,'lineWidth',scLineWidht);
    
    %'YLim',[0 1],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    set(gca,'XLim',anData2{1}.plotXLim);%,'YLim',[0 3]);%,'YTick',[0 0.5 1 1.5 2 2.5]);
    %xlabel('Time (UTC) [h]');
    datetick(gca,'x','HH-MM','keeplimits');
    set(gca,'XTickLabel',[]);
     legend(intString)
    box on
    
    s(2)=axes('position',axPos(4,:));
    hold on
    clear intString
    for cnt = 1:numel(allData)
        if cnt == 1
            scatter(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.TWConcentraction(allData{cnt}.isValidIntervall), markerSize,'x','MarkerEdgeColor',[0 0.5 0]);
        else
            plot(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.TWConcentraction(allData{cnt}.isValidIntervall),...
                '-x',...
                'Color',anParameter2.plotColors(cnt,:),...                
                'MarkerSize',8,...
                'MarkerFaceColor',anParameter2.plotColors(cnt,:),...
                'MarkerEdgeColor',anParameter2.plotColors(cnt,:));
        end
        intString{cnt} = [num2str(allIntervall(cnt)) ' s (n = ' num2str(mean(allData{cnt}.TWCount(anData2{cnt}.plotXLimInd(1):anData2{cnt}.plotXLimInd(2))), '%10.3g') ')']
        hold on
    end      
    ylabel({'Number Conce.', 'Total [cm^{-3}]'},'fontsize',10,'lineWidth',scLineWidht);
    set(gca,'XLim',anData2{1}.plotXLim,'XTickLabel',[]);%,'YLim',[0 7]);%,'YTick',[0 0.5 1 1.5 2 2.5]);
    datetick(gca,'x','HH-MM','keeplimits');
     set(gca,'XTickLabel',[]);
         legend(intString,'Location','SouthEast')
    box on
    
    
    s(1)=axes('position',axPos(5,:));
    indForComp = 2;
    hold on    
    plot(allData{indForComp}.timeStart(allData{indForComp}.isValidIntervall), allData{indForComp}.TWContent(allData{indForComp}.isValidIntervall),'k');
    plot(allData{indForComp}.timeStart(allData{indForComp}.isValidIntervall), allData{indForComp}.LWContent(allData{indForComp}.isValidIntervall),'k--');
    plot(allData{indForComp}.timeStart, allData{indForComp}.cdpMean,'b');
    plot(allData{indForComp}.timeStart, allData{indForComp}.pvmMean,'Color',[0 0.5 0]); 
    legend('HOLIMO II TWC','HOLIMO II LWC','CDP','PVM-100');

    ylabel({'TWC', '[g*m^{-3}]'},'fontsize',10,'lineWidth',scLineWidht);
    set(gca,'XLim',anData2{1}.plotXLim,'XTickLabel',[]);%,'YLim',[0 3]);%,'YTick',[0 0.5 1 1.5 2 2.5]);
    datetick(gca,'x','HH-MM','keeplimits');
    set(gca,'XTickLabel',[]);
    box on
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 30 20]);
    set(gcf, 'PaperSize', [30 20]); 
    if 1
        fileName = [datestr(plotXLimAll(chooseCase,1),'yyyy-mm-dd-HH-MM') '-TimeSerie'];
        print('-dpdf','-r600', fullfile(pwd,fileName));
    end
end

%for talk
if 1
    figure(1)
    clf
    clear s;
    
    set(0,'DefaultAxesFontSize',18);
    set(0,'DefaultAxesLineWidth',1.2);
    set(gcf,'DefaultLineLineWidth',1.6);
    axnumber = 3;
    for m=1:axnumber
        axleft = 0.12;
        axright = 0.01;
        axtop = -0.11;
        axbottom = 0.08;
        axgap = 0.03;
        axwidth = 1-axleft-axright;
        axheight = (1-axbottom-axtop)./axnumber-axgap*(axnumber-1);
        axPos(m,:) = [axleft axbottom+(m-1)*(axheight+axgap) axwidth axheight];
    end
    
    markerSize=40;
    scLineWidht=1;
    anParameter2.plotColors = cool(numel(allData));      
    
    s(3)=axes('position',axPos(1,:));
    hold on
    clear intString
    for cnt = 1:numel(allData)
        if cnt == 1
            scatter(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.IWContent(allData{cnt}.isValidIntervall)./allData{cnt}.TWContent(allData{cnt}.isValidIntervall), markerSize,'x','MarkerEdgeColor',[0 0.5 0]);
        else
            plot(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), ...
                allData{cnt}.IWContent(allData{cnt}.isValidIntervall)./allData{cnt}.TWContent(allData{cnt}.isValidIntervall),...
                '-x',...
                'Color',anParameter2.plotColors(cnt,:),...                
                'MarkerSize',8,...
                'MarkerFaceColor',anParameter2.plotColors(cnt,:),...
                'MarkerEdgeColor',anParameter2.plotColors(cnt,:));
        end
        intString{cnt} = [num2str(allIntervall(cnt)) ' s']
        hold on
    end      
    ylabel({'IWC/TWC'},'fontsize',22,'lineWidth',scLineWidht);
    set(gca,'XLim',anData2{1}.plotXLim,'XTickLabel',[],'YLim',[0 1],'YTick',[0 0.2 0.4 0.6 0.8 1]);
    xlabel([datestr(plotXLimAll(chooseCase,1),'yyyy/mm/dd') ' - Time (UTC) [h]']);
    datetick(gca,'x','HH-MM','keeplimits');
    legend(intString);
    box on
    
 
    s(2)=axes('position',axPos(2,:));
    hold on
    clear intString

    for cnt = 1:numel(allData)
        if cnt == 1
            scatter(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.IWConcentraction(allData{cnt}.isValidIntervall), markerSize,'x','MarkerEdgeColor',[0 0.5 0]);
        else
            plot(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.IWConcentraction(allData{cnt}.isValidIntervall),...
                '-x',...
                'Color',anParameter2.plotColors(cnt,:),...                
                'MarkerSize',8,...
                'MarkerFaceColor',anParameter2.plotColors(cnt,:),...
                'MarkerEdgeColor',anParameter2.plotColors(cnt,:));
        end
        intString{cnt} = [num2str(allIntervall(cnt)) ' s (n = ' num2str(mean(allData{cnt}.IWCount(anData2{cnt}.plotXLimInd(1):anData2{cnt}.plotXLimInd(2))), '%10.3g') ')']
        hold on
    end
    ylabel({'Number Conc.', 'Ice [cm^{-3}]'},'fontsize',22,'lineWidth',scLineWidht);
    
    %'YLim',[0 1],'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6]);
    set(gca,'XLim',anData2{1}.plotXLim,'YLim',[0 3]);%,'YTick',[0 0.5 1 1.5 2 2.5]);
    %xlabel('Time (UTC) [h]');
    datetick(gca,'x','HH-MM','keeplimits');
    set(gca,'XTickLabel',[]);
     legend(intString)
    box on
    
    s(1)=axes('position',axPos(3,:));
    hold on
    clear intString
    for cnt = 1:numel(allData)
        if cnt == 1
            scatter(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.TWConcentraction(allData{cnt}.isValidIntervall), markerSize,'x','MarkerEdgeColor',[0 0.5 0]);
        else
            plot(allData{cnt}.timeStart(allData{cnt}.isValidIntervall), allData{cnt}.TWConcentraction(allData{cnt}.isValidIntervall),...
                '-x',...
                'Color',anParameter2.plotColors(cnt,:),...                
                'MarkerSize',8,...
                'MarkerFaceColor',anParameter2.plotColors(cnt,:),...
                'MarkerEdgeColor',anParameter2.plotColors(cnt,:));
        end
        intString{cnt} = [num2str(allIntervall(cnt)) ' s (n = ' num2str(mean(allData{cnt}.TWCount(anData2{cnt}.plotXLimInd(1):anData2{cnt}.plotXLimInd(2))), '%10.3g') ')']
        hold on
    end      
    ylabel({'Number Conc.', 'Total [cm^{-3}]'},'fontsize',22,'lineWidth',scLineWidht);
    set(gca,'XLim',anData2{1}.plotXLim,'XTickLabel',[],'YLim',[0 700]);%,'YTick',[0 0.5 1 1.5 2 2.5]);
    datetick(gca,'x','HH-MM','keeplimits');
     set(gca,'XTickLabel',[]);
         legend(intString,'Location','NorthEast')
    box on
    
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 30 20]);
    set(gcf, 'PaperSize', [30 20]); 
    if 1
        fileName = [datestr(plotXLimAll(chooseCase,1),'yyyy-mm-dd-HH-MM') '-TimeSerieTalk'];
        print('-dpdf','-r600', fullfile(pwd,fileName));
    end
end

if 0
    figure(3)
    clf
    
    indForSpectra = 2;%numel(allData);
    subplot(1,2,1,'replace')    
    hold on    
    plot(allData{indForSpectra}.Parameter.histBinMiddle, ...
        abs(nanmean(allData{indForSpectra}.water.histRealCor(:,anData2{1,indForSpectra}.plotXLimInd(1):anData2{1,indForSpectra}.plotXLimInd(2)),2)), ...
        'LineWidth',2,'Color','k');
    plot(allData{indForSpectra}.Parameter.histBinMiddle, abs(nanmean(allData{indForSpectra}.ice.histRealCor(:,anData2{1,indForSpectra}.plotXLimInd(1):anData2{1,indForSpectra}.plotXLimInd(2)),2)), ...
        'LineWidth',2,'LineStyle','--','Color','k');
%     errorbar(anParameter.histBinMiddle, anDataAll.water.histRealCor(:,cnt), ...
%         anDataAll.water.histRealErrorCor(:,cnt),...
%         'color', anParameter.plotColorNew(cnt-anParameter.minPlotIntervall+1,:),...
%         'LineWidth',2);
    h_legend = legend({'HS2013 water','HS2013 ice'}, 'Location', 'NorthEast');
    set(h_legend,'FontSize',9);
    ylabel('number density d(N)/d(log d) [cm^{-3}]');
    xlabel('diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    title([datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'dd/mm/yyyy') ' ' ...
        datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'HH:MM') '-'...
        datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(2)),'HH:MM')]);
    xlim(gca, [6 allData{indForSpectra}.Parameter.maxSize]);
    ylim(gca, [2e-2 8e2]);
    box on
        

    subplot(1,2,2,'replace')   
    hold on  
        
      
    plot(allData{indForSpectra}.Parameter.histBinMiddle, abs(nanmean(allData{indForSpectra}.water.histRealCor(:,anData2{1,indForSpectra}.plotXLimInd(1):anData2{1,indForSpectra}.plotXLimInd(2))'.*...
        repmat((1/6*pi.*allData{indForSpectra}.Parameter.histBinMiddle.^3),size(allData{indForSpectra}.water.histRealCor(:,anData2{1,indForSpectra}.plotXLimInd(1):anData2{1,indForSpectra}.plotXLimInd(2)),2),1))), ...
        'LineWidth',2,'Color','k');
    plot(allData{indForSpectra}.Parameter.histBinMiddle, abs(nanmean(allData{indForSpectra}.ice.histRealCor(:,anData2{1,indForSpectra}.plotXLimInd(1):anData2{1,indForSpectra}.plotXLimInd(2))'.*...
        repmat((1/6*pi.*allData{indForSpectra}.Parameter.histBinMiddle.^3),size(allData{indForSpectra}.water.histRealCor(:,anData2{1,indForSpectra}.plotXLimInd(1):anData2{1,indForSpectra}.plotXLimInd(2)),2),1))), ...
        'LineWidth',2,'LineStyle','--','Color','k');
    
    h_legend = legend({'HS2013 water','HS2013 ice'}, 'Location', 'NorthEast');
    
    set(h_legend,'FontSize',9);
    ylabel('volume density d(N)/d(log d) [cm^{-3}\mum^{3}]');
    xlabel('diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
        title([datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'dd/mm/yyyy') ' ' ...
        datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'HH:MM') '-'...
        datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(2)),'HH:MM')]);
    xlim(gca, [6 allData{indForSpectra}.Parameter.maxSize]);
    ylim(gca,[5e2 5e6]);
    box on;

    
        set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1.2 0.1 21 9.8]);
    set(gcf, 'PaperSize', [18 9.9]); 
    if 1
        fileName = [datestr(plotXLimAll(chooseCase,1),'yyyy-mm-dd-HH-MM') '-Spectra'];
        print('-dpdf','-r600', fullfile(pwd,fileName));
    end
end
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
% 'T'
% nanmean(allData{indForSpectra}.measMeanT...
%     (anData2{1,indForSpectra}.plotXLimInd(1):...
%     anData2{1,indForSpectra}.plotXLimInd(2)))
% nanstd(allData{indForSpectra}.measMeanT...
%     (anData2{1,indForSpectra}.plotXLimInd(1):...
%     anData2{1,indForSpectra}.plotXLimInd(2)))
% 'V'
% nanmean(allData{indForSpectra}.measMeanV...
%     (anData2{1,indForSpectra}.plotXLimInd(1):...
%     anData2{1,indForSpectra}.plotXLimInd(2)))
% nanstd(allData{indForSpectra}.measMeanV...
%     (anData2{1,indForSpectra}.plotXLimInd(1):...
%     anData2{1,indForSpectra}.plotXLimInd(2)))
% 'TWC'
% tmp = allData{indForSpectra}.TWContent...
%     (anData2{1,indForSpectra}.plotXLimInd(1):...
%     anData2{1,indForSpectra}.plotXLimInd(2));
% tmp(~isfinite(tmp)) = [];
% 1000*nanmean(tmp)
% 
% 'LWC'
% tmp = allData{indForSpectra}.LWContent...
%     (anData2{1,indForSpectra}.plotXLimInd(1):...
%     anData2{1,indForSpectra}.plotXLimInd(2));
% tmp(~isfinite(tmp)) = [];
% 1000*nanmean(tmp)
% 
% 'IWC'
% tmp = allData{indForSpectra}.IWContent...
%     (anData2{1,indForSpectra}.plotXLimInd(1):...
%     anData2{1,indForSpectra}.plotXLimInd(2));
% tmp(~isfinite(tmp)) = [];
% 1000*nanmean(tmp)
