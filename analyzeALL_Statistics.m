if ~exist('anData','var');
    %Semptember analysis 
%      anData2012 = load('F:\All_09_2013\Clean_2012_100sec.mat');    
%      anData2013 = load('F:\All_09_2013\Clean_2013_100sec.mat');
%     anData2012 = anData2012.tmp;
%     anData2013 = anData2013.tmp;
    
    %old
    anData2012 = load('F:\ALLDATA\newHistogram\cleanTimeSerieN2012.mat');    
     anData2013 = load('F:\ALLDATA\newHistogram\cleanTimeSerieN2013.mat');
    
%     anData2012 = load('F:\ALLDATA\2012TimeSerie.mat');
     anData2012 = anData2012.anDataOut;
%     anData2013 = load('F:\ALLDATA\2013TimeSerie.mat');
    anData2013 = anData2013.anDataOut;
end

%merge the files
copyFields2012  = fieldnames(anData2012{1,1});
copyFields2013  = fieldnames(anData2013{1,2});
fieldInBoth = ismember(copyFields2013,copyFields2012);
for cnt2 = 1:numel(copyFields2013)
    if fieldInBoth(cnt2) && ~strcmp(copyFields2013{cnt2}, 'Parameter')
        anData.(copyFields2013{cnt2}) = [anData2013{1,2}.(copyFields2013{cnt2}) ...
            anData2012{1,1}.(copyFields2012{ismember(copyFields2012,copyFields2013{cnt2})})];
    end
end
anData.Parameter = anData2012{1}.Parameter;
tmp = anData.water;
anData.water = [];
anData.water.histReal = [tmp(1).histReal tmp(2).histReal];
anData.water.limit = [tmp(1).limit tmp(2).limit];
anData.water.histRealError = [tmp(1).histRealError tmp(2).histRealError];
anData.water.histRealCor = abs([tmp(1).histRealCor tmp(2).histRealCor]);
anData.water.histRealErrorCor = abs([tmp(1).histRealErrorCor tmp(2).histRealErrorCor]);

tmp = anData.ice;
anData.ice = [];
anData.ice.histReal = [tmp(1).histReal tmp(2).histReal];
anData.ice.limit = [tmp(1).limit tmp(2).limit];
anData.ice.histRealError = [tmp(1).histRealError tmp(2).histRealError];
anData.ice.histRealCor = abs([tmp(1).histRealCor tmp(2).histRealCor]);
anData.ice.histRealErrorCor = abs([tmp(1).histRealErrorCor tmp(2).histRealErrorCor]);

tmp = anData.artefact;
anData.artefact = [];
anData.artefact.histReal = [tmp(1).histReal tmp(2).histReal];
anData.artefact.limit = [tmp(1).limit tmp(2).limit];
anData.artefact.histRealError = [tmp(1).histRealError tmp(2).histRealError];
anData.artefact.histRealCor = abs([tmp(1).histRealCor tmp(2).histRealCor]);
anData.artefact.histRealErrorCor = abs([tmp(1).histRealErrorCor tmp(2).histRealErrorCor]);
% dataAll.pStats.nHoloAllAll = [dataAll.pStats.nHoloAllAll ...
%     temp.pStats.nHoloAll+dataAll.pStats.nHoloAllAll(end)];


%anData.LWConcentraction = anData.TWConcentraction;
set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);

% for cnt2 = 1:numel(anData.sample)
%     anData.Number(cnt2)=anData.sample{1,cnt2}.Number;
%     anData.NumberReal(cnt2)=anData.sample{1,cnt2}.NumberReal;
%     anData.sampleVolumeAll(cnt2)=anData.sample{1,cnt2}.VolumeAll;
%     anData.sampleVolumeReal(cnt2)=anData.sample{1,cnt2}.VolumeReal;
% end

X = [anData.measMeanT; ...
    anData.measMeanV;...
    log10(anData.meanD*1e6);...
    anData.TWConcentraction; ...
    anData.LWConcentraction; ...
    anData.IWConcentraction; ...
    anData.TWContent;...
    anData.LWContent;...
    anData.IWContent;...
    log10(anData.LWConcentraction./anData.TWConcentraction);...
    log10(anData.IWConcentraction./anData.TWConcentraction);...
    anData.LWContent./anData.TWContent;...
    anData.IWContent./anData.TWContent;...
    ]';
