function anData = include2DS(anData, path2DS)

data2DS = load(path2DS);
data2DS.dateNum = data2DS.Manch_2DS_datenum;

%dataMeteo = importIDAWEB(pathMeteoSwiss);
for cnt = 1:numel(anData.timeStart)
    if isfield(anData, 'intTimeStart')
        Manch_2DS_Int = find(data2DS.dateNum > anData.intTimeStart(cnt) & data2DS.dateNum <= anData.intTimeEnd(cnt));
        if isempty(Manch_2DS_Int)
            Manch_2DS_Int = find(data2DS.dateNum >= anData.intTimeStart(cnt),1,'first');
            if isempty(Manch_2DS_Int)
                Manch_2DS_Int = nan;
            end
        end
    else
        Manch_2DS_Int = find(data2DS.dateNum > anData.timeStart(cnt) & data2DS.dateNum <= anData.timeEnd(cnt));
        if isempty(Manch_2DS_Int)
            Manch_2DS_Int = find(data2DS.dateNum >= anData.timeStart(cnt),1,'first');
            if isempty(Manch_2DS_Int)
                Manch_2DS_Int = nan;
            end
        end
    end
    
    
    anData.Manch_2DS_Int{cnt} = Manch_2DS_Int;
    if isfinite(Manch_2DS_Int)
        anData.Manch_2DS(cnt) = nanmean(data2DS.Manch_2DS_conc(Manch_2DS_Int));

    else
        anData.Manch_2DS(cnt) = nan;
    end   
    
end