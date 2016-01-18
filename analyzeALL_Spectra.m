if ~exist('anData','var');
%     anData2012 = load('F:\ALLDATA\2012_1000sec.mat');    
%     anData2013 = load('F:\ALLDATA\2013_32sec.mat');    
    anData2012 = load('F:\ALLDATA\newHistogram\cleanTimeSerieN2012.mat');    
    anData2013 = load('F:\ALLDATA\newHistogram\cleanTimeSerieN2013.mat');
    anData2012 = anData2012.anDataOut;
    anData2013 = anData2013.anDataOut;
    anData2013{1} = anData2013{2};
end

%merge the files
copyFields2012  = fieldnames(anData2012{1,1});
copyFields2013  = fieldnames(anData2013{1,1});
fieldInBoth = ismember(copyFields2013,copyFields2012);
for cnt2 = 1:numel(copyFields2013)
    if fieldInBoth(cnt2) && ~strcmp(copyFields2013{cnt2}, 'Parameter')
        anData.(copyFields2013{cnt2}) = [anData2013{1,2}.(copyFields2013{cnt2}) ...
            anData2012{1,1}.(copyFields2012{ismember(copyFields2012,copyFields2013{cnt2})})];
    end
end

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

%Group by all
isAll =ones(1,numel(anData.timeStart));
oAll = ordinal(isAll,{'All Data'},1);

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

%Size specta
if 1
    figure(37)
    chosenData = oWindDirection=='North wind' | oWindDirection=='South wind';
    x = anData2013{1}.Parameter.histBinMiddle;
    chosenData=repmat(chosenData,numel(x),1);
    
    subplot(2,3,1)
    
    data = reshape(anData.histRealCor(chosenData),[numel(x) sum(chosenData(1,:))]);    
    dataLimit = reshape(anData.limit(chosenData),[numel(x) sum(chosenData(1,:))]);   
    
    plotSizeSpectraStat( x, data, dataLimit );
    set(gca,'YLim',[.009 500])
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    title('Total')
    ylabel('number density d(N)/d(log d) [cm^{-3}]');
    
    subplot(2,3,2)
    data = [anData.water(1).histRealCor anData.water(2).histRealCor];
    
    data = reshape(data(chosenData),[numel(x) sum(chosenData(1,:))]);    
    dataLimit = reshape(anData.limit(chosenData),[numel(x) sum(chosenData(1,:))]); 
    
    plotSizeSpectraStat( x, data, dataLimit );
    set(gca,'YLim',[.009 500])
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    title('Liquid')
    
    subplot(2,3,3)
    data = [anData.ice(1).histRealCor anData.ice(2).histRealCor];
    data = reshape(data(chosenData),[numel(x) sum(chosenData(1,:))]);    
    dataLimit = reshape(anData.limit(chosenData),[numel(x) sum(chosenData(1,:))]); 
     
    plotSizeSpectraStat( x, data, dataLimit );
    set(gca,'YLim',[.009 500])
    set(gca,'YTick',[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e-0 1e1 1e2 1e3 1e4])
    legend({'2% - 98%';'5% - 95%';'25% - 75%';'50%';'Mean';'Detection Limit'},'Location','NorthEast','FontSize',10)
    title('Ice')
    
    subplot(2,3,4)
    data = anData.histRealCor;
    data=data.*repmat((1/6*pi.*anData2013{1}.Parameter.histBinMiddle.^3)',1,size(data,2));
    dataLimit = anData.limit.*repmat((1/6*pi.*anData2013{1}.Parameter.histBinMiddle.^3)',1,size(anData.histRealCor(:,:),2));
    
    data = reshape(data(chosenData),[numel(x) sum(chosenData(1,:))]);    
    dataLimit = reshape(dataLimit(chosenData),[numel(x) sum(chosenData(1,:))]);    
    
    plotSizeSpectraStat( x, data, dataLimit );
    set(gca,'YLim',[500 800000])
    ylabel('volume density d(V)/d(log d) [cm^{-3}\mum^{3}]');
    
    subplot(2,3,5)
    data = [anData.water(1).histRealCor anData.water(2).histRealCor];
    data=data.*repmat((1/6*pi.*anData2013{1}.Parameter.histBinMiddle.^3)',1,size(data,2));
    dataLimit = anData.limit.*repmat((1/6*pi.*anData2013{1}.Parameter.histBinMiddle.^3)',1,size(anData.histRealCor(:,:),2));
       
    data = reshape(data(chosenData),[numel(x) sum(chosenData(1,:))]);    
    dataLimit = reshape(dataLimit(chosenData),[numel(x) sum(chosenData(1,:))]);    
    
    plotSizeSpectraStat( x, data, dataLimit );
    set(gca,'YLim',[500 800000])
    
    subplot(2,3,6)
    data = [anData.ice(1).histRealCor anData.ice(2).histRealCor];
    data=data.*repmat((1/6*pi.*anData2013{1}.Parameter.histBinMiddle.^3)',1,size(data,2));
    dataLimit = anData.limit.*repmat((1/6*pi.*anData2013{1}.Parameter.histBinMiddle.^3)',1,size(anData.histRealCor(:,:),2));
   
    data = reshape(data(chosenData),[numel(x) sum(chosenData(1,:))]);    
    dataLimit = reshape(dataLimit(chosenData),[numel(x) sum(chosenData(1,:))]);    
    
    plotSizeSpectraStat( x, data, dataLimit );
    set(gca,'YLim',[500 800000])
    
    
end