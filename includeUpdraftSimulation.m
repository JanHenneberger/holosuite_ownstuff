function anData = includeUpdraftSimulation(anData, pathupdraft, year)

dataUpdraft = importNetcdf(pathupdraft, year);
dataUpdraft = calculateUpdraft(dataUpdraft);


for cnt = 1:numel(anData.timeStart)
    indUpdraft = find(dataUpdraft.datenum >= anData.timeStart(cnt) & dataUpdraft.datenum <= anData.timeEnd(cnt));
    if isempty(indUpdraft)
        nextInd = find(dataUpdraft.datenum >= anData.timeStart(cnt),1,'first');
        isClose = dataUpdraft.datenum(nextInd) - anData.timeStart(cnt) <= datenum([0 0 0 0 30 0]);
        %indUpdraft = find(dataUpdraft.datenum >= anData.timeStart(cnt),1,'first');
        if isClose
            indUpdraft = nextInd;
        else
            indUpdraft = nan;
        end
    end
    anData.indUpdraft{cnt} = indUpdraft;
    if isfinite(indUpdraft)
        anData.updraft(cnt) = nanmean(dataUpdraft.updraft(indUpdraft));
        anData.updraftMean(cnt) = nanmean(dataUpdraft.updraftMean(indUpdraft));
        anData.updraftMin(cnt) = nanmean(dataUpdraft.updraftMin(indUpdraft));
        anData.updraftMax(cnt) = nanmean(dataUpdraft.updraftMax(indUpdraft));
    else
        anData.updraft(cnt) = nan;
        anData.updraftMean(cnt) = nan;
        anData.updraftMin(cnt) = nan;
        anData.updraftMax(cnt) = nan;
    end
end