varNames = {'Air temperature [�C]'; ... %1
    'Air velocity [m s^{-1}]';...       %2
    'mean diameter [\mum]';...          %3
    'TW Conc. [cm^{-3}]';...            %4
    'LW Conc. [cm^{-3}]';...            %5
    'IW Conc. [cm^{-3}]';...            %6
    'TW Content [g m^{-3}]';...         %7
    'LW Content [g m^{-3}]';...         %8
    'IW Content [g m^{-3}]';...         %9
    'LW Conc./ TW Conc.';...            %10
    'IW Conc./ TW Conc.';...            %11
    'LW Content/ TW Content.';...       %12
    'IW Content/ TW Content';...        %13
    };
%Group by wind direction
isSouth= anData.measMeanAzimutSonic > 90 & anData.measMeanAzimutSonic < 270;
oWindDirection = ordinal(isSouth,{'South wind','North wind'},[1,0]);

%Group by all
isAll =ones(1,numel(anData.timeStart));
oAll = ordinal(isAll,{'All Data'},1);

%Group by IWC/TWC
Y = anData.IWContent./anData.TWContent;
edges = [0 .10 .20 .30 .40 .50 .60 .70 .80 .90 1];
labels={'0-10 %', '10-20 %','20-30 %','30-40 %','40-50 %','50-60 %',...
    '60-70 %','70-80 %','80-90 %','90-100 %'};
levels=([5 15 25 35 45 55 65 75 85 95]);
% edges = [0   .10   .30   .50   .70   .90 1.05];
% labels={'0.05', '20' ,'40','60','80','95'};
% levels=([5 20 40 60 80 95]);
oIceFraction=ordinal(Y,labels,[],edges);

%Group by wind velocity
Y = anData.measMeanV;
edges = [0 3 6 12 20];
labels={ '0-3 m/s'; '3-6 m/s';'6-12 m/s';'12-20 m/s'};
oWindV=ordinal(Y,labels,[],edges);
oWindV = droplevels(oWindV);

%Group by temperature
Y = anData.measMeanT;
edges = [-35 -30 -25 -20 -15 -10 -5 0];
labels={ '-3-30�C'; '-30-25�C'; '-25-20�C'; '-20-15�C'; '-15-10�C'; '-10-5�C'; '-5-0�C'};
oTemperature=ordinal(Y,labels,[],edges);

oTemperature = droplevels(oTemperature);

%Group by day
Y = anData.timeVecStart(3,:)+1000*(anData.timeVecStart(1,:)-2000)+100*anData.timeVecStart(2,:);
oDay=ordinal(Y);

%Group by year
Y = anData.timeVecStart(1,:);
oYear = ordinal(Y);

%Group by year
Y = anData.timeVecStart(2,:);
oMonth = ordinal(Y);

%KorolevData
korFrac = 5:10:95;
korData = [0.0658    0.0572    0.1902    0.2498    0.2626    0.4610    0.5144;...
    0.0187    0.0183    0.0300    0.0393    0.0284    0.0320    0.0464;...
    0.0110    0.0150    0.0204    0.0230    0.0193    0.0222    0.0321;...
    0.0058    0.0159    0.0184    0.0184    0.0169    0.0189    0.0279;...
    0.0116    0.0273    0.0193    0.0170    0.0179    0.0189    0.0271;...
    0.0168    0.0367    0.0383    0.0260    0.0257    0.0218    0.0291;...
    0.0471    0.0820    0.0675    0.0446    0.0423    0.0284    0.0327;...
    0.1303    0.1553    0.1137    0.0897    0.0771    0.0428    0.0402;...
    0.2490    0.2104    0.1529    0.1598    0.1333    0.0725    0.0581;...
    0.4439    0.3820    0.3493    0.3324    0.3765    0.2815    0.1922];
korData = korData*100;

%T-test
if 0
% c=anData.measMeanT;
% a = c(oWindDirection=='North wind');
% a(isnan(a))=[];
% a(~isfinite(a))=[];
% b = c(oWindDirection=='South wind');
% b(isnan(b))=[];
% b(~isfinite(b))=[];
% [h,p] =  lillietest(a)


