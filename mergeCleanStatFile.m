function [ mStatFile] = mergeCleanStatFile( statFile )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%merge the files
for cnt3 = 1:numel(statFile)
        if isfield(statFile{cnt3}, 'ManchCDPMVDMean')
        statFile{cnt3}.ManchCDPConcArrayMean = statFile{cnt3}.ManchCDPConcArrayMean';
        statFile{cnt3}.ManchCDPConcArrayStd = statFile{cnt3}.ManchCDPConcArrayStd';
        end
end

copyFields  = fieldnames(statFile{1});
mStatFile = statFile{1};

for cnt = 2:numel(statFile)
    display(cnt);

    for cnt2 = 1:numel(copyFields)
        if  ~strcmp(copyFields{cnt2}, 'Parameter')  && ~strcmp(copyFields{cnt2}, 'sample')...
                && ~strcmp(copyFields{cnt2}, 'water') &&  ~strcmp(copyFields{cnt2}, 'ice')...
                && ~strcmp(copyFields{cnt2}, 'artefact') && ~strcmp(copyFields{cnt2}, 'meanIntervall')
            mStatFile.(copyFields{cnt2}) = [mStatFile.(copyFields{cnt2}) ...
                statFile{cnt}.(copyFields{ismember(copyFields,copyFields{cnt2})})];
        end
    end   
    
    sampleFields  = fieldnames(mStatFile.sample);
    mStatFile.sample = statFile{1}.sample;
    for cnt2 = 1:numel(sampleFields)
        mStatFile.sample.(sampleFields{cnt2}) = [mStatFile.sample.(sampleFields{cnt2}) ...
            statFile{cnt}.sample.(sampleFields{cnt2})];
    end
    
    mStatFile.Parameter = statFile{cnt}.Parameter;
    
    iceFields = fieldnames(mStatFile.ice);
    mStatFile.ice = statFile{1}.ice;
    for cnt2 = 1:numel(iceFields)
            mStatFile.ice.(iceFields{cnt2}) = [mStatFile.ice.(iceFields{cnt2}) ...
                 statFile{cnt}.ice.(iceFields{cnt2})];
    end
    
    waterFields = fieldnames(mStatFile.water);
    mStatFile.water = statFile{1}.water;
    for cnt2 = 1:numel(waterFields)
            mStatFile.water.(waterFields{cnt2}) = [mStatFile.water.(waterFields{cnt2}) ...
                 statFile{cnt}.water.(waterFields{cnt2})];
    end
end

mStatFile.AzimutDiff = [abs(difference_azimuth(statFile{cnt}.ManchRotorWingAzimuthMean,statFile{cnt}.ManchRotorWindAzimuthMean)) ...
        abs(mStatFile.measMeanDiffAzimutMean)];
    mStatFile.ElevationDiff = [abs(statFile{cnt}.ManchRotorWingElevationMean - statFile{cnt}.ManchRotorWindElevationMean)...
        abs(mStatFile.meanElevSonic - mStatFile.meanElevRotor)];
    mStatFile.isValidFlow = [statFile{cnt}.measMeanFlow >50 mStatFile.measMeanFlow > 25 ];

