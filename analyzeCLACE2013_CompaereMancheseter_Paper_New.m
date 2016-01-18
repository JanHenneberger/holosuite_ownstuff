savePlots = 1;
saveDir = fullfile ('Z:\6_Auswertung\ALL\', ...
    [datestr(now,'YY-mm-DD-HH-MM-SS') '-PlotsComparision']);
if ~exist(saveDir,'dir'), ...
        mkdir(saveDir);
end

plotScatterPlot = 0;
plotScatterPlotPaper = 0;
plotTimeSerie =0;
plotTimeSerie07 = 0;
plotTimeSerie07All = 1;
plotTimeSerieComp = 0;
plotWind = 0;
plotSpectrum = 0;
plotSpectrumRatio = 0;
plotWerkstatt = 0;
exportData = 0;

set(0,'DefaultFigureWindowStyle', 'docked')
set(0,'DefaultAxesFontSize',13);
set(0,'DefaultAxesLineWidth',1.3);
set(0,'DefaultAxesTickDir','out');

pathMeteoSwiss2013 = 'Z:\6_Auswertung\ALL\MeteoSwissCLACE2013JFJData.dat';
path2DS = 'Z:\3_Data\CLACE2013\Manchester\2DSIce\Manch_2DS.mat';
path2DSH5 = 'Z:\3_Data\CLACE2013\Manchester\2DS';

if ~exist('anData2013All','var');
    tmp  = load('Z:\6_Auswertung\ALL\PAPER-1-ICE');
    tmp = tmp.anDataOut; 
    tmp = mergeStatFileSuite(tmp);
    pathMeteoSwiss2013 = 'Z:\6_Auswertung\ALL\MeteoSwissCLACE2013JFJData.dat';
    anData2013All = includeMeteoSwiss(tmp, pathMeteoSwiss2013);
    anData2013All = include2DS(anData2013All,path2DS);
    anData2013All = include2DSH5(anData2013All,path2DSH5);
    
    clear tmp
end

if ~exist('anData2013','var');
    tmp  = load('Z:\6_Auswertung\ALL\PAPER-10-ICE');
    tmp = tmp.anDataOut;    
    anData2013 = tmp{1};   
    pathMeteoSwiss2013 = 'Z:\6_Auswertung\ALL\MeteoSwissCLACE2013JFJData.dat';
    anData2013 = includeMeteoSwiss(anData2013, pathMeteoSwiss2013);
    anData2013 = include2DS(anData2013,path2DS);
    anData2013.ManchCDPConcArrayMean = anData2013.ManchCDPConcArrayMean';
    anData2013.ManchCDPConcArrayStd = anData2013.ManchCDPConcArrayStd';
    anData2013 = includeMeteoSwiss(anData2013, pathMeteoSwiss2013);
    anData2013 = include2DS(anData2013,path2DS);
    anData2013 = include2DSH5(anData2013,path2DSH5);
    clear tmp
end

if ~exist('anData20130207','var');
    anData20130207  = load('Z:\6_Auswertung\ALL\CLACE2013-All-Clean-2013-02-07-10sec.mat');
    anData20130207 = anData20130207.anDataOut;
    anData20130207 = anData20130207{1};    
    anData20130207 = includeMeteoSwiss(anData20130207, pathMeteoSwiss2013);
    anData20130207 = include2DS(anData20130207,path2DS);


end


anData2013All.PSIManchCDPMean(anData2013All.PSIManchCDPMean<0)=nan;
anData2013All.PSIManchCDPMean = anData2013All.PSIManchCDPMean/1000;
anData2013All.PSIManchPVMMean(anData2013All.PSIManchPVMMean<0)=nan;
anData2013All.PSIManchPVMMean = anData2013All.PSIManchPVMMean/1000;
anData2013All.PSIPSIPVMMean(anData2013All.PSIPSIPVMMean<0)=nan;
anData2013All.PSIPSIPVMMean = anData2013All.PSIPSIPVMMean/1000;



