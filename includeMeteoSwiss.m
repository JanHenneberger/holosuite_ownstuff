function anData = includeMeteoSwiss(anData, pathMeteoSwiss)

dataMeteo = importMeteoSwiss(pathMeteoSwiss);

%dataMeteo = importIDAWEB(pathMeteoSwiss);
for cnt = 1:numel(anData.timeStart)
    if isfield(anData, 'intTimeStart')
        meteoInt = find(dataMeteo.dateNum >= anData.intTimeStart(cnt) & dataMeteo.dateNum <= anData.intTimeEnd(cnt));
        if isempty(meteoInt)
            meteoInt = find(dataMeteo.dateNum >= anData.intTimeStart(cnt),1,'first');
            if isempty(meteoInt)
                meteoInt = nan;
            end
        end
    else
        meteoInt = find(dataMeteo.dateNum >= anData.timeStart(cnt) & dataMeteo.dateNum <= anData.timeEnd(cnt));
        if isempty(meteoInt)
            meteoInt = find(dataMeteo.dateNum >= anData.timeStart(cnt),1,'first');
            if isempty(meteoInt)
                meteoInt = nan;
            end
        end
    end
    
    
    anData.meteoInt{cnt} = meteoInt;
    if isfinite(meteoInt)
        anData.meteoTemperature(cnt) = nanmean(dataMeteo.temperature(meteoInt));
        anData.meteoPressure(cnt) = nanmean(dataMeteo.pressure(meteoInt));
        anData.meteoWindMax(cnt) = nanmean(dataMeteo.windMax(meteoInt));
        anData.meteoSun(cnt) = nanmean(dataMeteo.sun(meteoInt));
        anData.meteoWindDir(cnt) = nanmean(dataMeteo.windDir(meteoInt));
        anData.meteoWindVel(cnt) = nanmean(dataMeteo.windVel(meteoInt));
        anData.meteoPressure0m(cnt) = nanmean(dataMeteo.pressure0m(meteoInt));
        anData.meteoRadiation(cnt) = nanmean(dataMeteo.radiation(meteoInt));
        anData.meteoDewPoint(cnt) = nanmean(dataMeteo.dewPoint(meteoInt));
    else
        anData.meteoTemperature(cnt) = nan;
        anData.meteoPressure(cnt) = nan;
        anData.meteoWindMax(cnt) = nan;
        anData.meteoSun(cnt) = nan;
        anData.meteoWindDir(cnt)= nan;
        anData.meteoWindVel(cnt) = nan;
        anData.meteoPressure0m(cnt) = nan;
        anData.meteoRadiation(cnt) = nan;
        anData.meteoDewPoint(cnt) = nan;
    end
end