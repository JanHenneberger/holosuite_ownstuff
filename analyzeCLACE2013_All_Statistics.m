if ~exist('anData','var');
    %Auswertung für Diss
    %anData = load('F:\CLACE2013\TimeSerie\AllN2CLACE2013_10secStat.mat');
    %anData = anData.anDataAll;
    
    %Auswertung für GroupRetreat2013
    anData = load('F:\ParticleStatsWS\CLACE2013-10-as\AllN2CLACE2013_100secStat.mat');
    anData = anData.anDataAll;
        
%     anData = load('F:\JFJ2012\asFiles\All2012_300secStat.mat');
%     anData = anData.anDataAll;
%     anData = load('F:\CLACE2013\Overview\Overview_10minStat.mat');
%     anData = anData.outFile;
end

%includeMeteoSwiss
%anData.LWConcentraction = anData.TWConcentraction;
set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);

for cnt2 = 1:numel(anData.sample)
    anData.Number(cnt2)=anData.sample{1,cnt2}.Number;
    anData.NumberReal(cnt2)=anData.sample{1,cnt2}.NumberReal;
    anData.sampleVolumeAll(cnt2)=anData.sample{1,cnt2}.VolumeAll;
    anData.sampleVolumeReal(cnt2)=anData.sample{1,cnt2}.VolumeReal;
end

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
varNames = {'Air temperature [°C]'; ... %1
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

%Group by IWC/TWC
Y = anData.IWContent./anData.TWContent;
edges = [0 .10 .20 .30 .40 .50 .60 .70 .80 .90 1];
labels={'5', '15','25','35','45','55','65','75','85','95'};
levels=([5 15 25 35 45 55 65 75 85 95]);
% edges = [0   .10   .30   .50   .70   .90 1.05];
% labels={'0.05', '20' ,'40','60','80','95'};
% levels=([5 20 40 60 80 95]);
oIceFraction=ordinal(Y,labels,[],edges);
%Group by temperature
Y = anData.measMeanT;
edges = [-35 -30 -25 -20 -15 -10 -5 0];
labels={ '-35-30°C'; '-30-25°C'; '-25-20°C'; '-20-15°C'; '-15-10°C'; '-10-5°C'; '-5-0°C'};
oTemperature=ordinal(Y,labels,[],edges);

oTemperature = droplevels(oTemperature);

%Group by day
Y = anData.timeVecStart(3,:);
oDay=ordinal(Y);

%KorolevData
korFrac = 5:10:95;
korDataOld = [0.0658    0.0572    0.1902    0.2498    0.2626    0.4610    0.5144;...
           0.0187    0.0183    0.0300    0.0393    0.0284    0.0320    0.0464;...
           0.0110    0.0150    0.0204    0.0230    0.0193    0.0222    0.0321;...
           0.0058    0.0159    0.0184    0.0184    0.0169    0.0189    0.0279;...
           0.0116    0.0273    0.0193    0.0170    0.0179    0.0189    0.0271;...
           0.0168    0.0367    0.0383    0.0260    0.0257    0.0218    0.0291;...
           0.0471    0.0820    0.0675    0.0446    0.0423    0.0284    0.0327;...
           0.1303    0.1553    0.1137    0.0897    0.0771    0.0428    0.0402;...
           0.2490    0.2104    0.1529    0.1598    0.1333    0.0725    0.0581;...
           0.4439    0.3820    0.3493    0.3324    0.3765    0.2815    0.1922];
korDataOld = korDataOld*100;
       
korData = [...       
0.0497       0.0426        0.1584       0.2087        0.2276        0.4215        0.4419;...
0.0110       0.0090        0.0200       0.0262        0.0231        0.0253        0.0498;...
0.0097       0.0095        0.0178       0.0229        0.0177        0.0210        0.0323;...
0.0103       0.0095        0.0163       0.0216        0.0151        0.0172        0.0246;...
0.0090       0.0093        0.0145       0.0183        0.0138        0.0154        0.0228;...
0.0071       0.0114        0.0156       0.0160        0.0146        0.0167        0.0241;...
0.0058       0.0165        0.0171       0.0174        0.0164        0.0182        0.0267;...
0.0142       0.0339        0.0274       0.0230        0.0230        0.0238        0.0339;...
0.0529       0.1025        0.0911       0.0605        0.0579        0.0419        0.0511;...
0.8303       0.7558        0.6218       0.5853        0.5907        0.3990        0.2927];
korData = korData*100;

%Comparsion Manchester
if 0
    figure(8)
    clear gcf
    
    subplot(1,3,2)
    hold on
    x=anData.cdpMean;
    y=anData.TWContent2;
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y) %| x<0.05;
    x(nanValues)=[];
    y(nanValues)=[];
    plotLimit = 1.05%1.05*max(max(x),max(y));
    
    scatter(x, y);
    p=polyfit(x,y,1);
    xfit = linspace(0,plotLimit);
    plot(xfit,p(1).*xfit+p(2));
    plot(xfit,xfit,'k-');
    R=corrcoef(x,y);
    
    str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
    str1(1) = {['R^2-value: ' num2str(R(1,2),'%4.2g')]};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, plotLimit]);
    ylim([0, .3]);
    xlabel('CDP (2 - 50 \mum)');
    ylabel('HOLIMO II (6 - 50 \mum)');
    title('TWC [g m^{-3}]')
    box on
    
    subplot(1,3,1)
    hold on
    x=anData.pvmMean;
    y=anData.TWContent2;
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y) %| x==0.32;
    x(nanValues)=[];
    %x = x-0.11;
    y(nanValues)=[];
    plotLimit = 1.05%1.05*max(max(x),max(y));
    scatter(x, y);
   
    p=polyfit(x,y,1);
    xfit = linspace(0,plotLimit);
    plot(xfit,p(1).*xfit+p(2));
    plot(xfit,xfit,'k-');
    R=corrcoef(x,y);
    
    str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
    str1(1) = {['R^2-value: ' num2str(R(1,2),'%4.2g')]};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, .6]);
    ylim([0, .3]);
    xlabel('PVM-100 (3 - 50 \mum)');
    ylabel('HOLIMO II (6 - 50 \mum)');
    title('TWC [g m^{-3}]')
    box on
    
   
    subplot(1,3,3)
    hold on
    x=anData.cdpMean;
    y=anData.pvmMean;
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y) %| x<0.05 | y==0.32;
    x(nanValues)=[];
    y(nanValues)=[];
    %y = y-0.11;
    plotLimit = 1.05%1.05*max(max(x),max(y));
    
    scatter(x, y);
    p=polyfit(x,y,1);
    xfit = linspace(0,plotLimit);
    plot(xfit,p(1).*xfit+p(2));
    plot(xfit,xfit,'k-');
    R=corrcoef(x,y);
    
    str1(2) = {[num2str(p(2),'%4.2g') ' + ' num2str(p(1),'%4.2g') '*x']};
    str1(1) = {['R^2-value: ' num2str(R(1,2),'%4.2g')]};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, plotLimit]);
    ylim([0, .8]);
    xlabel('CDP (2 - 50 \mum)');
    ylabel('PVM-100 (3 - 50 \mum)');
    title('TWC [g m^{-3}]')
    box on
    

    
       
