clc
folderPartStats = 'G:\2012-04-07-Auswertung\Auswertung\ParticleStats_All_';
cd(folderPartStats);
psfilenames = dir('*_ps.mat');
psfilenames = {psfilenames.name};

%load the file and merge them together
for cnt = 1:numel(psfilenames)
    cnt
    tmp = load(psfilenames{cnt});
    if cnt == 1
        data = tmp.dataParticle;
    else
        tmp = tmp.dataParticle;
        data.nPart           = [data.nPart tmp.nPart];
        data.partIsBorder    = [data.partIsBorder tmp.partIsBorder];
        data.partIsSatelite  = [data.partIsSatelite tmp.partIsSatelite];
        data.maxPh           = [data.maxPh tmp.maxPh];
        data.minPh           = [data.minPh tmp.minPh];
        data.pDiam           = [data.pDiam tmp.pDiam];
        data.pDiamFilled     = [data.pDiamFilled  tmp.pDiamFilled];
        data.pEssent           = [data.pEssent tmp.pEssent];
        data.xPos           = [data.xPos tmp.xPos];
        data.yPos           = [data.yPos tmp.yPos];
        data.zPos           = [data.zPos tmp.zPos];
        data.xyExtend          = [data.xyExtend tmp.xyExtend];
        data.zExtend          = [data.zExtend tmp.zExtend];
        data.timeHolo         = [data.timeHolo tmp.timeHolo];
        data.indHolo         = [data.indHolo tmp.indHolo+data.indHolo(end)];
    end
end

%size Correction
data.pDiamOldSizes = data.pDiam;
data.pDiam = correction_diameter(data.pDiam);

data.sampleSize.x      = (data.Nx - data.parameter.borderPixel)*data.cfg.dx;
data.sampleSize.y      = (data.Ny - data.parameter.borderPixel)*data.cfg.dy;
data.sampleSize.z      = data.parameter.lmaxZ - data.parameter.lminZ;
data.sampleVolumeHolo  = data.sampleSize.x * data.sampleSize.y * data.sampleSize.z;
data.sampleNumber      = data.indHolo(end);
data.sampleVolumeAll   = data.sampleVolumeHolo * data.sampleNumber;



%shift Hologramm time from 22-00-19 to 22-29-19 --> 1740s
%data.timeHolo = data.timeHolo+1740;

data.timeVec = conTime2Vec(data.timeHolo);
%Correct for Ice on Window
load('DataCorrected.mat', 'data')
data.blackListInd = unique(data.indHolo(data.pDiam >0.00025));
data.partIsOnBlackList = false(1, numel(data.indHolo));
for i = 1:numel(data.blackListInd)
    data.partIsOnBlackList = data.partIsOnBlackList | data.indHolo == data.blackListInd(i);
end
nanParticleInd = find(isnan(data.partIsSatelite));
data.partIsSatelite(nanParticleInd) = 1;
data.partIsBorder(nanParticleInd) = 1;

data.partIsRealAll  = ~data.partIsSatelite & ~data.partIsBorder;
data.partIsReal     = ~data.partIsSatelite & ~data.partIsBorder & ~data.partIsOnBlackList;
data.sampleNumberReal = data.sampleNumber - numel(data.blackListInd);
data.sampleVolumeReal   = data.sampleVolumeHolo * data.sampleNumberReal;
data.realInd = find(data.partIsReal);

data.partIsRealCor = data.partIsReal & ~data.partIsIceWindow;
data.partIsRealAllCor = data.partIsRealAll & ~data.partIsIceWindow;
data.sampleNumberCor = data.sampleNumber - numel(unique([data.blackListInd data.isIceWindowInd]));
data.sampleNumberAllCor = data.sampleNumber - numel(unique(data.isIceWindowInd));
data.sampleVolumeCor   = data.sampleVolumeHolo * data.sampleNumberCor;
data.sampleVolumeAllCor = data.sampleVolumeHolo * data.sampleNumberAllCor;

indParticle = numel(data.timeHolo);
year = 2012;
month = 04;

% temp1 = ones(1, indParticle)*year;
% temp2 = ones(1, indParticle)*month;
% temp3 = [temp1; temp2];
% data.timeVec=[temp3; data.timeVec];

dayStart = min(data.timeVec(3,:));
dayEnd = max(data.timeVec(3,:));