y=anData.TWConcentraction;

choseData = ~isnan(y) & isfinite(y);
y=y(choseData);
[tmp1 tmp2 tmp3] = grpstats(y,oWindDirection(choseData),{'mean','std','meanci'})
normplot(y)
% d = [a b];
% normplot(d)
end
%wind rose
if 0
    figure(45)
    tmp = ones(1,numel(anData.measMeanAzimutSonic));
    tmp = anData.measMeanV
    wind_rose(anData.measMeanAzimutSonic+180,tmp,'dtype','meteo','bcolor','k','quad',3)
end
%ANOVA
if 0
    x = [anData.TWConcentraction' anData.LWConcentraction' anData.IWConcentraction'...
         (anData.IWConcentraction./anData.TWConcentraction)'...
         anData.TWContent' anData.LWContent' anData.IWContent' (anData.IWContent./anData.TWContent)'...
         anData.TWMeanD' anData.LWMeanD' anData.IWMeanD' anData.measMeanT']; 
y=anData.IWContent./anData.TWContent;
x=anData.measMeanT;
choseData = ~isnan(y) & isfinite(y)& y<=1 & y>=0;
x=x(choseData);
y=y(choseData);
y1 = droplevels(oIceFraction(choseData));
y2 = droplevels(oTemperature(choseData));
y3 = droplevels(oWindDirection(choseData));
%[p,table,stats]=anova1(x(choseData),oWindDirection(choseData));
[p table stats] =anovan(x,{y1 y2 y3},2,3,{'IceFraction';'Temperature';'WindDirection'});
[table2, chi2, p, factorvals] = crosstab(oIceFraction(choseData), oTemperature(choseData), oWindDirection(choseData));
aoctool(x,y,y3);

end

%Comparsion Manchester
if 0
    figure(12)
    subplot(1,2,1)
    hold on
    x=anData.cdpMean;
    y=anData.TWContent;
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
    x=anData.pvmMean;
    y=anData.TWContent;
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

%Ice Fraction Grouped by North/South
if 1
    figure(11)
    labels = getlabels(oWindDirection);
    frequency = summary(oWindDirection);
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    %dayString = {', 1 day',', 6 days'};
    dayString = {'',''};
    legendString = strcat(labels, freqString, dayString);
    plotColor = cool(numel(labels));
    hold on
    plot(korFrac,mean(korData,2),'--k','LineWidth',2)
    for cnt = 1:numel(labels)
        stat=tabulate(oIceFraction(oWindDirection==labels{cnt}));
        plot(levels,[stat{:,3}],'Color', plotColor(cnt,:),'LineWidth',2)
    end
    legend([{'Korolev (2003)'}, legendString])
    xlabel('IWC/TWC')
    ylabel('Frequency [%]')
    box on
end

%Ice Fraction Grouped by Temperature
if 0
    figure(10)
    choseWindDirection = 'North wind';
    choseData = oTemperature(oWindDirection == choseWindDirection);
    labels = getlabels(choseData);
    frequency = summary(choseData);
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    legendString = strcat(labels, freqString);
    plotColor = cool(numel(labels));
    stat=tabulate(oIceFraction(oWindDirection == choseWindDirection));
    
    plot(levels,cumsum([stat{:,3}]),'k','LineWidth',2.5)
    hold on
    for cnt = 1:numel(labels)
        stat=tabulate(oIceFraction(choseData==labels{cnt}));
        plot(levels,cumsum([stat{:,3}]),'Color', plotColor(cnt,:),'LineWidth',1.5)
    end
    
    
    plot(korFrac,cumsum(mean(korData,2)),'--k','LineWidth',2.5)
    for cnt = 1:numel(labels)
        plot(korFrac,cumsum(korData(:,cnt+2)),'lineStyle','--','Color', plotColor(cnt,:),'LineWidth',1.5)
    end
    
    legend([{'All Temp.'},legendString],'Location','NorthEastOutside')
    xlabel('IWC/TWC')
    ylabel('Cumulative probability [%]')
    ylim([-5,105])
    box on
    
    % tmp1 = anData.IWContent./anData.TWContent;
    % tmp1(isnan(tmp1))=0;
    % tmp1(isinf(tmp1))=0;
    %
    % tmp2 = anData.measMeanT;
    % aoctool(tmp1, tmp2,B);
    % anovan(tmp1,X,'Continuous',1:13,'varnames',varNames);
    
