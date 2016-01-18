clc
close all
folderData = 'G:\Kalibrierung';
choosePlots = [1 5];
% plots
% 1 = Size Distributions
% 2 = Concentraction BoxPlots
% 3 = Relative Concentractions
% 4 = Spatial Distribution
% 5 = Error Sizing
% beadsCases
% 1 = FOGMONITOR 6 um
% 2 = FOGMONITOR 10 um
% 3 = FOGMONITOR 18 um
% 4 = HOLIMO 6 um
% 5 = HOLIMO 10 um
% 6 = HOLIMO 18 um

set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);
for beadsCase = 1:6
    beadsCase
    %Input Fog Monitor Data
    if beadsCase < 4;
        
        FMfolder = 'FOGMONITOR';
        %Files of Fog Monitor Data
        FM_folders=[fullfile(folderData, FMfolder, '2_FM_06um\00FM 10020121025113400.csv');...
            fullfile(folderData, FMfolder, '2_FM_10um\00FM 10020121025142825.csv');...
            fullfile(folderData, FMfolder, '2_FM_18um\00FM 10020121025155514.csv');...
            ];
        
        %Read in
        for i=beadsCase:beadsCase%size(FM_folders,1)
            %Read in of FM Data from File
            FM_file=fopen(FM_folders(i,:));
            FM_header=textscan(FM_file,'%s',56,'Delimiter',',','HeaderLines',71);
            FM_data=textscan(FM_file,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%10s%11s','Delimiter',',','HeaderLines',72);
            fclose(FM_file);
            
            for m = 1:length(FM_data)
                %         if (i==1)
                %Assign Variable Name
                assignin('base', genvarname(['FM_' regexprep(FM_header{1,1}{m},{'\W','^_*'},{'_',''})]), FM_data{1,m}(:));
                %         else
                %             %Put All Data in one Variable
                %             tmp=['FM_' regexprep(FM_header{1,1}{m},{'\W','^_*'},{'_',''})];
                %             tmp2=[num2str(tmp),'=[',num2str(tmp),';FM_data{1,m}(:)];'];
                %             eval(tmp2);
                %         end
            end
        end
        
        %Create FogMonitor Date Vector and Serial Date Numbers
        FM_Date2=[FM_Year zeros(size(FM_Date)) FM_Day_Of_Year zeros(size(FM_Date)) zeros(size(FM_Date)) FM_End_Seconds];
        FM_Date_Num=datenum(FM_Date2);
        FM_Date_Num_All{beadsCase}=FM_Date_Num;
        FM_Date_Vec=datevec(FM_Date_Num);
        FM_Date_Vec_all{beadsCase}=FM_Date_Vec;
    end
    
    
    %input APS
    APSfolder = 'APS';
    if beadsCase < 4;
        APSfolder2 = 'Fogmonitor';
    else
        APSfolder2 = 'Holimo';
    end
    switch beadsCase
        case 1
            APSfilename = '2Fogmonitor_OPC_06um.txt';
        case 2
            APSfilename = '2Fogmonitor_OPC_10um.txt';
        case 3
            APSfilename = '2Fogmonitor_OPC_18um.txt';
        case 4
            APSfilename = '2Holimo_OPC_6um_.txt';
        case 5
            APSfilename = '3Holimo_APC_10um.txt';
        case 6
            APSfilename = '2Holimo_OPC_18um.txt';
    end
    
    APSfile=fopen(fullfile(folderData, APSfolder, APSfolder2 ,APSfilename));
    APSSampleFile = textscan(APSfile,'%*s %s',1,'Delimiter','\t');
    APSSampleTime = textscan(APSfile,'%*s %d',1,'Delimiter','\t');
    APSDensity{beadsCase}= textscan(APSfile,'%*s %f',1,'Delimiter','\t');
    APSStokesCorrection{beadsCase} = textscan(APSfile,'%*s %s',1,'Delimiter','\t');
    APSLowerChannelBound = textscan(APSfile,'%*s %f',1,'Delimiter','\t');
    APSUpperChannelBound = textscan(APSfile,'%*s %f',1,'Delimiter','\t');
    APSSampleNumber = textscan(APSfile,'%*s%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d',1,'Delimiter','\t');
    APSDate=textscan(APSfile,'%*s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s', 1,'Delimiter','\t');
    APSTime=textscan(APSfile,'%*s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s', 1,'Delimiter','\t');
    APStmp=textscan(APSfile,'%*s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s', 1,'Delimiter','\t');
    APSRawData = textscan(APSfile,'%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',52,'Delimiter','\t');
    
    fclose(APSfile);
    clear APSDateVec
    for cnt = 1 : numel(APSDate)
        APSDateVec(cnt,:) = datevec([char(APSDate{cnt}),' ', char(APSTime{cnt})]);
    end
    
    APSDateNum = datenum(APSDateVec);
    
    APSDiameter = APSRawData{1};
    APSDiameter{1} = APSDiameter{1}(2:end);
    APSDiameter = str2num(cell2mat(APSDiameter));
    %density correction
    APSDiameter = APSDiameter*(1/1.18)^(1/2);
    
    APSConc = APSRawData(2:end);
    APSConc = cell2mat(APSConc);
    
    APSConcMean = mean(APSConc,2);
    
    %input CPC
    if ~exist('CPCData');
        CPCfolder = 'CPC';
        % if beadsCase < 4;
        %     CPCfolder2 = 'Fogmonitor';
        % else
        %     CPCfolder2 = 'Holimo';
        % end
        % switch beadsCase
        %     case 1
        %         CPCfilename = 'Fogmonitor_OPC_6um.txt';
        %     case 2
        %         CPCfilename = 'Fogmonitor_OPC_10um_2.txt';
        %     case 3
        %         CPCfilename = 'Fogmonitor_OPC_18um.txt';
        %     case 4
        %         CPCfilename = 'HOLIMO_OPC_6um.txt';
        %     case 5
        %         CPCfilename = 'HOLIMO_OPC_10um_4.txt';
        %     case 6
        %         CPCfilename = 'HOLIMO_OPC_18um_2.txt';
        % end
        
        CPCfilename = '2Holimo_OPC_6um.txt';
        
        CPCfile=fopen(fullfile(folderData, CPCfolder ,CPCfilename));
        CPCSampleFile = textscan(CPCfile,'%*s %s',1,'Delimiter','\t');
        textscan(CPCfile,'%*s %s',3,'Delimiter','\t');
        CPCDate = textscan(CPCfile,'%*s %s',1,'Delimiter','\t');
        textscan(CPCfile,'%*s %s',1,'Delimiter','\t');
        textscan(CPCfile,'%*s %s',1,'Delimiter','\t');
        textscan(CPCfile,'%s %s',1,'Delimiter','\n');
        CPCAveraging = textscan(CPCfile,'%*s %d',1,'Delimiter','\t');
        textscan(CPCfile,'%s',11,'Delimiter','\n');
        CPCData = textscan(CPCfile,'%s %d','Delimiter','\t');
        fclose(CPCfile);
        
        CPCTime = CPCData{1};
        CPCTime = CPCTime(1:end-1);
        CPCConc = CPCData{2};
        CPCConc = CPCConc(1:end-1);
        clear CPCDateVec
        for cnt = 1 : numel(CPCTime)
            CPCDateVec(cnt,:) = datevec([char(CPCDate{1}),' ', char(CPCTime{cnt})]);
        end
        CPCDateNum = datenum(CPCDateVec);
    end
    
    %input HOLIMO
    HOLIMOfolder = 'HOLIMO';
    if beadsCase > 3
        switch beadsCase
            case 4
                HOLIMOfolder2 = '2-13-40';
            case 5
                HOLIMOfolder2 = '3-14-55';
            case 6
                HOLIMOfolder2 = '2-15-45';
        end
        HOLIMOStatsFolder = fullfile(folderData, HOLIMOfolder, HOLIMOfolder2,'ParticleStats');
        if beadsCase == 5
            HOLIMOfileNames = dir(fullfile(HOLIMOStatsFolder, '*run20*'));
        elseif beadsCase == 6
            HOLIMOfileNames = dir(fullfile(HOLIMOStatsFolder, '*run3*'));
        else
            HOLIMOfileNames = dir(fullfile(HOLIMOStatsFolder, '*run3*'));
        end
        HOLIMOfileNames = {HOLIMOfileNames.name};
        clear HOLIMOData
        clear histReal
        clear edges2
        clear middle2
        clear limit2
        for cnt = 1:numel(HOLIMOfileNames)
            tmp = load(fullfile(HOLIMOStatsFolder, HOLIMOfileNames{cnt}));
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
            month = 10;
            
            temp1 = ones(1, indParticle)*year;
            temp2 = ones(1, indParticle)*month;
            temp3 = [temp1; temp2];
            HOLIMOData{cnt}.timeVec=[temp3; HOLIMOData{cnt}.timeVec];
            %Shift HOLIMO timeVec 2h ahead
            if beadsCase == 5
                HOLIMOData{cnt}.timeVec=[HOLIMOData{cnt}.timeVec(1,:); HOLIMOData{cnt}.timeVec(2,:)+1;
                HOLIMOData{cnt}.timeVec(3,:); HOLIMOData{cnt}.timeVec(4,:)+1; HOLIMOData{cnt}.timeVec(5,:); ...
                HOLIMOData{cnt}.timeVec(6,:); HOLIMOData{cnt}.timeVec(7,:)];
            else
                HOLIMOData{cnt}.timeVec=[HOLIMOData{cnt}.timeVec(1,:); HOLIMOData{cnt}.timeVec(2,:);
                HOLIMOData{cnt}.timeVec(3,:); HOLIMOData{cnt}.timeVec(4,:)+2; HOLIMOData{cnt}.timeVec(5,:); ...
                HOLIMOData{cnt}.timeVec(6,:); HOLIMOData{cnt}.timeVec(7,:)];
            end
            HOLIMOTimeVecStart{beadsCase}(cnt,:) = HOLIMOData{cnt}.timeVec(:,1);
            HOLIMOTimeStart{beadsCase}(cnt,:) = datenum(HOLIMOData{cnt}.timeVec(1:6,1)');
            divideSize = 8;
            maxSize = 35;
            bigInd = 15;
            
%             smallBorder = (( 0.5 : 2389.5)*HOLIMOData{cnt}.cfg.dx*HOLIMOData{cnt}.cfg.dy*4/pi).^(1/2)*1000000;          
%             
%             divideInd = find(smallBorder > divideSize, 1 ,'first');
%             bigBorder = logspace(log10(smallBorder(divideInd)),log10(maxSize),bigInd);
%             partBorder = [smallBorder(1:(divideInd-1)) bigBorder];
            
            partBorder = (( 0.5 : 99.5)*HOLIMOData{cnt}.cfg.dx*HOLIMOData{cnt}.cfg.dy*4/pi).^(1/2)*1000000;
            [histReal{cnt}, edges2{cnt}, middle2{cnt}, limit2{cnt}] = histogram(HOLIMOData{cnt}.pDiam(HOLIMOData{cnt}.partIsReal)*1000000, HOLIMOData{cnt}.sampleVolumeAll, partBorder);
        end
        HOLIMODataAll{beadsCase}=HOLIMOData;
        
        
    %input SynData
    HOLIMOfolder = 'D:\HOLIMO_synthetisch\ParticleStats';
    if beadsCase > 3
        if beadsCase == 4
            HOLIMOfileNames = fullfile(HOLIMOfolder, 'PartStats_Syn06um_ps.mat');
        elseif beadsCase == 5
            HOLIMOfileNames = fullfile(HOLIMOfolder, 'PartStats_Syn10um_ps.mat');
        else
            HOLIMOfileNames = fullfile(HOLIMOfolder, 'PartStats_Syn18um_ps.mat');
        end
       
        clear HOLIMOSyn
    
        for cnt = 1
            tmp = load(HOLIMOfileNames);
            HOLIMOSyn{cnt} = tmp.dataParticle;
            clear tmp
            
            HOLIMOSyn{cnt}.sampleSize.x      = (HOLIMOSyn{cnt}.Nx - HOLIMOSyn{cnt}.parameter.borderPixel)*HOLIMOSyn{cnt}.cfg.dx;
            HOLIMOSyn{cnt}.sampleSize.y      = (HOLIMOSyn{cnt}.Ny - HOLIMOSyn{cnt}.parameter.borderPixel)*HOLIMOSyn{cnt}.cfg.dy;
            HOLIMOSyn{cnt}.sampleSize.z      = HOLIMOSyn{cnt}.parameter.lmaxZ - HOLIMOSyn{cnt}.parameter.lminZ;
            HOLIMOSyn{cnt}.sampleVolumeHolo  = HOLIMOSyn{cnt}.sampleSize.x * HOLIMOSyn{cnt}.sampleSize.y * HOLIMOSyn{cnt}.sampleSize.z;
            HOLIMOSyn{cnt}.sampleNumber      = HOLIMOSyn{cnt}.indHolo(end);
            HOLIMOSyn{cnt}.sampleVolumeAll   = HOLIMOSyn{cnt}.sampleVolumeHolo * HOLIMOSyn{cnt}.sampleNumber;
            
            nanParticleInd = find(isnan(HOLIMOSyn{cnt}.partIsSatelite));
            HOLIMOSyn{cnt}.partIsSatelite(nanParticleInd) = 1;
            HOLIMOSyn{cnt}.partIsBorder(nanParticleInd) = 1;
            
            HOLIMOSyn{cnt}.partIsReal     = ~HOLIMOSyn{cnt}.partIsSatelite & ~HOLIMOSyn{cnt}.partIsBorder;
            HOLIMOSyn{cnt}.realInd = find(HOLIMOSyn{cnt}.partIsReal);
            
            divideSize = 8;
            maxSize = 35;
            bigInd = 15;
            
%             smallBorder = (( 0.5 : 2389.5)*HOLIMOSyn{cnt}.cfg.dx*HOLIMOSyn{cnt}.cfg.dy*4/pi).^(1/2)*1000000;          
%             
%             divideInd = find(smallBorder > divideSize, 1 ,'first');
%             bigBorder = logspace(log10(smallBorder(divideInd)),log10(maxSize),bigInd);
%             partBorder = [smallBorder(1:(divideInd-1)) bigBorder];
            
            partBorder = (( 0.5 : 99.5)*HOLIMOSyn{cnt}.cfg.dx*HOLIMOSyn{cnt}.cfg.dy*4/pi).^(1/2)*1000000;
            [histRealSyn{cnt}, edges2{cnt}, middle2{cnt}, limit2{cnt}] = histogram(HOLIMOSyn{cnt}.pDiam(HOLIMOSyn{cnt}.partIsReal)*1000000, HOLIMOSyn{cnt}.sampleVolumeAll, partBorder);
        end
        HOLIMOSynAll{beadsCase}=HOLIMOSyn;
    end
        
    end
    
%     % timeing
%     'APS'
%     APSDateVec(1,:)
%     APSDateVec(end,:)
%     'CPC'
%     CPCDateVec(1,:)
%     CPCDateVec(end,:)
%     
%     if beadsCase < 4
%         'FM'
%         FM_Date_Vec(1,:)
%          FM_Date_Vec(end,:)
%     else
%         'HOLIMO'
%         HOLIMOData{1}.timeVec(:,1)'
%         HOLIMOData{end}.timeVec(:,end)'
%     end
    if beadsCase < 4
        startTimeVec = [FM_Date_Vec(1,:); APSDateVec(1,:)];
        endTimeVec = [FM_Date_Vec(end,:); APSDateVec(end,:)];
        startTime = [FM_Date_Num(1) APSDateNum(1)];
        endTime = [FM_Date_Num(end) APSDateNum(end)];
        goodEndTime = min(endTime);
        goodStartTime = max(startTime);
        goodSampleTime = (goodEndTime-goodStartTime)*60*60*24
        
        FMgoodInd = find(FM_Date_Num >= goodStartTime & FM_Date_Num <= goodEndTime);
        x_counter=1:numel(FMgoodInd);
        FM_Sizes=[2,4,6,8,10,12,14,16,18,20,23,26,29,32,35,38,41,44,47,50];
        binFirst = 2*FM_Sizes(1) - FM_Sizes(2);
        binLast = 2*FM_Sizes(end) - FM_Sizes(end-1);
        tmp1 = [binFirst  FM_Sizes];
        tmp2 = [FM_Sizes  binLast];
        FM_BinBorders = (tmp1+tmp2)/2;
        FM_BinSize = FM_BinBorders(2:end)-FM_BinBorders(1:end-1);
        
        
        z=ones(length(x_counter),1);
        FM_CountsSum=zeros(1,20);
        for i=1:20
            tmp=['sum(FM_FM_100_Bin_',num2str(i),')'];
            tmp = eval(tmp);
            FM_CountsSum(1,i)=tmp;
        end
        FM_SampleArea = 0.24/1000000;
        FM_SampleSpeed = 11;
        FM_SampleVolume = FM_SampleArea*FM_SampleSpeed*goodSampleTime;
        FM_Conc = FM_CountsSum./FM_SampleVolume/1000000*96;
        FM_ConcCor = FM_Conc./FM_BinSize;
        FM_ConcCorAll(beadsCase,:) = FM_ConcCor;
    else
%         startTimeVec = [APSDateVec(1,:)];
%         endTimeVec = [APSDateVec(end,:)];
%         startTime = [APSDateNum(1)];
%         endTime = [APSDateNum(end)];
        startTimeVec = [HOLIMOData{1}.timeVec(1:6,1)'; APSDateVec(1,:)];
        endTimeVec = [HOLIMOData{end}.timeVec(1:6,end)';  APSDateVec(end,:)];
        startTime = [datenum(HOLIMOData{1}.timeVec(1:6,1)')  APSDateNum(1)];
        endTime = [datenum(HOLIMOData{end}.timeVec(1:6,end)')  APSDateNum(end)];
        
        goodEndTime = min(endTime);
        goodStartTime = max(startTime);
        %check if good time is limited by HOLIMO
        (goodStartTime - datenum(HOLIMOData{1}.timeVec(1:6,1)'))*60*60*24
        (goodEndTime - datenum(HOLIMOData{end}.timeVec(1:6,end)'))*60*60*24
        (goodEndTime-goodStartTime)*60*60*24
    end
    
    %Concentrations
    APSgoodInd = find(APSDateNum >= goodStartTime & APSDateNum <= goodEndTime);
    APSDateVecGood = APSDateVec(APSgoodInd,:);
    APSDateNumGood = APSDateNum(APSgoodInd);
    APSDateVecAll{beadsCase}=APSDateVecGood;
    APSDateNumAll{beadsCase}=APSDateNumGood;
    APSConcGood=APSConc(:,APSgoodInd);
    
    if beadsCase < 4
        %FogMonitor
        FM_Con06 =  sum(FM_Conc(FM_Sizes > 4 & FM_Sizes < 8));
        FM_Con10 =  sum(FM_Conc(FM_Sizes > 8 & FM_Sizes < 14));
        FM_Con18 =  sum(FM_Conc(FM_Sizes > 14 & FM_Sizes < 25));
        FM_ConAll(beadsCase) = FM_Con06 + FM_Con10 +FM_Con18;
    else
        %HOLIMO
        clear HOLInt06;
        clear HOLCon06;
        clear HOLMeand06;
        clear HOLInt10;
        clear HOLCon10;
        clear HOLMeand10;
        clear HOLInt18;
        clear HOLCon18;
        clear HOLMeand18;
        for cnt = 1:numel(HOLIMOData)
            HOLInt06{cnt} =  HOLIMOData{cnt}.pDiam > 4e-6 & HOLIMOData{cnt}.pDiam < 8e-6;
            HOLCon06(cnt) = sum(HOLInt06{cnt})/HOLIMOData{cnt}.sampleVolumeAll/1e6;
            HOLMeand06(cnt) =  mean(HOLIMOData{cnt}.pDiam(HOLInt06{cnt}));
            HOLInt10{cnt} =  HOLIMOData{cnt}.pDiam > 8e-6 & HOLIMOData{cnt}.pDiam < 14e-6;
            HOLCon10(cnt) = sum(HOLInt10{cnt})/HOLIMOData{cnt}.sampleVolumeAll/1e6;
            HOLMeand10(cnt) =  mean(HOLIMOData{cnt}.pDiam(HOLInt10{cnt}));
            HOLInt18{cnt} =  HOLIMOData{cnt}.pDiam > 14e-6 & HOLIMOData{cnt}.pDiam < 25e-6;
            HOLCon18(cnt) = sum(HOLInt18{cnt})/HOLIMOData{cnt}.sampleVolumeAll/1e6;
            HOLMeand18(cnt) =  mean(HOLIMOData{cnt}.pDiam(HOLInt18{cnt}));        
        end
        HOLConAll{beadsCase} =HOLCon06 + HOLCon10 + HOLCon18;
        
        HOLCon06mean = mean(HOLCon06);
        HOLCon10mean = mean(HOLCon10);
        HOLCon18mean = mean(HOLCon18);
        HOLConAllmean(beadsCase) = mean(HOLConAll{beadsCase});
        
        HOLMeand06Mean = mean(HOLMeand06);
        HOLMeand10Mean = mean(HOLMeand10);
        HOLMeand18Mean = mean(HOLMeand18);
        
        HOLData{beadsCase}.pDiam = [];
        HOLData{beadsCase}.xPos = [];        
        HOLData{beadsCase}.yPos = [];        
        HOLData{beadsCase}.zPos = [];
        for cnt = 1:numel(HOLIMOData)
            HOLData{beadsCase}.pDiam = [HOLData{beadsCase}.pDiam  HOLIMOData{cnt}.pDiam];
            HOLData{beadsCase}.xPos = [HOLData{beadsCase}.xPos  HOLIMOData{cnt}.xPos];
            HOLData{beadsCase}.yPos = [HOLData{beadsCase}.yPos  HOLIMOData{cnt}.yPos];
            HOLData{beadsCase}.zPos = [HOLData{beadsCase}.zPos  HOLIMOData{cnt}.zPos];          
            
        end
        
    end
    
    
    
    %APS
    binFirst = 2*APSDiameter(1) - APSDiameter(2);
    binLast = 2*APSDiameter(end) - APSDiameter(end-1);
    tmp1 = [binFirst; APSDiameter];
    tmp2 = [APSDiameter; binLast];
    APSBinBorders = (tmp1+tmp2)/2;
    APSBinSize = APSBinBorders(2:end)-APSBinBorders(1:end-1);
    
    APSConcUn = APSConcGood .* repmat(APSBinSize,1,size(APSConcGood,2));
    APSCon06 = sum(APSConcUn(APSDiameter > 4 & APSDiameter < 8,:));
    APSCon10 = sum(APSConcUn(APSDiameter > 8 & APSDiameter < 14,:));
    APSCon18 = sum(APSConcUn(APSDiameter > 14 & APSDiameter < 25,:));
    APSConAll{beadsCase} = APSCon06 + APSCon10 + APSCon18;
    
    APSConcUnMean = APSConcMean .* APSBinSize;
    APSCon06mean = sum(APSConcUnMean(APSDiameter > 4 & APSDiameter < 8));
    APSCon10mean = sum(APSConcUnMean(APSDiameter > 8 & APSDiameter < 14));
    APSCon18mean = sum(APSConcUnMean(APSDiameter > 14 & APSDiameter < 25));
    APSConAllmean(beadsCase) = APSCon06mean + APSCon10mean + APSCon18mean;
    
    tmp = APSConcUn .* repmat(APSDiameter,1,size(APSConcGood,2));
    APSMeand06 = sum(tmp(APSDiameter > 4 & APSDiameter < 8,:))./APSCon06;
    APSMeand10 = sum(tmp(APSDiameter > 8 & APSDiameter < 14,:))./APSCon10;
    APSMeand18 = sum(tmp(APSDiameter > 14 & APSDiameter < 25,:))./APSCon18;
    
    APSMeand06Mean = mean(APSMeand06);
    APSMeand10Mean = mean(APSMeand10);
    APSMeand18Mean = mean(APSMeand18);
    
    %CPC
    CPCgoodInd = find(CPCDateNum >= goodStartTime & CPCDateNum <= goodEndTime);
    CPCConMean(beadsCase) = mean(CPCConc(CPCgoodInd));
    CPCConStd(beadsCase) = std(double(CPCConc(CPCgoodInd)));
    
    
    %% figures
    if any(choosePlots == 1)
        figure(beadsCase)
        
        errorbar(APSDiameter,mean(APSConcGood,2),std(APSConcGood,1,2),'r','LineWidth',2)
        hold on
        APSConcAllMean(beadsCase,:) = mean(APSConcGood,2);
        APSConcAllStd(beadsCase,:) = std(APSConcGood,1,2);
        
        % OPCgoodInd = find(OPCDateNum >= goodStartTime & OPCDateNum <= goodEndTime);
        % OPCChannels = 1:256;
        % OPCDiameter = OPCFitFun(OPCChannels);
        % tmp = OPCDiameter;
        % tmp2 = OPCDiameter;
        % tmp(1) = [];
        % tmp2(end) = [];
        % OPCBinSizes = tmp - tmp2;
        % OPCBinSizes = [OPCBinSizes(1) OPCBinSizes];
        % OPCGoodData = OPCdata(OPCgoodInd,:);
        % OPCConc = OPCGoodData/1000./repmat(OPCBinSizes,size(OPCGoodData,1),1);
        % OPCError = std(OPCConc,1,1);
        % OPCError(find(mod(1:length(OPCError),10)>0))=NaN;
        % % errorbar(OPCDiameter, mean(OPCConc,1),...
        % %     OPCError,'g','LineWidth',2)
        % plot(OPCDiameter,mean(OPCConc,1),'g','LineWidth',2)
        % hold on
        
        if beadsCase < 4
            %mean Sucking Speed = 14.08 m/s
            %diameter inelt = 38 mm
            %Flow --> 960l/min
            %Correction Factor: *96
            
            plot(FM_Sizes, FM_ConcCor, ...
                'LineWidth',2);
            hold on
        else
            %Flow HOLIMO = 11.78 l/min --> 10 l/min with Particle 1.78 l/min shead
            %Air --> Correction factor *1.178
            %     for cnt = 1:numel(HOLIMOData)
            %     histReal{cnt} = histReal{cnt} * 1.178;
            %     plot(middle2{cnt}, histReal{cnt},'LineWidth',2);
            %     hold on
            %     end
            clear histRealArray
            clear middle2Array
            for cnt = 1:numel(HOLIMOSyn)
                %histReal{cnt} = histReal{cnt} * 1.178;
                histRealArraySyn(cnt,:) = histRealSyn{cnt};                
                histRealArrayAllSyn{beadsCase} = histRealArraySyn;
                middle2ArraySyn(cnt,:) = middle2{cnt};
            end
            errorbar(middle2ArraySyn(1,:),mean(histRealArraySyn,1),std(histRealArraySyn,1,1),'b','LineWidth',2)
            %plot(mean(middle2Array,1), mean(histRealArray,1),'LineWidth',2);
            hold on
        end
        
        % if beadsCase < 4
        %     [FMPeakConc FMPeakInd] = findpeaks(FM_ConcCor,'Threshold',.1,'MINPEAKDISTANCE',2);
        %     scatter(FM_Sizes(FMPeakInd), FMPeakConc);
        %     hold on
        %     for n = 1:numel(FMPeakConc)
        %         text(FM_Sizes(FMPeakInd(n)), FMPeakConc(n), num2str(FM_Sizes(FMPeakInd(n))));
        %     end
        % else
        %     for cnt = 1:numel(HOLIMOData)
        %         [HOLIMOPeakConc{cnt} HOLIMOPeakInd{cnt}] = findpeaks(histReal{cnt},'Threshold',.1,'MINPEAKDISTANCE',2);
        %         scatter(middle2{cnt}(HOLIMOPeakInd{cnt}), HOLIMOPeakConc{cnt});
        %         hold on
        %         for n = 1:numel(HOLIMOPeakConc{cnt})
        %             text(middle2{cnt}(HOLIMOPeakInd{cnt}(n)), HOLIMOPeakConc{cnt}(n), num2str(middle2{cnt}(HOLIMOPeakInd{cnt}(n))));
        %         end
        %     end
        % end
        % [APSPeakConc APSPeakInd] = findpeaks(mean(APSConcGood,2),'Threshold',.1);
        % scatter(APSDiameter(APSPeakInd), APSPeakConc);
        % hold on
        % for n = 1:numel(APSPeakConc)
        %     text(APSDiameter(APSPeakInd(n)), APSPeakConc(n), num2str(APSDiameter(APSPeakInd(n))));
        % end
        hold off
        
        CPCgoodInd = find(CPCDateNum >= goodStartTime & CPCDateNum <= goodEndTime);
        
        %Beads
        line([6.29 6.29],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');
        line([6.4 6.4],[0.001 100],'LineStyle','-','LineWidth',2,'Color','c');
        line([6.51 6.51],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');
        line([10.06 10.06],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');
        line([10.25 10.25],[0.001 100],'LineStyle','-','LineWidth',2,'Color','c');
        line([10.44 10.44],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');
        line([17.89 17.89],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');
        line([18.23 18.23],[0.001 100],'LineStyle','-','LineWidth',2,'Color','c');
        line([18.57 18.57],[0.001 100],'LineStyle','--','LineWidth',1,'Color','c');
        
        % if beadsCase < 4
        % else
        %     %HOLIMO
        %     line([HOLMeand06Mean*1e6 HOLMeand06Mean*1e6],[0.001 100],'LineStyle','-','LineWidth',2,'Color','b');
        %     line([HOLMeand10Mean*1e6 HOLMeand10Mean*1e6],[0.001 100],'LineStyle','-','LineWidth',2,'Color','b');
        %     line([HOLMeand18Mean*1e6 HOLMeand18Mean*1e6],[0.001 100],'LineStyle','-','LineWidth',2,'Color','b');
        % end
        %
        % %APS
        % line([APSMeand06Mean APSMeand06Mean],[0.001 100],'LineStyle','-','LineWidth',2,'Color','r');
        % line([APSMeand10Mean APSMeand10Mean],[0.001 100],'LineStyle','-','LineWidth',2,'Color','r');
        % line([APSMeand18Mean APSMeand18Mean],[0.001 100],'LineStyle','-','LineWidth',2,'Color','r');
        xlim([0 22]);
        
        ylim([0.001 100]);
        
        xlabel('diameter [um]');
        ylabel('number density d(N)/d(log d) [cm^{-3}*\mum]');
        set(gca,'YScale','log');
        set(gca,'XGrid','on','XMinorGrid','on','LineWidth',0.5)
        %set(gca,'XScale','log');
        
        CPCString = ['CPC: (' num2str(mean(CPCConc(CPCgoodInd))) ' +-' num2str(std(double(CPCConc(CPCgoodInd)))) ') 1/cm^3'];
        
        
        set(gcf, 'PaperUnits','centimeters');
        set(gcf, 'PaperPosition',[0 0 17 12]);
        set(gcf, 'PaperSize', [10 10]);
        
        switch beadsCase
            case 1
                title(['Fogmonitor 6 um -----' CPCString]);
                legend('APS','Fogmonitor')
                print('-dpng','-r600', 'SizeDistribution_FM06')
            case 2
                title(['Fogmonitor 10 um -----' CPCString]);
                legend('APS','Fogmonitor')
                print('-dpng','-r600', 'SizeDistribution_FM10')
            case 3
                title(['Fogmonitor 18 um -----' CPCString]);
                legend('APS','Fogmonitor')
                print('-dpng','-r600', 'SizeDistribution_FM18')
            case 4
                title(['HOLIMO 6 um -----' CPCString]);
                legend('APS','HOLIMO')
                print('-dpng','-r600', 'SizeDistribution_HOL06')
            case 5
                title(['HOLIMO 10 um -----' CPCString]);
                legend('APS','HOLIMO')
                print('-dpng','-r600', 'SizeDistribution_HOL10')
            case 6
                title(['HOLIMO 18 um -----' CPCString]);
                legend('APS','HOLIMO')
                print('-dpng','-r600', 'SizeDistribution_HOL18')
        end
    end
    
    if any(choosePlots == 4) && beadsCase >=4
        
        figure(beadsCase+8);
        clf;
        subplot(3,2,1);
        hold on;
        data = HOLIMODataAll{beadsCase}{5};
        [a b] = hist(data.xPos(data.partIsReal).*1e3,30);
        a = a./(sum(a)/numel(a))-1;
        bar(b,a)
        xlim([-2.2 2.2]);
        ylim([-.2 .2]);
        title('Y position frequency');
        xlabel('Y Position (mm)');
        ylabel('Relative Count');
        
        subplot(3,2,3);
        hold on;
        [a b] = hist(data.yPos(data.partIsReal).*1e3,30);
        a = a./(sum(a)/numel(a))-1;
        bar(b,a)
        xlim([-1.8 1.8]);
        ylim([-.2 .2]);
        title('X position frequency');
        xlabel('X Position (mm)');
        ylabel('Relative Count');
        
        subplot(3,2,5);
        hold on;
        [a b] = hist(data.zPos(data.partIsReal).*1e3,30);
        a = a./(sum(a)/numel(a))-1;
        bar(b,a)
        ylim([-.4 .4]);
        title('Z position frequency');
        xlabel('Z Position (mm)');
        ylabel('Relative Count');
        
        subplot(3,2,[2 4 6]);
        bln = .1e-3;
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
        
        switch beadsCase
            case 1
                mtit(['Fogmonitor 6 um']);
                %print('-dpng','-r600', 'SizeDistribution_FM06')
            case 2
                mtit(['Fogmonitor 10 um'])
                %print('-dpng','-r600', 'SizeDistribution_FM10')
            case 3
                mtit(['Fogmonitor 18 um']);
                %print('-dpng','-r600', 'SizeDistribution_FM18')
            case 4
                mtit(['HOLIMO 6 um']);
                %print('-dpng','-r600', 'SizeDistribution_HOL06')
            case 5
                mtit(['HOLIMO 10 um']);
                %print('-dpng','-r600', 'SizeDistribution_HOL10')
            case 6
                mtit(['HOLIMO 18 um']);
                %print('-dpng','-r600', 'SizeDistribution_HOL18')
        end
    end
end

%boxplot
if any(choosePlots == 2)
    figure(7)
    
    group = [ones(size(HOLConAll{4})),ones(size(FM_ConAll(1)))+1,...
        ones(size(HOLConAll{5}))+2,ones(size(FM_ConAll(2)))+3,...
        ones(size(HOLConAll{6}))+4,ones(size(FM_ConAll(3)))+5];
    data = cat(2,HOLConAll{4},FM_ConAll(1),HOLConAll{5},FM_ConAll(2),HOLConAll{6},FM_ConAll(3));
    boxplot(data,group,'labels', {' ',' ',' ',' ',' ',' '});
    hold on
    %set(gca,'XTickLabel',{'HOL 6\mum', 'HOL 10\mum', 'HOL 18\mum'})
    group = [ones(size(APSConAll{4})),ones(size(APSConAll{1}))+1,...
        ones(size(APSConAll{5}))+2,ones(size(APSConAll{2}))+3,...
        ones(size(APSConAll{6}))+4,ones(size(APSConAll{3}))+5];
    data = cat(2,APSConAll{4},APSConAll{1},APSConAll{5},APSConAll{2},APSConAll{6},APSConAll{3});
    boxplot(data,group,'colors','g','labels',{'HOL 6 um', 'FM 6 um', 'HOL 10 um',...
        'FM 10 um', 'HOL 18 um', 'FM 18 um'});
    print('-dpng','-r600', 'Concentraction_boxplot')
end

%boxplot
if any(choosePlots == 3)
    figure(8)
    for bCase=1:3
        FMRelCon(bCase) = FM_ConAll(bCase)/APSConAllmean(bCase);
    end
    RelCon = FMRelCon;
    for bCase=4:6
        clear APSConCom
        for measInt = 1:length(HOLIMODataAll{bCase})
            HOLIMODataAll{bCase}{measInt}.timeVec(1:6,1)';
            HOLStart = datenum(HOLIMODataAll{bCase}{measInt}.timeVec(1:6,1)');
            APSInd = find(APSDateNumAll{bCase} >= HOLStart,1);
            if isempty(APSInd)
                APSInd = length(APSDateNumAll{bCase});
            end
            APSConCom(measInt) = APSConAll{bCase}(APSInd);
        end
        APSConComAll{bCase} = APSConCom;
        HOLRelCon{bCase} = HOLConAll{bCase}./APSConComAll{bCase};
        HOLRelConMean(bCase) = mean(HOLRelCon{bCase});
        HOLRelConStd(bCase) = std(HOLRelCon{bCase});
    end
    RelCon(4:6) = HOLRelConMean(4:6);
    group = [ones(size(HOLRelCon{4})),ones(size(FMRelCon(1)))+1,...
        ones(size(HOLRelCon{5}))+2,ones(size(FMRelCon(2)))+3,...
        ones(size(HOLRelCon{6}))+4,ones(size(FMRelCon(3)))+5];
    data = cat(2,HOLRelCon{4},FMRelCon(1),HOLRelCon{5},FMRelCon(2),HOLRelCon{6},FMRelCon(3));
    bp = boxplot(data,group,'labels', {'HOL 6 um', 'FM 6 um', 'HOL 10 um',...
        'FM 10 um', 'HOL 18 um', 'FM 18 um'});
    set(bp,'linewidth',2);
    line([0 7],[1 1],[-1 -1],'LineStyle','--','color','b','linewidth',2);
    ylabel('Concentration measured relativ to APS');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[0 0 17 12]);
    set(gcf, 'PaperSize', [10 10]);
    print('-dpng','-r600', 'RelConcentraction_boxplot')
    %     group = [ones(size(HOLConAll{4})),ones(size(FM_ConAll(1)))+1,...
    %         ones(size(HOLConAll{5}))+2,ones(size(FM_ConAll(2)))+3,...
    %         ones(size(HOLConAll{6}))+4,ones(size(FM_ConAll(3)))+5];
    %     data = cat(2,HOLConAll{4},FM_ConAll(1),HOLConAll{5},FM_ConAll(2),HOLConAll{6},FM_ConAll(3));
    %     boxplot(data,group,'labels', {' ',' ',' ',' ',' ',' '});
    %     hold on
    %     %set(gca,'XTickLabel',{'HOL 6\mum', 'HOL 10\mum', 'HOL 18\mum'})
    %     group = [ones(size(APSConAll{4})),ones(size(APSConAll{1}))+1,...
    %         ones(size(APSConAll{5}))+2,ones(size(APSConAll{2}))+3,...
    %         ones(size(APSConAll{6}))+4,ones(size(APSConAll{3}))+5];
    %     data = cat(2,APSConAll{4},APSConAll{1},APSConAll{5},APSConAll{2},APSConAll{6},APSConAll{3});
    %     boxplot(data,group,'colors','g','labels',{'HOL 6 um', 'FM 6 um', 'HOL 10 um',...
    %         'FM 10 um', 'HOL 18 um', 'FM 18 um'});
    %     print('-dpng','-r600', 'Concentraction_boxplot')
end


if any(choosePlots == 5)
    figure(9)
    fitAprox = [0 1 1 10];
    
    %f = @(p,x) p(1) * -exp(-(x-p(2)).^2./2*p(3)^2);
    %f = @(p,x) p(1) + (p(2) / (p(3)*sqrt(pi/2)))* exp(-2*((x*p(4))/p(3))^2);
    %fitValues = nlinfit(middle2{1},mean(histRealArrayAll{1,5},1),f,fitAprox);
    %plot(1:0.1:30, f(fitValues,1:0.1:30))
    hold on
    scatter(middle2{1},mean(histRealArrayAll{1,5},1))
    clear dataCal dataFM data APS
    dataCal(1,:) = middle2{1};
    dataCal(2,:) = mean(histRealArrayAll{1,4},1);
    dataCal(3,:) = mean(histRealArrayAll{1,5},1);
    dataCal(4,:) = mean(histRealArrayAll{1,6},1);
    
    dataCal(5,:) = mean(histRealArrayAll{1,4}./...
        repmat(sum(histRealArrayAll{1,4},2),1,numel(middle2{1})),1);
    dataCal(6,:) = mean(histRealArrayAll{1,5}./...
        repmat(sum(histRealArrayAll{1,5},2),1,numel(middle2{1})),1);
    dataCal(7,:) = mean(histRealArrayAll{1,6}./...
        repmat(sum(histRealArrayAll{1,6},2),1,numel(middle2{1})),1);
    dataCal = dataCal';
    save('dataHOL.mat','dataCal');
    
    dataFM = [FM_Sizes; FM_ConcCorAll]';
     save('dataFM.mat','dataFM');
     
     dataAPS = [APSDiameter'; APSConcAllMean; APSConcAllStd]';
     save('dataAPS.mat','dataAPS');
end

if any(choosePlots == 6)
    plotInt = linspace(2e-3,20e-3,10);
    
    clear plotHist6All plotHist10All plotHist18All fitValues6 fitValues10 fitValues18
    fitAprox = [0 3 3 6];
    f = @(p,x) p(1) + (p(2) / (p(3)*sqrt(pi/2)))* exp(-2.*(((x-p(4))./p(3)).^2));
    fitValues = nlinfit(middle2{1},mean(histRealArrayAll{1,5},1),f,fitAprox);
    
    for cnt = 1:numel(plotInt)-1;
        plotY6All  =  nanmedian(HOLData{4}.pDiam(HOLData{4}.pDiam > 5e-6));
        plotY10All  =  nanmedian(HOLData{5}.pDiam(HOLData{5}.pDiam > 5e-6));
        plotY18All  =  nanmedian(HOLData{6}.pDiam(HOLData{6}.pDiam > 5e-6));
        plotY6(cnt) = nanmedian(HOLData{4}.pDiam(HOLData{4}.pDiam > 5e-6 ...
        & HOLData{4}.zPos >= plotInt(cnt) & HOLData{4}.zPos < plotInt(cnt+1)));
        plotY10(cnt) = nanmedian(HOLData{5}.pDiam(HOLData{5}.pDiam > 5e-6 ...
        & HOLData{5}.zPos >= plotInt(cnt) & HOLData{5}.zPos < plotInt(cnt+1)));
        plotY18(cnt) = nanmedian(HOLData{6}.pDiam(HOLData{6}.pDiam > 5e-6 ...
        & HOLData{6}.zPos >= plotInt(cnt) & HOLData{6}.zPos < plotInt(cnt+1)));
    
         plotHist6All=histc(HOLData{4}.pDiam(HOLData{4}.pDiam > 5e-6)*1000000 ...
        ,partBorder);
           plotHist10All=histc(HOLData{5}.pDiam(HOLData{5}.pDiam > 5e-6)*1000000 ...
        ,partBorder);
           plotHist18All=histc(HOLData{6}.pDiam(HOLData{6}.pDiam > 5e-6)*1000000 ...
        ,partBorder);  
    
    
    
       plotHist6(cnt,:)=histc(HOLData{4}.pDiam(HOLData{4}.pDiam > 5e-6 ...
        & HOLData{4}.zPos >= plotInt(cnt) & HOLData{4}.zPos < plotInt(cnt+1))*1000000 ...
        ,partBorder);
    plotHist6rel(cnt,:) = plotHist6(cnt,:)/nanmax(plotHist6(cnt,:));
    plotHist6sum(cnt) = sum(plotHist6(cnt,:));
           plotHist10(cnt,:)=histc(HOLData{5}.pDiam(HOLData{5}.pDiam > 5e-6 ...
        & HOLData{5}.zPos >= plotInt(cnt) & HOLData{5}.zPos < plotInt(cnt+1))*1000000 ...
        ,partBorder);
    plotHist10sum(cnt) = sum(plotHist10(cnt,:));
    plotHist10rel(cnt,:) = plotHist10(cnt,:)/nanmax(plotHist10(cnt,:));
           plotHist18(cnt,:)=histc(HOLData{6}.pDiam(HOLData{6}.pDiam > 5e-6 ...
        & HOLData{6}.zPos >= plotInt(cnt) & HOLData{6}.zPos < plotInt(cnt+1))*1000000 ...
        ,partBorder);
    plotHist18sum(cnt) = sum(plotHist18(cnt,:));
    plotHist18rel(cnt,:) = plotHist18(cnt,:)/nanmax(plotHist18(cnt,:));
    plotFuncX = 1:0.1:30;
    
    fitAprox = [0 3 3 6];
    fitValues6(cnt,:) = nlinfit(partBorder,plotHist6rel(cnt,:),f,fitAprox);    
    plotFunc6(cnt,:) = f(fitValues6(cnt,:),plotFuncX);
    
    fitAprox = [0 2 2 10];
    fitValues10(cnt,:) = nlinfit(partBorder,plotHist10rel(cnt,:),f,fitAprox);    
    plotFunc10(cnt,:) = f(fitValues10(cnt,:),plotFuncX);
    
    fitAprox = [0 4 4 18];
    fitValues18(cnt,:) = nlinfit(partBorder,plotHist18rel(cnt,:),f,fitAprox);    
    plotFunc18(cnt,:) = f(fitValues18(cnt,:),plotFuncX);
    
    end
figure(6)
i=1:numel(plotInt)-1;
plot3(repmat(plotFuncX,numel(plotInt)-1,1)',...
    repmat(plotInt(1:end-1),numel(plotFuncX),1),plotFunc6')
hold on
X=repmat(partBorder,numel(plotInt)-1,1)';
Y=repmat(plotInt(1:end-1),numel(partBorder),1);
Z=plotHist6rel';
scatter3(X(:),Y(:),Z(:))

figure(7)
plot3(repmat(plotFuncX,numel(plotInt)-1,1)',...
    repmat(plotInt(1:end-1),numel(plotFuncX),1),plotFunc10')
hold on
Z=plotHist10rel';
scatter3(X(:),Y(:),Z(:))

figure(8)
plot3(repmat(plotFuncX,numel(plotInt)-1,1)',...
    repmat(plotInt(1:end-1),numel(plotFuncX),1),plotFunc18')
hold on
Z=plotHist18rel';
scatter3(X(:),Y(:),Z(:))

figure(9)
errorbar(plotInt(1:end-1), fitValues6(:,4), fitValues6(:,3))
hold on
errorbar(plotInt(1:end-1), fitValues10(:,4), fitValues10(:,3),'g') 
errorbar(plotInt(1:end-1), fitValues18(:,4), fitValues18(:,3),'r') 
legend(num2str(mean(fitValues6(:,4)),'%3.1s'),num2str(mean(fitValues10(:,4)),'%3.1s'),num2str(mean(fitValues18(:,4)),'%3.1s'));
xlabel('z Pos');
ylabel('fit diameter')

figure(10)
plot(plotInt(1:end-1), plotHist6sum, plotInt(1:end-1), ...
    plotHist10sum, plotInt(1:end-1), plotHist18sum); 
legend(num2str(mean(fitValues6(:,4)),'%3.1s'),num2str(mean(fitValues10(:,4)),'%3.1s'),num2str(mean(fitValues18(:,4)),'%3.1s'));
xlabel('z Pos');
ylabel('number particle')
end

%for histogramm
HOLhist.Border = (( 0.5 : 99.5)*HOLIMOData{cnt}.cfg.dx*HOLIMOData{cnt}.cfg.dy*4/pi).^(1/2)*1000000;
HOLhist.Sizes = (( 1 : 100)*HOLIMOData{cnt}.cfg.dx*HOLIMOData{cnt}.cfg.dy*4/pi).^(1/2)*1000000;
[histReal{cnt}, edges2{cnt}, middle2{cnt}, limit2{cnt}] = histogram(HOLIMOData{cnt}.pDiam(HOLIMOData{cnt}.partIsReal)*1000000, HOLIMOData{cnt}.sampleVolumeAll, partBorder)

HOLhist.Num6um = histc(HOLData{4}.pDiam*1e6,HOLhist.Border)./HOLhist.Sizes';
HOLhist.Num10um = histc(HOLData{5}.pDiam*1e6,HOLhist.Border)./HOLhist.Sizes';
HOLhist.Num18um = histc(HOLData{6}.pDiam*1e6,HOLhist.Border)./HOLhist.Sizes';
save('dataHOLHist.mat','-struct','HOLhist');

HOLSynHist.sizes = middle2{1}';
HOLSynHist.Num6um = histc(HOLIMOSynAll{4}{1}.pDiam*1e6,HOLhist.Border)./HOLhist.Sizes';
HOLSynHist.Num10um = histc(HOLIMOSynAll{5}{1}.pDiam*1e6,HOLhist.Border)./HOLhist.Sizes';
HOLSynHist.Num18um = histc(HOLIMOSynAll{6}{1}.pDiam*1e6,HOLhist.Border)./HOLhist.Sizes';
save('dataHOLSynHist.mat','-struct','HOLSynHist');