anData2013.PSIManchCDPMean(anData2013.PSIManchCDPMean<0)=nan;
anData2013.PSIManchCDPMean = anData2013.PSIManchCDPMean/1000;
anData2013.PSIManchPVMMean(anData2013.PSIManchPVMMean<0)=nan;
anData2013.PSIManchPVMMean = anData2013.PSIManchPVMMean/1000;
anData2013.PSIPSIPVMMean(anData2013.PSIPSIPVMMean<0)=nan;
anData2013.PSIPSIPVMMean = anData2013.PSIPSIPVMMean/1000;



% isLowIce = anData2013All.IWContent < 0.1;
% isLowIceRatio = anData2013All.IWContent./anData2013All.TWContent < 0.4;
% isLowIceConcRatio = anData2013All.IWConcentraction./anData2013All.TWConcentraction < 0.005;

anData2013All = includeIsValid(anData2013All);
anData2013All.goodInt = anData2013All.oIsValid == 'Valid';
anData2013All = includeCDPNormalization(anData2013All);
anData2013All.saveDir = saveDir;
anData2013All.savePlots = savePlots;

anData2013 = includeIsValid(anData2013);
anData2013.goodInt = anData2013.oIsValid == 'Valid';
anData2013 = includeCDPNormalization(anData2013);
anData2013.saveDir = saveDir;
anData2013.savePlots = savePlots;

% %Grouping Manchester
% isSouth= anData2013All.meteoWindDir > 45 & anData2013All.meteoWindDir < 225;
% oWindDirection = ordinal(isSouth,{'South wind','North wind'},[1,0]);

plotData = anData2013All;

%% Scatter plot wind measurements comparision
if plotWind
    figure(17)       
    plot_WindComparision(plotData)    
end

if plotSpectrumRatio
    figure(16)
    plot_SpectaRatio(plotData)
end 

if plotSpectrumRatio
    figure(160)
    clf
    plot_SpectaRatio(plotData,12)
end 
% Spectrum
if plotSpectrum
    plotData.SIDSpektrum= load('Z:\3_Data\CLACE2013\Karlsruhe\SID_SummedSizeDistrib_CLACE2013_0802_2402.mat');
    [plotData.Ice2DS_conc,plotData.Ice2DS_size] = ...
        import2DSForHOLIMO('Z:\3_Data\CLACE2013\Manchester\2DSOld\PSDData.txt');
    [plotData.All2DS_conc,plotData.All2DS_size] = ...
        import2DSForHOLIMO('Z:\3_Data\CLACE2013\Manchester\2DSOld\AllParticles2DS.txt',2,129);
    
    figure(15)
    plot_Spectrum(plotData,4) 
    figure(16)
    plot_Spectrum(plotData,5)
    figure(17)
    plot_Spectrum(plotData,6)
    figure(18)
    plot_Spectrum(plotData,7)
    figure(19)
    plot_Spectrum(plotData,8)
    figure(20)
    plot_Spectrum(plotData,11)
    figure(21)
    plot_Spectrum(plotData,12)
    figure(22)
    plot_Spectrum(plotData,14)
end


if plotScatterPlotPaper
    figure(433)
    plot_ScatterCDPGrouped(plotData)
    
end
%Comparsion old Manchester / HOLIMO (only good Intervalss)
%Through origin
if plotScatterPlotPaper
    figure(1)
    plot_ScatterPlots(plotData)     
end

if plotTimeSerie
    figure(205)
%     startTime = datenum([2013 02 04 9 52 0]);
%     endTime = datenum([2013 02 04 19 35 0]);
     startTime = datenum([2013 02 05 13 30 0]);
     endTime = datenum([2013 02 05 17 42 0]);

    plot_TimeSerie(plotData,startTime, endTime)
end   
if plotTimeSerie07All
    figure(205)
    plot_TimeSerie07(plotData,anData20130207)
end

%Export the data file
if exportData;
    export_Data(anData2013All,'HOLIMO_10sec',anData2013All.goodInt) 
end