end

%Ice Fraction Grouped by Temperature
if 1
    figure(79)
    clear choseData
    labels = getlabels(oTemperature);
    frequency = summary(oTemperature);
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    legendString = strcat(labels, freqString);
    plotColor = jet(numel(labels));
    stat=tabulate(oIceFraction);
    
    plot(levels,cumsum([stat{:,3}]),'k','LineWidth',2.5)
    hold on
    for cnt = 1:numel(labels)
        stat=tabulate(oIceFraction(oTemperature==labels{cnt}));
        plot(levels,cumsum([stat{:,3}]),'Color', plotColor(cnt,:),'LineWidth',1.5)
    end
    
    
    plot(korFrac,cumsum(mean(korData,2)),'--k','LineWidth',2.5)
    for cnt = 1:numel(labels)
        plot(korFrac,cumsum(korData(:,cnt+2)),'lineStyle','--','Color', plotColor(cnt,:),'LineWidth',1.5)
    end
    
    legend([{'All Temp.'},legendString,{'Korolev (2003)'}],'Location','NorthEastOutside')
    xlabel('IWC/TWC')
    ylabel('Cumulative probability [%]')
    ylim([-5,105])
    box on
    
    % tmp1 = anData.IWContent./anData.TWContent;
    % tmp1(isnan(tmp1))=0;
    % tmp1(isinf(tmp1))=0;
    %
    % tmp2 = anData.measMeanT;
    % aoctool(tmp1, tmp2,B);
    % anovan(tmp1,X,'Continuous',1:13,'varnames',varNames);
    
end
%histograms group by something%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    figure(24)
    clear gcf
    hold on
    temp = droplevels(oWindDirection,'North wind');
    plotGroupBoxplots(anData, times(temp, oIceFraction));
    
    temp = droplevels(oWindDirection,'South wind');
    plotGroupBoxplots(anData, times(temp, oIceFraction));
end

%histograms group by something%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    figure(23)
    clear gcf
    plotGroupBoxplots(anData, oAll);
end

%histograms group by something%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    figure(21)
    clear gcf
    plotGroupBoxplots(anData, oYear);
end
%histograms group by something%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    figure(22)
    clear gcf 
    plotGroupBoxplots(anData, oMonth);
end

%histograms group by something%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    figure(15)
    clear gcf
    chosenData = oWindDirection == 'North wind' | oWindDirection == 'South wind';
    plotGroupBoxplotsWindV(anData, oWindV, chosenData);
end

%histograms group by something%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    figure(9)
    clear gcf
    chosenData = oWindDirection == 'South wind';
   plotGroupBoxplotsChosenD(anData, oIceFraction, chosenData);
end

%histograms group by something%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    figure(8)
    clear gcf
    plotGroupBoxplots(anData, oDay);
end
%histograms group by something%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    figure(7)
    clear gcf
   chosenData = oWindDirection == 'South wind';
    plotGroupBoxplotsChosenD(anData, oTemperature, chosenData);
    %plotGroupBoxplotsTemp(anData, oTemperature);
end
%histograms group by something%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    figure(6)
    clear gcf
    plotGroupBoxplotsWindD(anData, oWindDirection);
end