end


%Ice Fraction Grouped by North/South
if 1
    figure(7)
    labels = getlabels(oWindDirection);    
    frequency = summary(oWindDirection);
    clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
    %dayString = {', 1 day',', 6 days'};
    dayString = {' '};
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
figure(6)
labels = getlabels(oTemperature);
 frequency = summary(oTemperature);
 clear freqString
    for i=1:numel(frequency)
        freqString{i} = [' (n = ' num2str(frequency(i)) ')'];
    end
legendString = strcat(labels, freqString);
plotColor = cool(numel(labels));
stat=tabulate(oIceFraction);

plot(levels,[stat{:,3}],'k','LineWidth',2.5)
hold on
for cnt = 1:numel(labels)    
stat=tabulate(oIceFraction(oTemperature==labels{cnt}));
plot(levels,[stat{:,3}],'Color', plotColor(cnt,:),'LineWidth',1)
end


plot(korFrac,mean(korData,2),'--k','LineWidth',2.5)
for cnt = 1:numel(labels)
plot(korFrac,korData(:,cnt+2),'lineStyle','--','Color', plotColor(cnt,:),'LineWidth',1)
end

legend([{'All Temp.'},legendString])
xlabel('IWC/TWC')
ylabel('Frequency [%]')

% tmp1 = anData.IWContent./anData.TWContent;
% tmp1(isnan(tmp1))=0;
% tmp1(isinf(tmp1))=0;
% 
% tmp2 = anData.measMeanT;
% aoctool(tmp1, tmp2,B);
% anovan(tmp1,X,'Continuous',1:13,'varnames',varNames);

end

%Histogram Water Contents
if 1 
    figure(10)
    threshold = 0.1;
    subplot(2,3,1)
     hist(anData.TWContent(isfinite(anData.TWContent) & anData.TWContent > threshold ),20)
     legend('TWC')
        subplot(2,3,2)
     hist(anData.LWContent(isfinite(anData.LWContent)& anData.TWContent > threshold),20) 
     legend('LWC')
     subplot(2,3,3)
     hist(anData.IWContent(isfinite(anData.IWContent)& anData.TWContent > threshold),20)
     legend('IWC')
     subplot(2,3,5)
     scatter(anData.TWContent(isfinite(anData.TWContent) & anData.TWContent > threshold ),...
         anData.LWContent(isfinite(anData.LWContent)& anData.TWContent > threshold));
          subplot(2,3,6)
     scatter(anData.TWContent(isfinite(anData.TWContent) & anData.TWContent > threshold ),...
         anData.IWContent(isfinite(anData.IWContent)& anData.TWContent > threshold));
end

%histograms group by something%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    figure(1)
    clear gcf
    plotGroupBoxplots(anData, oDay);
end

B=oTemperature;
if 0
    figure(5)
    [H, AX, BigAx] = plotmatrix(Y',X);
    Y = anData.measMeanT;
    set(get(AX(numel(AX)),'XLabel'),'String','Temperature [°C]');
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