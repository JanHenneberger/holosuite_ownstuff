
if ~exist('anData','var');
    
    %November analysis
    %     anData2013 = load('F:\ALL_11_2013\AllN5CLACE2013_100secStat.mat');
    %     anData2013 = anData2013.anDataAll;
    %     anData2012 = load('F:\ALL_11_2013\AllN2012_100secStat3.mat');
    %     anData2012 = anData2012.anDataAll;
    tmp  = load('Z:\6_Auswertung\ALL\CLACE2013-10-New2-Clean.mat');
    tmp = tmp.anDataOut;    
    anData2013 = tmp{1};
        
    tmp  = load('Z:\6_Auswertung\ALL\CLACE2012-15-New.mat');
    tmp = tmp.anDataOut;    
    anData2012_15 = tmp{1};
    
    tmp  = load('Z:\6_Auswertung\ALL\CLACE2012-5-New-100sec.mat');
    tmp = tmp.anDataOut;    
    anData2012_5 = tmp{1};
    
    %pathMeteoSwiss2012 = 'Z:\6_Auswertung\ALL\MeteoSwiss2012JFJ.dat';
    pathMeteoSwiss2012 = 'Z:\6_Auswertung\ALL\JFJ2012_data.txt';
    pathMeteoSwiss2013 = 'Z:\6_Auswertung\ALL\MeteoSwissCLACE2013JFJData.dat';
    %anData2012_15 = includeMeteoSwiss(anData2012_15, pathMeteoSwiss2012);
    %anData2012_5 = includeMeteoSwiss(anData2012_5, pathMeteoSwiss2012);
    anData2012_15 = includeMeteoSwiss2012(anData2012_15, pathMeteoSwiss2012);
    anData2012_5 = includeMeteoSwiss2012(anData2012_5, pathMeteoSwiss2012);
    anData2013 = includeMeteoSwiss(anData2013, pathMeteoSwiss2013);
   
    clear tmp
end
%merge2012 files
copyFields2012_5  = fieldnames(anData2012_5);
copyFields2012_15  = fieldnames(anData2012_15);
fieldInBoth = ismember(copyFields2012_5,copyFields2012_15);
ind15 = anData2012_15.timeStart > anData2012_5.timeEnd(end);

clear anData2012
for cnt2 = 1:numel(fieldInBoth)
    if fieldInBoth(cnt2) && ~strcmp(copyFields2012_5{cnt2}, 'Parameter')  && ~strcmp(copyFields2012_5{cnt2}, 'sample')...
            && ~strcmp(copyFields2012_5{cnt2}, 'water') &&  ~strcmp(copyFields2012_5{cnt2}, 'ice')...
            && ~strcmp(copyFields2012_5{cnt2}, 'artefact') && ~strcmp(copyFields2012_5{cnt2}, 'meanIntervall') 
        anData2012.(copyFields2012_5{cnt2}) = [anData2012_5.(copyFields2012_5{cnt2}) ...
            anData2012_15.(copyFields2012_5{ismember(copyFields2012_5,copyFields2012_15{cnt2})})(:,ind15)];
    end
end

sampleFields  = fieldnames(anData2012_5.sample);
anData2012.sample = [];
anData2012.sample.VolumeHolo = anData2012_5.sample.VolumeHolo;
for cnt2 = 2:numel(sampleFields)
    anData2012.sample.(sampleFields{cnt2}) = [anData2012_5.sample.(sampleFields{cnt2}) ...
        anData2012_15.sample.(sampleFields{cnt2})(:,ind15)];
end

anData2012.Parameter = anData2012_5.Parameter;

anData2012.water = [];
anData2012.water.histReal = [anData2012_5.water.histReal anData2012_15.water.histReal(:,ind15)];
anData2012.water.limit = [anData2012_5.water.limit anData2012_15.water.limit(:,ind15)];
anData2012.water.histRealError = [anData2012_5.water.histRealError anData2012_15.water.histRealError(:,ind15)];
anData2012.water.histRealCor = abs([anData2012_5.water.histRealCor anData2012_15.water.histRealCor(:,ind15)]);
anData2012.water.histRealErrorCor = abs([anData2012_5.water.histRealErrorCor anData2012_15.water.histRealErrorCor(:,ind15)]);


anData2012.ice = [];
anData2012.ice.histReal = [anData2012_5.ice.histReal anData2012_15.ice.histReal(:,ind15)];
anData2012.ice.limit = [anData2012_5.ice.limit anData2012_15.ice.limit(:,ind15)];
anData2012.ice.histRealError = [anData2012_5.ice.histRealError anData2012_15.ice.histRealError(:,ind15)];
anData2012.ice.histRealCor = abs([anData2012_5.ice.histRealCor anData2012_15.ice.histRealCor(:,ind15)]);
anData2012.ice.histRealErrorCor = abs([anData2012_5.ice.histRealErrorCor anData2012_15.ice.histRealErrorCor(:,ind15)]);


anData2012.artefact = [];
anData2012.artefact.histReal = [anData2012_5.artefact.histReal anData2012_15.artefact.histReal(:,ind15)];
anData2012.artefact.limit = [anData2012_5.artefact.limit anData2012_15.artefact.limit(:,ind15)];
anData2012.artefact.histRealError = [anData2012_5.artefact.histRealError anData2012_15.artefact.histRealError(:,ind15)];
anData2012.artefact.histRealCor = abs([anData2012_5.artefact.histRealCor anData2012_15.artefact.histRealCor(:,ind15)]);
anData2012.artefact.histRealErrorCor = abs([anData2012_5.artefact.histRealErrorCor anData2012_15.artefact.histRealErrorCor(:,ind15)]);