B=oTemperature;
if 0
    figure(5)
    [H, AX, BigAx] = plotmatrix(Y',X);
    Y = anData.measMeanT;
    set(get(AX(numel(AX)),'XLabel'),'String','Temperature [�C]');
    for cnt = 1:numel(AX)
        set(get(AX(cnt),'YLabel'),'String',varNames{cnt});
    end
end

if 0
    figure(4)
    choosenX = [1 3 7:9];
    choosenY = [1 3 7:9];
    choosenVarX = {varNames{choosenX}};
    choosenVarY = {varNames{choosenY}};
    %gplotmatrix(X(:,choosenX),X(:,choosenY),B,[],'o',4,'on','hist',choosenVarX, choosenVarY);
    gplotmatrix(X(:,choosenX),[],B,[],'o',4,'on','hist',choosenVarX, choosenVarX);
end

if 0
    figure(3)
    choosenX = [1 10:13];
    choosenY = [1 10:13];
    choosenVarX = {varNames{choosenX}};
    choosenVarY = {varNames{choosenY}};
    %gplotmatrix(X(:,choosenX),X(:,choosenY),B,[],'o',4,'on','hist',choosenVarX, choosenVarY);
    gplotmatrix(X(:,choosenX),[],B,[],'o',4,'on','hist',choosenVarX, choosenVarX);
end

if 0
    figure(2)
    choosenX = [1 4:6];
    choosenY = [1 4:6];
    choosenVarX = {varNames{choosenX}};
    choosenVarY = {varNames{choosenY}};
    %gplotmatrix(X(:,choosenX),X(:,choosenY),B,[],'o',4,'on','hist',choosenVarX, choosenVarY);
    gplotmatrix(X(:,choosenX),[],B,[],'o',4,'on','hist',choosenVarX, choosenVarX);
end

if 1
    figure(3)
    clf
    
    indForSpectra = 2%numel(allData);
    subplot(1,2,1,'replace')    
    hold on 
    
    plotData = anData.water.histRealCor;
    plotData(~isfinite(plotData)) = nan;
    p1 = plot(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2), ...
        'LineWidth',2,'Color','k');
    plotData = anData.ice.histRealCor;
    plotData(~isfinite(plotData)) = nan;
    p2 = plot(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2), ...
        'LineWidth',2,'LineStyle','--','Color','k');
   
%     
%     
%     plotData = anData.water.histRealCor(:,oWindDirection == 'North wind'& oDay ~= '13204');
%     plotData(~isfinite(plotData)) = nan;
%     p3 = plot(anData.Parameter.histBinMiddle, ...
%         nanmean(plotData,2), ...
%         'LineWidth',2,'Color','r');
    plotData = anData.ice.histRealCor(:,oWindDirection == 'North wind');
    plotData(~isfinite(plotData)) = nan;
    p4 = plot(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2), ...
        'LineWidth',2,'LineStyle','--','Color','r');
%     
%     plotData = anData.water.histRealCor(:,oWindDirection == 'North wind'& oDay == '13204');
%     plotData(~isfinite(plotData)) = nan;
%     p7 = plot(anData.Parameter.histBinMiddle, ...
%         nanmean(plotData,2), ...
%         'LineWidth',2,'LineStyle','-.','Color','r');
%     
        plotData = anData.water.histRealCor(:,oWindDirection == 'South wind');
    plotData(~isfinite(plotData)) = nan;
    p5 = plot(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2), ...
        'LineWidth',2,'Color',[0 0.8 0]);
