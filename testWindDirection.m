
%Sonic data input
if ~exist('dataSonic','var');
    dataSonic = inputSonicData('F:\JFJ2012\Labview');
end
dataAll.timeStart = dataSonic.Date_Num(1);
dataAll.timeEnd = dataSonic.Date_Num(end);
anParameter.intervall = datenum([0 0 0 0 15 0]);
%find Intervall
if ~isfield(dataAll, 'intervall');
    time = dataAll.timeStart;
    
    %     if anParameter.choosenDay == 0;
    %         dateAll.day = ones(1,numel(dataAll.dateNumHolo));
    %     else
    %         dateAll.day = zeros(1,numel(dataAll.dateNumHolo));
    %         dateAll.day(dataAll.dateVecHolo(:,3) == anParameter.choosenDay) = 1;
    %     end
    dataAll.intervall = zeros(1,numel(dataSonic.Date_Num));
    cnt = 1;
    while time < dataAll.timeEnd
        datevec(time)
        tmp = dataSonic.Date_Num >= time & dataSonic.Date_Num < time + anParameter.intervall;
        if sum(tmp~=0)
            dataAll.intervall(tmp) =  cnt;
            cnt = cnt+1;
            time = time + anParameter.intervall;
        else
            tmp2 = find(dataSonic.Date_Num > time+anParameter.intervall,1,'first');
            time = dataSonic.Date_Num(tmp2);
        end
        
    end
    clear time
    clear tmp
    clear tmp2
    clear anDataAll
end

%Find Sonic Date Indices for Measurements Periods
if ~exist('anDataAll','var');
    for cnt = 1:dataAll.intervall(end)
        anDataAll.sonicIndice{cnt} = find(dataAll.intervall == cnt);
        [anDataAll.measMeanV(cnt), anDataAll.measStdV(cnt)] = ...
            mean_data(dataSonic.V_total,anDataAll.sonicIndice{cnt});
        [anDataAll.measMeanT(cnt), anDataAll.measStdT(cnt)] = ...
            mean_data(dataSonic.T_acoustic,anDataAll.sonicIndice{cnt});
        [anDataAll.measMeanFlow(cnt), anDataAll.measStdFlow(cnt)] = ...
            mean_data(dataSonic.Flowmeter_massflow,anDataAll.sonicIndice{cnt});
        [anDataAll.meanElevSonic(cnt), anDataAll.stdElevSonic(cnt)] = ...
            mean_data(dataSonic.WD_elevation,anDataAll.sonicIndice{cnt});
        [anDataAll.meanElevRotor(cnt), anDataAll.stdElevRotor(cnt)] = ...
            mean_data(dataSonic.WD_rotor_elevation,anDataAll.sonicIndice{cnt});
        meanx = mean_data(dataSonic.Mean_Vx,anDataAll.sonicIndice{cnt});
        meany = mean_data(dataSonic.Mean_Vy,anDataAll.sonicIndice{cnt});
        anDataAll.measMeanAzimutSonic(cnt) = conWindXY2Deg(meanx, meany);
        clear meanx
        clear meany
        % Rotor not on in CLACE 2013
        meanroty = mean_data(-cosd(dataSonic.WD_rotor_azimut_sonic),anDataAll.sonicIndice{cnt});
        meanrotx = mean_data(-sind(dataSonic.WD_rotor_azimut_sonic),anDataAll.sonicIndice{cnt});
        anDataAll.measMeanAzimutRotor(cnt) = conWindXY2Deg(meanrotx, meanroty);
        clear meanroty
        clear meanrotx
        diff_azimut = min([abs(dataSonic.WD_azimut-dataSonic.WD_rotor_azimut_sonic) ...
            abs(abs(dataSonic.WD_azimut-dataSonic.WD_rotor_azimut_sonic)-360)],[],2);
        anDataAll.measMeanDiffAzimutSingle(cnt) = mean_data(diff_azimut,anDataAll.sonicIndice{cnt});
        anDataAll.measMeanDiffAzimutMean(cnt) = ...
            abs(anDataAll.measMeanAzimutSonic(cnt)-anDataAll.measMeanAzimutRotor(cnt));
    end
end
for cnt = 1:numel(anDataAll.measMeanV)
    anDataAll.timeStart(cnt) = dataSonic.Date_Num(anDataAll.sonicIndice{cnt}(1));
    anDataAll.timeEnd(cnt) = dataSonic.Date_Num(anDataAll.sonicIndice{cnt}(end));
end
anDataAll.outtakeAzimuth = anDataAll.measMeanDiffAzimutMean > 15;
anDataAll.outtakeElevation = abs(anDataAll.meanElevRotor-anDataAll.meanElevSonic)> 25;
anDataAll.outtake = anDataAll.outtakeAzimuth | anDataAll.outtakeElevation;


chooseDay = 6

xlimits = [datenum([2012 4 chooseDay 0 0 0]) datenum([2012 4 chooseDay+1 0 0 0])]

subplot(2,2,1)
plot(anDataAll.timeStart, anDataAll.outtake,...
    anDataAll.timeStart, anDataAll.outtakeAzimuth,...
    anDataAll.timeStart, anDataAll.outtakeElevation...
);
%legend({'Total','Azimuth','Elevation'});
xlim(xlimits)
ylim([-0.05 1.05])
ylabel('Out of Wind?')
datetick('x','dd/mm HH','keeplimits');
title('red=Elevaton, green =Azimuth');
subplot(2,2,2)
plot(anDataAll.timeStart, anDataAll.measMeanT)
xlim(xlimits)
ylabel('Temperature [°C]')
datetick('x','dd/mm HH','keeplimits');

subplot(2,2,3)
plot(anDataAll.timeStart, anDataAll.measMeanV)
xlim(xlimits)
ylabel('Wind velocity [m s^{-1}]')
datetick('x','dd/mm HH','keeplimits');

subplot(2,2,4)
plot(anDataAll.timeStart, anDataAll.measMeanAzimutSonic)
xlim(xlimits)
ylabel('Wind direction [°]')
datetick('x','dd/mm HH','keeplimits');