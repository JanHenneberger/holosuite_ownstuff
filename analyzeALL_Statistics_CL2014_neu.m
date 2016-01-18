if ~exist('anData2014','var');  
    tmp  = load('Z:\6_Auswertung\CLACE2014\CLACE2014_Ov_All__300secStat.mat');
    anData2014 = tmp.anDataAll;
end
close all

% anData2014.AzimutDiff = abs(difference_azimuth(anData2014.ManchRotorWingAzimuthMean,anData2014.ManchRotorWindAzimuthMean));
% anData2014.ElevationDiff = abs(anData2014.ManchRotorWingElevationMean - anData2014.ManchRotorWindElevationMean);
anData2014.isValidFlow = anData2014.measMeanFlow >50;


%Group by Intervall is valid
%anData2014.AzimutDiff < 15 & anData2014.ElevationDiff < 30 & 
isValid =  anData2014.TWCountRaw >20 &  anData2014.isValidFlow;
anData2014.oIsValid = ordinal(isValid,{'Valid','notValid'},[1,0]);

%Group by isCloud
isCloud = anData2014.TWContent > 0.010; %& anData.TWConcentraction > .1;
%isCloud = anData.TWConcentraction > .2;
anData2014.oIsCloud = ordinal(isCloud,{'Cloud','clear Sky'},[1,0]);

%Group by wind direction
isSouth= anData2014.meteoWindDir > 90 & anData2014.meteoWindDir < 270;
anData2014.oWindDirection = ordinal(isSouth,{'South wind','North wind'},[1,0]);

anData2014.savePlots = 0;
anData2014.saveDir = 'Z:\6_Auswertung\CLACE2014\Plots';
anData2014.campaignName = 'CLACE2014';
anData2014.chosenWindDirection = 'South wind';
anData2014.chosenData = anData2014.oIsCloud == 'Cloud' & anData2014.oIsValid == 'Valid'; 
anData2014.chosenDataWind = anData2014.oWindDirection == anData2014.chosenWindDirection & anData2014.chosenData;

%plot_statistics(anData2014);
startTime = datenum([2014 2 1 0 0 0]);
endTime = datenum([2014 3 1 0 0 0]);
    
plot_overview(anData2014,startTime,endTime);