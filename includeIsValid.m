function [ anData ] = includeIsValid( anData )


anData.AzimutDiff = abs(difference_azimuth(anData.ManchRotorWingAzimuthMean,...
    anData.ManchRotorWindAzimuthMean));
anData.ElevationDiff = abs(anData.ManchRotorWingElevationMean - ...
    anData.ManchRotorWindElevationMean);
anData.isValidFlow = anData.measMeanFlow >50;

%Group by Intervall is valid
isValid = anData.AzimutDiff < 15 & anData.ElevationDiff < 30 & anData.TWCountRaw >20 &  anData.isValidFlow;
anData.oIsValid = ordinal(isValid,{'Valid','notValid'},[1,0]);

end

