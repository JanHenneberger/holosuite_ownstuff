function anData = plot_statistics(anData)
close all
set(0, 'DefaultFigureWindowStyle', 'docked')
set(0,'DefaultAxesFontSize',12);
set(0,'DefaultLineLineWidth',1.3);
set(0,'DefaultAxesLineWidth',1.3);
set(0,'DefaultAxesTickDir','out');

cntFig = 0;


%Group by all
anData.oAll = ordinal(ones(1,numel(anData.timeStart)),{'All Data'},1);

%Group by IWC/TWC
Y = anData.IWConcentraction./anData.TWConcentraction;
labels={'<.1 %','0.1 - 1 %','1 - 10 %','10-100 %'};
edges=([0.00000001 0.001 0.01 0.1 1.00]);
anData.oIceFractionNumber=ordinal(abs(Y),labels,[],edges);
anData.oIceFractionNumber = droplevels(anData.oIceFractionNumber);

%Group by IWC/TWC
Y = anData.IWContent./anData.TWContent;
labels={'0-10 %','10-20 %','20-30 %','30-40 %','40-50 %',...
    '50-60 %','60-70 %','70-80 %','80-90 %','90-100 %'};
edges=0:0.1:1;
anData.levelsIceFraction = 0.05:0.1:0.95;
anData.oIceFraction=ordinal(abs(Y),labels,[],edges);
anData.oIceFraction = droplevels(anData.oIceFraction);

labels={'0-20 %','20-40 %','40-60 %','60-80 %','80-100 %'};
edges=([.0 .20 .40 .6 .80 1.00]);
anData.oIceFraction2=ordinal(abs(Y),labels,[],edges);
anData.oIceFraction2 = droplevels(anData.oIceFraction2);

labels = {'Liquid','Mixed','Ice'};
edges = ([-.1 .1 .9 1.1]);
anData.oCloudPhase =  ordinal(abs(Y),labels,[],edges);

if strcmp(anData.campaignName,'CLACE2014');
    edges = [0 5 10 15 20 25 30];
    labels={ '0-5 m/s';'5-10 m/s';'10-15 m/s';'15-20 m/s';'20-25 m/s';'25-30 m/s'};
else
    edges = [-1 5 10 20];
    labels={ '0-5 m/s'; '5-10 m/s';'10-20 m/s'};
     % edges = [0 1 2 3 6 10 20];
      % labels={ '0-1 m/s';'1-2 m/s';'2-4 m/s';'4-6 m/s';'6-10 m/s';'10-20 m/s'};
end
%Group by wind velocity
Y = anData.measMeanV;
anData.oWindV=ordinal(Y,labels,[],edges);
anData.oWindV = droplevels(anData.oWindV);

%Group by wind velocity
Y = anData.meteoWindVel;
anData.oWindVMeteo=ordinal(Y,labels,[],edges);
anData.oWindVMeteo = droplevels(anData.oWindVMeteo);

%Group by temperature
Y = anData.measMeanT;
grpstats(anData.IWConcentraction(anData.chosenData),anData.oYear(anData.chosenData))
if strcmp(anData.campaignName,'JFJ2012/CLACE2013');
    edges = [-25 -20 -15 -10 -5 0];
    labels={'-25 to -20°C'; '-20 to -15°C'; ...
        '-15 to -10°C'; '-10 to -5°C' ;'-5 to 0°C'};
    anData.oTemperature=ordinal(Y,labels,[],edges);
    anData.oTemperature = droplevels(anData.oTemperature);    
else
    edges = [-35 -30 -25 -20 -15 -10 -5 0];
    labels={ '-35 to -30°C'; '-30 to -25°C'; '-25 to -20°C'; '-20 to -15°C'; ...
        '-15 to -10°C'; '-10 to -5°C'; '-5 to 0°C'};
    anData.oTemperature=ordinal(Y,labels,[],edges);
    anData.oTemperature = droplevels(anData.oTemperature);
end
%anData.oTemperature = droplevels(anData.oTemperature, '-5 to 0°C');
anData.oTemperature2 = anData.oTemperature;
anData.oTemperature = mergelevels(anData.oTemperature, {'-5 to 0°C','-10 to -5°C'}, '-10 to -5°C');