%     plotData = anData.ice.histRealCor(:,oWindDirection == 'South wind');
%     plotData(~isfinite(plotData)) = nan;
%     p6 = plot(anData.Parameter.histBinMiddle, ...
%         nanmean(plotData,2), ...
%         'LineWidth',2,'LineStyle','--','Color',[0 0.8 0]);
    %     errorbar(anParameter.histBinMiddle, anDataAll.water.histRealCor(:,cnt), ...
    %         anDataAll.water.histRealErrorCor(:,cnt),...
    %         'color', anParameter.plotColorNew(cnt-anParameter.minPlotIntervall+1,:),...
    %         'LineWidth',2);
   %h_legend = legend([p1 p3 p5 p7 p2 p4 p6], {'Liquid - All cases',...
%         'Liquid - North wind', 'Liquid - South wind', ...
%         'Liquid - 2013/02/04',...
%         'Ice - All cases', 'Ice - North wind',...
%         'Ice - South wind'}, 'Location', 'NorthEast');
       h_legend = legend({'Liquid - All cases', 'Ice - All cases'}, 'Location', 'NorthEast');
    set(h_legend,'FontSize',11);
    ylabel('Number density d(N)/d(log d) [cm^{-3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
    %title([datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'dd/mm/yyyy') ' ' ...
    %    datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'HH:MM') '-'...
    %    datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(2)),'HH:MM')]);
    xlim(gca, [6 250]);
    ylim(gca, [8e-3 3e2]);
    set(gca,'XTick',[10 20 50 100 200])
    set(gca,'YTick',[1e-2 1e-1 1e0 1e1 1e2])
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    box on
        

    subplot(1,2,2,'replace')   
    hold on  
        
    plotData = anData.water.histRealCor;
    plotData(~isfinite(plotData)) = nan;
    plot(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2)'.*...
       (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
        'LineWidth',2,'Color','k');
    plotData = anData.ice.histRealCor;
    plotData(~isfinite(plotData)) = nan;
    plot(anData.Parameter.histBinMiddle, ...
        nanmean(plotData,2)'.*...
       (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
        'LineWidth',2,'LineStyle','--','Color','k');
    
%         plotData = anData.water.histRealCor(:,oWindDirection == 'North wind'& oDay ~= '13204');
%     plotData(~isfinite(plotData)) = nan;
%     plot(anData.Parameter.histBinMiddle, ...
%         nanmean(plotData,2)'.*...
%        (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
%         'LineWidth',2,'Color','r');
%     plotData = anData.ice.histRealCor(:,oWindDirection == 'North wind');
%     plotData(~isfinite(plotData)) = nan;
%     plot(anData.Parameter.histBinMiddle, ...
%         nanmean(plotData,2)'.*...
%        (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
%         'LineWidth',2,'LineStyle','--','Color','r');

%             plotData = anData.water.histRealCor(:,oWindDirection == 'North wind'& oDay == '13204');
%     plotData(~isfinite(plotData)) = nan;
%     plot(anData.Parameter.histBinMiddle, ...
%         nanmean(plotData,2)'.*...
%        (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
%         'LineWidth',2,'LineStyle','-.','Color','r');
    
%             plotData = anData.water.histRealCor(:,oWindDirection == 'South wind');
%     plotData(~isfinite(plotData)) = nan;
%     plot(anData.Parameter.histBinMiddle, ...
%         nanmean(plotData,2)'.*...
%        (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
%         'LineWidth',2,'Color',[0 0.8 0]);
%     plotData = anData.ice.histRealCor(:,oWindDirection == 'South wind');
%     plotData(~isfinite(plotData)) = nan;
%     plot(anData.Parameter.histBinMiddle, ...
%         nanmean(plotData,2)'.*...
%        (1/6*pi.*anData.Parameter.histBinMiddle.^3), ...
%         'LineWidth',2,'LineStyle','--','Color',[0 0.8 0]);
    
    
    %h_legend = legend({'Liquid','Ice'}, 'Location', 'NorthEast');
    
    %set(h_legend,'FontSize',9);
    ylabel('Volume density d(N)/d(log d) [cm^{-3} \mum^{3}]');
    xlabel('Diameter [\mum]')
    set(gca,'YScale','log');
    set(gca,'XScale','log');
%         title([datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'dd/mm/yyyy') ' ' ...
%         datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(1)),'HH:MM') '-'...
%         datestr(allData{2}.timeStart(anData2{1,indForSpectra}.plotXLimInd(2)),'HH:MM')]);
    xlim(gca, [6 250]);
    ylim(gca,[1.9e3 2e5]);
    set(gca,'XTick',[10 20 50 100 200])
    set(gca,'YTickLabel',{'2e3','5e3','1e4','2e4','5e4','1e5'},...
    'YTick',[2000 5000 10000 20000 50000 100000]);
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    box on;

    
        set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1.2 0.1 21 9.8]);
    set(gcf, 'PaperSize', [18 9.9]); 
    if 0
        fileName = [datestr(plotXLimAll(chooseCase,1),'yyyy-mm-dd-HH-MM') '-Spectra'];
        print('-dpdf','-r600', fullfile(pwd,fileName));
    end
end

%Single Days
% tmpInd = oDay == '12501';
%tmpInd = oWindDirection == 'North wind' & oDay ~= '13204';
tmpInd = oWindDirection == 'South wind';
%tmpInd = true(1,numel(oDay));
% 'T'
% nanmean(anData.measMeanT(tmpInd))
% nanstd(anData.measMeanT(tmpInd))
%quantile(anData.measMeanT(tmpInd), [0.05 0.25 0.5 0.75 0.95])
% 'V'
% nanmean(anData.measMeanV(tmpInd))
% nanstd(anData.measMeanV(tmpInd))
% 'Total conc'
% tmp = anData.TWConcentraction(tmpInd);
% tmp(~isfinite(tmp)) = [];
% quantile(tmp, [0.05 0.25 0.5 0.75 0.95])
% nanmean(tmp)
% 
% 'Liquid conc'
% tmp = anData.LWConcentraction(tmpInd);
% tmp(~isfinite(tmp)) = [];
% quantile(tmp, [0.05 0.25 0.5 0.75 0.95])
% nanmean(tmp)
% nanstd(tmp)

