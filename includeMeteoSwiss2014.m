function anData = includeMeteoSwiss(anData, pathMeteoSwiss) 
%dataMeteo = importMeteoSwiss(pathMeteoSwiss);
dataMeteo = importIDAWEB(pathMeteoSwiss);

for cnt = 1:numel(anData.intTimeStart)
    meteoInt = find(dataMeteo.datenum >= anData.intTimeStart(cnt) & dataMeteo.datenum <= anData.intTimeEnd(cnt));
    if isempty(meteoInt)
        meteoInt = find(dataMeteo.datenum >= anData.intTimeStart(cnt),1,'first');
        if isempty(meteoInt)
            meteoInt = nan;
        end
    end
    anData.meteoInt{cnt} = meteoInt;
    if isfinite(meteoInt)
        anData.meteoTemperature(cnt) = nanmean(dataMeteo.tre200s0(meteoInt));
        anData.meteoRelHumidity(cnt) = nanmean(dataMeteo.ure200s0(meteoInt));
        

        anData.meteoWindDir(cnt) = nanmean(dataMeteo.dkl010z0(meteoInt));
        anData.meteoWindVel(cnt) = nanmean(dataMeteo.fve010z0(meteoInt));
        anData.meteoSatPressure(cnt) = nanmean(dataMeteo.pvawats0(meteoInt));

        %         anData.meteoPressure(cnt) = nanmean(dataMeteo.pressure(meteoInt));
%         anData.meteoWindMax(cnt) = nanmean(dataMeteo.windMax(meteoInt));
%         anData.meteoSun(cnt) = nanmean(dataMeteo.sun(meteoInt));
%         anData.meteoPressure0m(cnt) = nanmean(dataMeteo.pressure0m(meteoInt));
%         anData.meteoRadiation(cnt) = nanmean(dataMeteo.radiation(meteoInt));
%         anData.meteoDewPoint(cnt) = nanmean(dataMeteo.dewPoint(meteoInt));
    else
       anData.meteoTemperature(cnt) = nan;
       anData.meteoRelHumidity(cnt) = nan;
       anData.meteoWindDir(cnt) = nan;
       anData.meteoWindVel(cnt) = nan;
       anData.meteoSatPressure(cnt) = nan;


    end
end