%Group by day
Y = anData.timeVecStart(3,:)+1000*(anData.timeVecStart(1,:)-2000)+100*anData.timeVecStart(2,:);
anData.oDay=ordinal(Y);

%Group by year
Y = anData.timeVecStart(1,:);
anData.oYear = ordinal(Y);

%Group by month
Y = anData.timeVecStart(2,:);
anData.oMonth = ordinal(Y);

%Define color maps
anData.plotColorWindDir = lbmap(2,'RedBlue');
anData.plotColorWindVel = flipud(lbmap(numel(getlabels(anData.oWindVMeteo(anData.chosenData)))+1,'RedBlue'));
anData.plotColorWindVel(2,:)= [];
anData.plotColorTemp  = flipud(lbmap(numel(getlabels(anData.oTemperature(anData.chosenData))),'RedBlue'));


%KorolevData
anData.korFrac = 0.05:0.1:0.95;
anData.korDataOld = [0.0658    0.0572    0.1902    0.2498    0.2626    0.4610    0.5144;...
    0.0187    0.0183    0.0300    0.0393    0.0284    0.0320    0.0464;...
    0.0110    0.0150    0.0204    0.0230    0.0193    0.0222    0.0321;...korrIceClouds
    0.0058    0.0159    0.0184    0.0184    0.0169    0.0189    0.0279;...
    0.0116    0.0273    0.0193    0.0170    0.0179    0.0189    0.0271;...
    0.0168    0.0367    0.0383    0.0260    0.0257    0.0218    0.0291;...
    0.0471    0.0820    0.0675    0.0446    0.0423    0.0284    0.0327;...
    0.1303    0.1553    0.1137    0.0897    0.0771    0.0428    0.0402;...
    0.2490    0.2104    0.1529    0.1598    0.1333    0.0725    0.0581;...
    0.4439    0.3820    0.3493    0.3324    0.3765    0.2815    0.1922];
anData.korDataOld = anData.korDataOld*100;

