for cnt = 1:3
    sum(~isnan(dataAll{cnt}.pStats.rtDp(dataAll{cnt}.pStats.partIsReal)))
end