% 'Ice conc'
% tmp = anData.IWConcentraction(tmpInd);
% tmp(~isfinite(tmp)) = [];
% quantile(tmp, [0.05 0.25 0.5 0.75 0.95])
% nanmean(tmp)
% nanstd(tmp)

% 'TWC'
% tmp = anData.TWContent(tmpInd);
% tmp(~isfinite(tmp)) = [];
% %1000*quantile(tmp, [0.05 0.25 0.5 0.75 0.95])
% 1000*nanmean(tmp)
% 
% 'LWC'
% tmp = anData.LWContent(tmpInd);
% tmp(~isfinite(tmp)) = [];
% %1000*quantile(tmp, [0.05 0.25 0.5 0.75 0.95])
% 1000*nanmean(tmp)
% 
% 'IWC'
% tmp = anData.IWContent(tmpInd);
% tmp(~isfinite(tmp)) = [];
% %1000*quantile(tmp, [0.05 0.25 0.5 0.75 0.95])
% 1000*nanmean(tmp)
% 
% 'total mean d'
% tmp = anData.TWMeanD(tmpInd);
% tmp(~isfinite(tmp)) = [];
% 1000000*quantile(tmp, [0.05 0.25 0.5 0.75 0.95])
% 1000000*nanmean(tmp)
% 
% 'liquid mean d'
% tmp = anData.LWMeanD(tmpInd);
% tmp(~isfinite(tmp)) = [];
% 1000000*quantile(tmp, [0.05 0.25 0.5 0.75 0.95])
% 1000000*nanmean(tmp)
% 
% 'ice mean d'
% tmp = anData.IWMeanD(tmpInd);
% tmp(~isfinite(tmp)) = [];
% 1000000*quantile(tmp, [0.05 0.25 0.5 0.75 0.95])
% 1000000*nanmean(tmp)


%Total Ausgabe:
% ['mean total conc. [cm^{-3}] ' num2str(nanmean(anData.TWConcentraction(isfinite(anData.TWConcentraction))),'%4.2g')]
% ['mean water conc. [cm^{-3}] ' num2str(nanmean(anData.LWConcentraction(isfinite(anData.LWConcentraction))),'%4.2g')]
% ['mean ice conc. [cm^{-3}] ' num2str(nanmean(anData.IWConcentraction(isfinite(anData.IWConcentraction))),'%4.2g')]
% 
% ['mean total content [g m^{-3}] ' num2str(nanmean(anData.TWContent(isfinite(anData.TWContent))),'%4.2g')]
% ['mean water content [g m^{-3}] ' num2str(nanmean(anData.LWContent(isfinite(anData.LWContent))),'%4.2g')]
% ['mean ice content [g m^{-3}] ' num2str(nanmean(anData.IWContent(isfinite(anData.IWContent))),'%4.2g')]
% 
% ['mean total conc. [cm^{-3}] ' num2str(nanmean(anData.TWConcentraction(isfinite(anData.TWConcentraction))),'%4.2g')]
% ['mean water conc. [cm^{-3}] ' num2str(nanmean(anData.LWConcentraction(isfinite(anData.LWConcentraction))),'%4.2g')]
% ['mean ice conc. [cm^{-3}] ' num2str(nanmean(anData.IWConcentraction(isfinite(anData.IWConcentraction))),'%4.2g')]
% 
% ['mean total content [g m^{-3}] ' num2str(nanmean(anData.TWContent(isfinite(anData.TWContent))),'%4.2g')]
% ['mean water content [g m^{-3}] ' num2str(nanmean(anData.LWContent(isfinite(anData.LWContent))),'%4.2g')]
% ['mean ice content [g m^{-3}] ' num2str(nanmean(anData.IWContent(isfinite(anData.IWContent))),'%4.2g')]