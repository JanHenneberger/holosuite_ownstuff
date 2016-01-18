function oldAsFile = correctParDate(oldAsFile)

parDate = oldAsFile.pStats.dateNumPar;
for cnt = 1:numel(parDate)
    if parDate(cnt) < 1e5
        parDate(cnt) = oldAsFile.dateNumHolo(oldAsFile.pStats.nHoloAll(cnt));
    end
end
oldAsFile.pStats.dateNumPar = parDate;