%merge the files
copyFields2012  = fieldnames(anData2012);
copyFields2013  = fieldnames(anData2013);
fieldInBoth = ismember(copyFields2013,copyFields2012);
for cnt2 = 1:numel(copyFields2013)
    if fieldInBoth(cnt2) && ~strcmp(copyFields2013{cnt2}, 'Parameter')  && ~strcmp(copyFields2013{cnt2}, 'sample')...
            && ~strcmp(copyFields2013{cnt2}, 'water') &&  ~strcmp(copyFields2013{cnt2}, 'ice')...
            && ~strcmp(copyFields2013{cnt2}, 'artefact') && ~strcmp(copyFields2013{cnt2}, 'meanIntervall') 
        anData.(copyFields2013{cnt2}) = [anData2012.(copyFields2013{cnt2}) ...
            anData2013.(copyFields2012{ismember(copyFields2012,copyFields2013{cnt2})})];
    end
end

anData.AzimutDiff = [abs(difference_azimuth(anData2013.ManchRotorWingAzimuthMean,anData2013.ManchRotorWindAzimuthMean)) ...
    abs(anData2012.measMeanDiffAzimutMean)];
anData.ElevationDiff = [abs(anData2013.ManchRotorWingElevationMean - anData2013.ManchRotorWindElevationMean)...
    abs(anData2012.meanElevSonic - anData2012.meanElevRotor)];
anData.isValidFlow = [anData2013.measMeanFlow >50 anData2012.measMeanFlow > 25 ];

sampleFields  = fieldnames(anData2012.sample);
anData.sample = [];
for cnt2 = 1:numel(sampleFields)
    anData.sample.(sampleFields{cnt2}) = [anData2012.sample.(sampleFields{cnt2}) ...
        anData2013.sample.(sampleFields{cnt2})];
end

anData.Parameter = anData2012.Parameter;
anData.water = [];
anData.water.histReal = [anData2012.water.histReal anData2013.water.histReal];
anData.water.limit = [anData2012.water.limit anData2013.water.limit];
anData.water.histRealError = [anData2012.water.histRealError anData2013.water.histRealError];
anData.water.histRealCor = abs([anData2012.water.histRealCor anData2013.water.histRealCor]);
anData.water.histRealErrorCor = abs([anData2012.water.histRealErrorCor anData2013.water.histRealErrorCor]);


anData.ice = [];
anData.ice.histReal = [anData2012.ice.histReal anData2013.ice.histReal];
anData.ice.limit = [anData2012.ice.limit anData2013.ice.limit];
anData.ice.histRealError = [anData2012.ice.histRealError anData2013.ice.histRealError];
anData.ice.histRealCor = abs([anData2012.ice.histRealCor anData2013.ice.histRealCor]);
anData.ice.histRealErrorCor = abs([anData2012.ice.histRealErrorCor anData2013.ice.histRealErrorCor]);


anData.artefact = [];
anData.artefact.histReal = [anData2012.artefact.histReal anData2013.artefact.histReal];
anData.artefact.limit = [anData2012.artefact.limit anData2013.artefact.limit];
anData.artefact.histRealError = [anData2012.artefact.histRealError anData2013.artefact.histRealError];
anData.artefact.histRealCor = abs([anData2012.artefact.histRealCor anData2013.artefact.histRealCor]);
anData.artefact.histRealErrorCor = abs([anData2012.artefact.histRealErrorCor anData2013.artefact.histRealErrorCor]);


%Group by Intervall is valid
isValid = anData.AzimutDiff < 15 & anData.ElevationDiff < 30 & anData.TWCountRaw >20 &  anData.isValidFlow;
anData.oIsValid = ordinal(isValid,{'Valid','notValid'},[1,0]);

%Group by isCloud
isCloud = anData.TWContent > 0.01; %& anData.TWConcentraction > .1;
%isCloud = anData.TWConcentraction > .2;
anData.oIsCloud = ordinal(isCloud,{'Cloud','clear Sky'},[1,0]);

%Group by wind direction
isSouth= anData.meteoWindDir > 45 & anData.meteoWindDir < 225;
anData.oWindDirection = ordinal(isSouth,{'South wind','North wind'},[1,0]);

%Group by year
Y = anData.timeVecStart(1,:);
anData.oYear = ordinal(Y);

%Group by day
Y = anData.timeVecStart(3,:)+1000*(anData.timeVecStart(1,:)-2000)+100*anData.timeVecStart(2,:);
anData.oDay=ordinal(Y);

%Group by cloud cases
anData.oCase = anData.oDay;
anData.oCase(anData.oDay == '12415' & anData.timeVecStart(4,:) < 6) = '12414'; 
anData.oCase(anData.oDay == '12407') = '12406';
anData.oCase = droplevels(anData.oCase);

anData.plotBoxplot = 0;
anData.plotSpectra = 0;
anData.plotIceFraction = 1;
anData.plotRest = 0;
anData.plotCaseScatter = 0;
anData.plotCaseScatterPaper = 1;
anData.plotStatistics =0;
anData.plotPaper = 1;
anData.plotNorthSouth =0;   
anData.plotYang = 0;
    


anData.plotTitle = 0;

anData.chosenDay = '12418';

anData.savePlots = 0;
anData.saveDir = 'Z:\6_Auswertung\ALL\paper';
anData.campaignName = 'JFJ2012/CLACE2013';
anData.chosenData = anData.oIsCloud == 'Cloud' & anData.oIsValid == 'Valid' & anData.oDay ~='12405'; 

anData = plot_statistics(anData);