anData.korData = [...
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
anData.korData = anData.korData*100;

set(0,'DefaultAxesTickLength',[0.015 0.03])


%% Scatter plot wind measurements
cntFig = cntFig+1;
if anData.plotRest
    plot_ScatterWind(anData,cntFig)    
end
%%%

%% Comparision to normal distribution
cntFig = cntFig+1;
if anData.plotRest
    figure(cntFig)
    gcf
    normplot(anData.TWConcentraction(anData.chosenData))
end

%% wind rose
cntFig = cntFig+1;
if anData.plotRest
    figure(cntFig)
    gcf
    wind_rose(anData.meteoWindDir(anData.chosenData)+180,anData.meteoWindVel(anData.chosenData),'dtype','meteo','bcolor','k','quad',3)
end

%% IceFraction Plots
cntFig = cntFig+1;
if anData.plotIceFraction || anData.plotPaper
    plot_TempIceFraction(anData,cntFig);
end

cntFig = cntFig+1;
if anData.plotIceFraction || anData.plotPaper
    plot_IceFractionByWindVel(anData, cntFig);   
end

cntFig = cntFig+1;
if (anData.plotIceFraction && anData.plotNorthSouth) || anData.plotPaper
    anData.chosenWindDirection = 'South wind';
    plot_IceFractionByWindVelWindDirection(anData, cntFig);
end

cntFig = cntFig+1;
if (anData.plotIceFraction && anData.plotNorthSouth) || anData.plotPaper
    anData.chosenWindDirection = 'North wind';
    plot_IceFractionByWindVelWindDirection(anData, cntFig);    
end

cntFig = cntFig+1;
if anData.plotIceFraction || anData.plotPaper || anData.plotPaperUlrike
    figure
    gcf
    subplot(2,2,1)
    plot_IceFractionByTemperature(anData); 
    subplot(2,2,2)
    plot_IceFractionByTemperatureKorolev(anData); 
    subplot(2,2,3)
    anData.chosenWindDirection = 'North wind';
    plot_IceFractionByTemperautreWindDirection(anData);  
    subplot(2,2,4)
    anData.chosenWindDirection = 'South wind';
    plot_IceFractionByTemperautreWindDirection(anData); 
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 26 20]);
    set(gcf, 'PaperSize', [26 20]);
    if anData.savePlots
        fileName = ['All_IceFraction_TempAll'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    
end

cntFig = cntFig+1;
if anData.plotIceFraction || anData.plotPaper  || anData.plotUlrike
    plot_IceFractionByWindDirection(anData, cntFig)    
end


%% Boxplots
if anData.plotBoxplot
    cntFig = plot_Boxplots(anData, cntFig);
end

%% Scatterplots
cntFig = cntFig+1;
if anData.plotRest
    plot_Scatterplot(anData,cntFig)
end

set(0,'DefaultAxesFontSize',13);
set(0,'DefaultAxesLineWidth',1.6);
set(0,'DefaultAxesTickLength',[0.03 0.06])

%%Spectra 
cntFig = cntFig+1;
if anData.plotSpectra  || anData.plotPaper
    plot_Spectra(anData, cntFig);
end

%by Temperature
cntFig = cntFig+1;
if anData.plotSpectra 
 plot_SpectraByTemperature(anData,cntFig);
end


cntFig = cntFig+1;
if anData.plotSpectra   && anData.plotNorthSouth
    anData.chosenWindDirection = 'South wind';
    plot_SpectraByTemperatureWindDirection(anData, cntFig);    
end
cntFig = cntFig+1;
if anData.plotSpectra   && anData.plotNorthSouth
    anData.chosenWindDirection = 'North wind';
    plot_SpectraByTemperatureWindDirection(anData, cntFig);    
end

%by windspeed
cntFig = cntFig+1;
if anData.plotSpectra 
    plot_SpectraByWindSpeed(anData, cntFig)
end

cntFig = cntFig+1;
if anData.plotSpectra && anData.plotNorthSouth
    anData.chosenWindDirection = 'North wind';
    plot_SpectraByWindspeedWindDirection(anData, cntFig);
end
cntFig = cntFig+1;
if anData.plotSpectra && anData.plotNorthSouth
    anData.chosenWindDirection = 'South wind';
    plot_SpectraByWindspeedWindDirection(anData, cntFig);
end


%by wind direction
cntFig = cntFig+1;
if anData.plotSpectra  || anData.plotPaper
    plot_SpectraByWindDirection(anData, cntFig);
end

%% Statistics
if anData.plotStatistics
    anData.wholeData = calc_Statistics(anData);
end


%% Cloud case analysis
anData.caseStats = makeCaseStats(anData, anData.oCase, 'anData.caseStats2.txt');
tmp = grpstats(anData.meteoWindDir, anData.oCase);
anData.caseStats.isSouthWind = tmp > 45 & tmp < 255;
%[1 1 1 0 1 1 1 1 0 0 0 0 0 0 1 0 0]
anData.caseStats.oWindDirection = ordinal(anData.caseStats.isSouthWind,{'South wind','North wind'},[1,0]);
anData.windDirectionStats = makeCaseStats(anData, anData.oWindDirection,'windDirectionStats.txt');
% 
% tmpInt = anData.chosenData & isfinite(anData.TWContent);
% oTmp = anData.oYear(tmpInt);
% caseYear.IWCMean = grpstats(real(anData.IWContent(tmpInt)),oTmp,'mean');
% caseYear.IWCStd = grpstats(real(anData.IWContent(tmpInt)),oTmp,'std');
% caseYear.IWCStdMean = grpstats(real(anData.IWContent(tmpInt)),oTmp,'sem');

%% Korolev updraft calculation
[anData.caseStats.updraft, anData.caseStats.Niri, anData.caseStats.glaciationTime] ...
    = updraftKorolev(...
        anData.caseStats.PressureMean*1e2,...
        anData.caseStats.TempMean+273.14,...
        abs(anData.caseStats.IWConcMean)*1e6,...
        abs(anData.caseStats.IWMeanMaxDMean)/2,...
        abs(anData.caseStats.LWCMean/1000),...
        abs(anData.caseStats.IWCMean/1000));

anData = includeUpdraftKorolev(anData);
anData.uz = anData.uz2;
%scatter(anData.Niri,anData.Niri2./anData.Niri)

Y = anData.glaciationTime;
labels={'< 1 s','1-10 s','10-100 s','100-1000 s','1000-10000 s','10000-100000 s'};
edges=([0.00000001 1 10 100 1000 10000 100000]);
anData.oGlactiationTime=ordinal(abs(Y),labels,[],edges);
anData.oGlactiationTime = droplevels(anData.oGlactiationTime);

cntFig = cntFig+1;
if anData.plotPaperUlrike
    plot_GlaciationTimeByWindDirection(anData, cntFig)    
end



%updraftv velocity histogramm for intervalls
cntFig = cntFig+1;
if anData.plotUpdraft
    figure(cntFig)
    clf
    hist(anData.uz((anData.chosenData)),logspace(-2.9,2.3)) 
    set(gca,'xscale','log')
    xlabel('Updraft velocity [m s^{-1}]')
    ylabel('Frequency')
end

%Test updraft velocity
cntFig = cntFig+1;
if anData.plotUpdraft
    figure(cntFig)
    clf
    niri = logspace(-1,3,100);
    loglog(niri, updraft(mean(anData.caseStats.PressureMean*1e2),...
        mean(anData.caseStats.TempMean+273.14),...
        niri,...
        1))        
end


set(0,'DefaultAxesFontSize',10);

%Scatter plot by cloud cases - updraft velocitie
cntFig = cntFig+1;
if anData.plotUpdraft
    plot_CloudCasesUpdraft(anData, cntFig)    
end

%Scatter plot by intervalls - updraft velocitie
cntFig = cntFig+1;
if anData.plotUpdraft 
    plot_ScatterUpdraft(anData, cntFig)    
end

%Scatter plot by intervalls Olga - updraft velocitie
cntFig = cntFig+1;
if anData.plotUpdraft 
    plot_ScatterUpdraftOlga(anData, cntFig)    
end
if anData.plotUpdraft 
    plot_ScatterUpdraftOlga2(anData, cntFig)    
end
if anData.plotUpdraft || anData.plotPaperUlrike
    plot_ScatterUpdraftOlga3(anData, cntFig)    
end
if  anData.plotPaperUlrike
    plot_ScatterUpdraftOlga4(anData, cntFig)    
end
if  anData.plotPaperUlrike
    plot_ScatterUpdraftOlga5(anData, cntFig)    
end

%Scatter plot by cloud cases - Temperature
cntFig = cntFig+1;
if anData.plotCaseScatter 
    plot_CloudCasesTemperature(anData,cntFig);    
end


%%Scatter plot by cloud cases - WindSpeed
cntFig = cntFig+1;
if anData.plotCaseScatter
    plot_CloudCasesWindSpeed(anData,cntFig); 
end

set(0,'DefaultAxesFontSize',9);

%Scatter plot by cloud cases - WindSpeed Paper
cntFig = cntFig+1;
if anData.plotCaseScatterPaper 
    plot_CloudCasesWindSpeedPaper(anData,cntFig);
end


%Scatter plot by cloud cases - Temperature Paper
cntFig = cntFig+1;
if anData.plotCaseScatterPaper || anData.plotPaperUlrike
    plot_CloudCasesTemperaturePaper(anData,cntFig);    
end

% %Scatter plot by cloud cases - Temperature Paper
% cntFig = cntFig+1;
% if anData.plotPaperUlrike
%     plot_CloudCasesTemperatureIWCTWC(anData,cntFig);    
% end
% 
% %Scatter plot by cloud cases - Temperature Paper
% cntFig = cntFig+1;
% if anData.plotPaperUlrike
%     plot_CloudCasesTemperatureIWCTWC2(anData,cntFig);    
% end

%Scatter plot by cloud cases - Temperature Paper
cntFig = cntFig+1;
if anData.plotPaper
    plot_boxplotTemperatureIWCTWC(anData,cntFig);    
end

%Scatter plot by cloud cases - Temperature Paper
cntFig = cntFig+1;
if anData.plotPaperUlrike
    plot_boxplotTemperatureIWCTWC2(anData,cntFig);    
end

%Scatter plot by cloud cases - Temperature Paper
cntFig = cntFig+1;
if anData.plotPaperUlrike
    plot_boxplotIceConc(anData,cntFig);
end


if anData.plotBoxplotCloudPhase 
    
    %%Boxplot Liquid clouds      
    cntFig = cntFig+1;
    plot_boxplotCloudPhase(cntFig, anData,'Liquid')
     cntFig = cntFig+1;
    plot_boxplotCloudPhase(cntFig, anData,'Mixed')   
    cntFig = cntFig+1;
    plot_boxplotCloudPhase(cntFig, anData,'Ice')
end

if anData.plotPaperUlrike
    cntFig = cntFig+1;
    plot_boxplotPhaseAndDirection(cntFig, anData)
end

%% Scatter plot for Yang Paper
cntFig = cntFig+1;
if anData.plotYang
    plot_Yang(anData,cntFig)    
end

%% Export the data file
if anData.exportData;
   export_Data(anData,'HOLIMO_100sec',anData.chosenData) 
end


%% Ice Crystals vs. Windspeed
if anData.plotIceWind
    cntFig = plot_IceWind(anData, cntFig);
end

if anData.plotBoxplotUp
    vz = (anData.measMeanV.^2-anData.measMeanVAzimut.^2).^(1/2);
    
    
%     cntFig = cntFig+1;
%     figure(cntFig)
%     gcf
%     chosenData = anData.oIsValid == 'Valid';
%     plotGroupBoxplotsWindV(anData, anData.oCloudPhase, chosenData);
%     title('All wind')
%     set(gcf, 'PaperOrientation','landscape');
%     set(gcf, 'PaperUnits','centimeters');
%     set(gcf, 'PaperPosition',[-1 -1 31 23]);
%     set(gcf, 'PaperSize', [29 21]);
%     if anData.savePlots
%         fileName = 'Boxplot_CloudPhase_All';
%         print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
%     end
%     
%     cntFig = cntFig+1;
%     figure(cntFig)
%     gcf
%     chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'North wind';
%     plotGroupBoxplotsWindV(anData, anData.oCloudPhase, chosenData);
%     title('North wind')
%     set(gcf, 'PaperOrientation','landscape');
%     set(gcf, 'PaperUnits','centimeters');
%     set(gcf, 'PaperPosition',[-1 -1 31 23]);
%     set(gcf, 'PaperSize', [29 21]);
%     if anData.savePlots
%         fileName = 'Boxplot_CloudPhase_North';
%         print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
%     end
%     
%     cntFig = cntFig+1;
%     figure(cntFig)
%     gcf
%     chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'South wind';
%     plotGroupBoxplotsWindV(anData, anData.oCloudPhase, chosenData);
%     title('South wind')
%     set(gcf, 'PaperOrientation','landscape');
%     set(gcf, 'PaperUnits','centimeters');
%     set(gcf, 'PaperPosition',[-1 -1 31 23]);
%     set(gcf, 'PaperSize', [29 21]);
%     
%     set(0,'DefaultAxesFontSize',12);
%     set(0,'DefaultLineLineWidth',1.3);
%     set(0,'DefaultAxesLineWidth',1.3);
%     set(0,'DefaultAxesTickDir','out');
%     
%     if anData.savePlots
%         fileName = 'Boxplot_CloudPhase_South';
%         print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
%     end
    
    cntFig = cntFig+1;
    f1 = figure(cntFig)
    clf
    
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'North wind';
    p1 = boxplot(anData.meteoWindVel(chosenData), anData.oCloudPhase(chosenData))
    ax1 = gca;
    hold on 
    tempCC = grpstats((anData.meteoTemperature(chosenData)),anData.oCloudPhase(chosenData));
    p2 =plot([1 2 3],-1*tempCC,'Color','k');
    ylim([0,20])
    ylabel('Wind speed [ms^{-1}] and -1*Temperature [°C]');
    box on;
    ylim([0,20])
    title('North wind')
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'Boxplot_MeteoWindSpeed_North';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end  
    
    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'South wind';
    boxplot(anData.meteoWindVel(chosenData), anData.oCloudPhase(chosenData))
    hold on 
    tempCC = grpstats((anData.meteoTemperature(chosenData)),anData.oCloudPhase(chosenData));
    p2 =plot([1 2 3],-1*tempCC,'Color','k');
    ylim([0,20])
    ylabel('Wind speed [ms^{-1}] and -1*Temperature [°C]');
    ylabel('Wind speed [ms^{-1}]');
    box on; 
    title('South wind')
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'Boxplot_MeteoWindSpeed_South';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end   
    
    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'North wind';
    gscatter(anData.meteoWindVel(chosenData),anData.uz(chosenData),anData.oCloudPhase(chosenData))
    hold on
    plot(logspace(-1,1.2,50),logspace(-1,1.2,50))
    xlabel('Wind speed [ms^{-1}]');
    ylabel('necessary updraft velocity [ms^{-1}]');
    title('North wind')
    set(gca,'YScale','log')
    set(gca,'XScale','log')
    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterMeteoCalculatedUpdraft_North';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end   
    
    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'South wind';
    gscatter(anData.meteoWindVel(chosenData),anData.uz(chosenData),anData.oCloudPhase(chosenData))
    hold on
    plot(logspace(-1,1.2,50),logspace(-1,1.2,50))
    xlabel('Wind speed [ms^{-1}]');
    ylabel('necessary updraft velocity [ms^{-1}]');
    title('South wind')
    set(gca,'YScale','log')
    set(gca,'XScale','log')
    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
        set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterMeteoCalculatedUpdraft_South';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end   
    
    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'North wind';
    
    data = anData.meteoWindVel(chosenData)-anData.uz(chosenData);
    data(~isfinite(data)) = nan;
    
    boxplot(data, anData.oCloudPhase(chosenData))     
    ylabel('Meteo - Necessary uz [ms^{-1}]');
    box on; 
    title('North wind')
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'Scatter_Meteo_ThresholdDiff_North';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end

    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'South wind';
    data = anData.meteoWindVel(chosenData)-anData.uz(chosenData);
    data(~isfinite(data)) = nan;
    boxplot(data, anData.oCloudPhase(chosenData))
    ylabel('Meteo - Necessary uz [ms^{-1}]');
    box on; 
    title('South wind')
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'Scatter_Meteo_ThresholdDiff_South';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end

   cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'North wind';
    boxplot(anData.updraft(chosenData), anData.oCloudPhase(chosenData))
    ylabel('Simulated updraft [ms^{-1}]');
    box on;  
    title('North wind')
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'Boxplot_SimulatedWindSpeed_North';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    
    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'South wind';
    boxplot(anData.updraft(chosenData), anData.oCloudPhase(chosenData))
    ylabel('Simulated updraft [ms^{-1}]');
    box on; 
    title('South wind')
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'Boxplot_SimulatedWindSpeed_South';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end   
    
    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'North wind';
    gscatter(anData.updraft(chosenData),anData.uz(chosenData),anData.oCloudPhase(chosenData))
    hold on
    plot(logspace(-1,1.2,50),logspace(-1,1.2,50))
    xlabel('Simulated updraft [ms^{-1}]');
    ylabel('necessary updraft velocity [ms^{-1}]');
    title('North wind')
    set(gca,'YScale','log')
    set(gca,'XScale','log')
    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterSimulatedCalculatedUpdraft_North';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end   
    
    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'South wind';
    gscatter(anData.updraft(chosenData),anData.uz(chosenData),anData.oCloudPhase(chosenData))
    hold on
    plot(logspace(-1,1.2,50),logspace(-1,1.2,50))
    xlabel('Simulated updraft [ms^{-1}]');
    ylabel('necessary updraft velocity [ms^{-1}]');
    title('South wind')
    set(gca,'YScale','log')
    set(gca,'XScale','log')
    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
        set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterSimulatedCalculatedUpdraft_South';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end  
    
        cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'North wind';
    data =anData.updraft(chosenData)-anData.uz(chosenData);
    data(~isfinite(data)) = nan;
    %data = abs(data);
    boxplot(data, anData.oCloudPhase(chosenData))
    ylabel('Simulated - Necessary uz [ms^{-1}]');
    box on; 
    title('North wind')
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
 
    if anData.savePlots
        fileName = 'Scatter_Simulated_ThresholdDiff_North';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    
        cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'South wind';
    data = anData.updraft(chosenData)-anData.uz(chosenData);
    data(~isfinite(data)) = nan;
    %data = abs(data);
    boxplot(data, anData.oCloudPhase(chosenData))
    
    ylabel('Simulated - Necessary uz [ms^{-1}]');
    box on; 
    title('South wind')
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
 
    if anData.savePlots
        fileName = 'Scatter_Simulated_ThresholdDiff_South';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end

    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'North wind';
    gscatter(anData.updraft(chosenData),anData.meteoWindVel(chosenData),anData.oCloudPhase(chosenData))
    hold on
    plot(linspace(0,15,50),linspace(0,15,50))
    xlabel('Simulated updraft [ms^{-1}]');
    ylabel('Meteo updraft corrected [ms^{-1}]');
    title('North wind')

    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterSimulatedMeteoCorrected_North';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end 
    
        cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'South wind';
    gscatter(anData.updraft(chosenData),anData.meteoWindVel(chosenData),anData.oCloudPhase(chosenData))
    hold on
    plot(linspace(0,15,50),linspace(0,15,50))
    xlabel('Simulated updraft [ms^{-1}]');
    ylabel('Meteo updraft corrected [ms^{-1}]');
    title('South wind')

    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterSimulatedMeteoCorrected_South';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end   
    
        cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'North wind';
    gscatter(anData.updraft(chosenData),anData.meteoWindVel(chosenData),anData.oCloudPhase(chosenData))
    hold on
    plot(linspace(0,15,50),linspace(0,15,50))
    xlabel('Simulated updraft [ms^{-1}]');
    ylabel('Meteo updraft [ms^{-1}]');
    title('North wind')

    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterSimulatedMeteo_North';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end 
    
        cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'South wind';
    gscatter(anData.updraft(chosenData),anData.meteoWindVel(chosenData),anData.oCloudPhase(chosenData))
    hold on
    plot(linspace(0,15,50),linspace(0,15,50))
    xlabel('Simulated updraft [ms^{-1}]');
    ylabel('Meteo updraft [ms^{-1}]');
    title('South wind')

    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterSimulatedMeteo_South';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end
    
        cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'North wind';
    gscatter(anData.meteoWindVel(chosenData),anData.meteoTemperature(chosenData),anData.oCloudPhase(chosenData))
    hold on
    ylabel('Temperature [°C]');
    xlabel('Meteo wind speed [ms^{-1}]');
    title('North wind')

    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterTempMeteo_North';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
        
    end 
    
    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'South wind';
    gscatter(anData.meteoWindVel(chosenData),anData.meteoTemperature(chosenData),anData.oCloudPhase(chosenData))
    hold on
    ylabel('Temperature [°C]');
    xlabel('Meteo wind speed [ms^{-1}]');
    title('South wind')

    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterTempMeteo_South';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
        
    end 
    
    cases = getlevels(anData.oCase);
    for cnt = 1:numel(cases)
    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oCase == cases(cnt);
    gscatter(anData.meteoWindVel(chosenData),anData.meteoTemperature(chosenData),anData.oCloudPhase(chosenData))
    hold on
    ylabel('Temperature [°C]');
    xlabel('Meteo wind speed [ms^{-1}]');
    title('North wind')

    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = ['ScatterTempMeteo_Case' char(cases(cnt))];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
        
    end 
    end
    

    
    
            cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'North wind';
    gscatter(anData.updraft(chosenData),anData.meteoTemperature(chosenData),anData.oCloudPhase(chosenData))
    hold on
    ylabel('Temperature [°C]');
    xlabel('Simulated updraft [ms^{-1}]');
    title('North wind')

    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterTempSimulated_North';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
        
    end 
    
    cntFig = cntFig+1;
    figure(cntFig)
    clf
    chosenData = anData.oIsValid == 'Valid' & anData.oWindDirection == 'South wind';
    gscatter(anData.updraft(chosenData),anData.meteoTemperature(chosenData),anData.oCloudPhase(chosenData))
    hold on
    ylabel('Temperature [°C]');
    xlabel('Simulated updraft [ms^{-1}]');
    title('South wind')

    l= findobj(gcf,'tag','legend'); set(l,'location','best');
    box on
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[.1 0.1 9.8 9.8]);
    set(gcf, 'PaperSize', [9.8 9.8]);
    if anData.savePlots
        fileName = 'ScatterTempSimulated_South';
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
        
    end 
    
    
    chosenData = anData.oIsValid == 'Valid';    
    %SouthWind
    
    ocTemp = summary(anData.oTemperature2(chosenData));
    ocTemp2 = repmat(ocTemp,1,3)
    ocCloudPhaseTemperature = summary(anData.oCloudPhase(chosenData)  .* anData.oTemperature2(chosenData));
    ocCloudPhaseTemperature./ocTemp2*100
end