%find 30s measurement intervalls with 100s breaks in between
% 
% temp1=data.timeHolo(2:end)-data.timeHolo(1:end-1);
% temp2=find(temp1>60);
% data.measIndStart = [1 temp2+1];
% data.measIndEnd   = [temp2 indParticle];
% 
% data.measTimeVecStart = data.timeVec(:,data.measIndStart);
% data.measTimeVecEnd = data.timeVec(:,data.measIndEnd);


Sonic_file=[];
for day = dayStart-1:dayEnd
Sonic_file_char=strcat('E:\Labview Data\Data\',num2str(year),'-',num2str(month,'%02u'),'-',num2str(day,'%02u'),'-','LabviewData.txt');
Sonic_file=[Sonic_file;Sonic_file_char];
end

%Import Sonic Data Files
Sonic_file=unique(Sonic_file,'rows');
Sonic_file_size=size(Sonic_file,1);
for Sonic_Numb=1:Sonic_file_size
    Sonic_Data(Sonic_Numb) = importdata(Sonic_file(Sonic_Numb,:));
end

% Create new variables in the base workspace from Sonic Data fields.
for i = 1:size(Sonic_Data(1).colheaders, 2)
    assignin('base', genvarname(Sonic_Data(1).colheaders{i}), Sonic_Data(1).data(:,i));
    if (Sonic_file_size >1)
        for Sonic_Numb=2:Sonic_file_size
            tmp=Sonic_Data(1).colheaders{i};        
            tmp=strrep(tmp, ' s' , 'S');
            tmp=strrep(tmp, 'THIES-Status','THIES0x2DStatus');
            tmp2=[num2str(tmp),'=[',num2str(tmp),';Sonic_Data(Sonic_Numb).data(:,i)];'];
            eval(tmp2);        
        end
    end
end

Date_Year=Year;
Date_Month=Month;
Date_Day_of_Year=Day_of_Year;
Date_Hour=Hour;
Date_Minute=Minute;
Date_Second=Second;
Date_FractionalSecond=FractionalSecond;
Date_Julian=Julian;

clear('Year','Month','Day_of_Year','Hour','Minute','Second','FractionalSecond','Julian');

%Create Sonic Date Vector and Serial Date Numbers
Sonic_Date=[Date_Year zeros(size(Date_Year)) Date_Day_of_Year Date_Hour Date_Minute Date_Second+Date_FractionalSecond/1000];
Sonic_Date_Num=datenum(Sonic_Date);
Sonic_Date_Vec=datevec(Sonic_Date_Num);

%Find Sonic Date Indices for Measurements Periods
xlimit_all=[];
for intervall = 1:size(data.measTimeVecStart,2)
    xlimit_indice = [find(Sonic_Date_Num>datenum(data.measTimeVecStart(1:6,intervall)'),1,'first') ...
        find(Sonic_Date_Num>datenum(data.measTimeVecEnd(1:6,intervall)'),1,'first')];
    xlimit_all = [xlimit_all; xlimit_indice];
end
[data.measMeanV data.measStdV] = mean_data(V_total,xlimit_all);
[data.measMeanT data.measStdT] = mean_data(T_acoustic,xlimit_all);
[data.measMeanFlow data.measStdFlow] = mean_data(Flowmeter_massflow,xlimit_all);

meanElevSonic = mean_data(WD_elevation,xlimit_all);
meanElevRotor = mean_data(WD_rotor_elevation,xlimit_all);

meanx = mean_data(Mean_Vx,xlimit_all);
meany = mean_data(Mean_Vy,xlimit_all);
meanDegreeSonic = conWindXY2Deg(meanx, meany);
data.measMeanAzimutSonic = meanDegreeSonic;

roty = -cosd(WD_rotor_azimut_sonic);
rotx = -sind(WD_rotor_azimut_sonic);
meanroty = mean_data(roty,xlimit_all);
meanrotx = mean_data(rotx,xlimit_all);
meanDegreeRotor = conWindXY2Deg(meanrotx, meanroty);
data.measMeanAzimutRotor = meanDegreeRotor;

diff_azimut = min([abs(WD_azimut-WD_rotor_azimut_sonic) abs(abs(WD_azimut-WD_rotor_azimut_sonic)-360)],[],2);
data.measMeanDiffAzimutSingle = mean_data(diff_azimut,xlimit_all);

data.measMeanDiffAzimutMean = abs(meanDegreeSonic-meanDegreeRotor);

