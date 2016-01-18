function anData = includeMeteoSwiss2012(anData, pathMeteoSwiss) 
%dataMeteo = importMeteoSwiss(pathMeteoSwiss);
dataMeteo = importIDAWEB(pathMeteoSwiss);

for cnt = 1:numel(anData.timeStart)
    meteoInt = find(dataMeteo.datenum >= anData.timeStart(cnt) & dataMeteo.datenum <= anData.timeEnd(cnt));
    if isempty(meteoInt)
        meteoInt = find(dataMeteo.datenum >= anData.timeStart(cnt),1,'first');
        if isempty(meteoInt)
            meteoInt = nan;
        end
    end
    anData.meteoInt{cnt} = meteoInt;
    if isfinite(meteoInt)
        anData.meteoTemperature(cnt) = nanmean(dataMeteo.tre200s0(meteoInt));
        %anData.meteoRelHumidity(cnt) = nanmean(dataMeteo.ure200s0(meteoInt));
        

        anData.meteoWindDir(cnt) = nanmean(dataMeteo.dkl010z0(meteoInt));
        anData.meteoWindVel(cnt) = nanmean(dataMeteo.fkl010z0(meteoInt));
        %anData.meteoSatPressure(cnt) = nanmean(dataMeteo.pvawats0(meteoInt));
        anData.meteoPressure(cnt) = nanmean(dataMeteo.prestas0(meteoInt));
        anData.meteoWindMax(cnt) = nanmean(dataMeteo.fkl010z1(meteoInt));
        anData.meteoPressure0m(cnt) = nanmean(dataMeteo.pp0qnhs0(meteoInt));
        %anData.meteoRadiation(cnt) = nanmean(dataMeteo.radiation(meteoInt));
        anData.meteoDewPoint(cnt) = nanmean(dataMeteo.tde200s0(meteoInt));
    else
       anData.meteoTemperature(cnt) = nan;
       %anData.meteoRelHumidity(cnt) = nan;
       anData.meteoWindDir(cnt) = nan;
       anData.meteoWindVel(cnt) = nan;
       %anData.meteoSatPressure(cnt) = nan;
       anData.meteoPressure(cnt) = nan;
        anData.meteoWindMax(cnt) = nan;
        anData.meteoPressure0m(cnt) = nan;
        %anData.meteoRadiation(cnt) = nan;
        anData.meteoDewPoint(cnt) = nan;


    end
end