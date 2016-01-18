function anData = include2DSH5(anData, path2DSH5)

data2DS = import2DSH5(path2DSH5);
 

anData.Manch2DS_binBorder = data2DS.binBorders;
anData.Manch2DS_binMiddle = data2DS.binMiddle;
anData.Manch2DS_binWidth = data2DS.binWidth;

%dataMeteo = importIDAWEB(pathMeteoSwiss);
for cnt = 1:numel(anData.timeStart)
    if isfield(anData, 'intTimeStart')
        Manch_2DS_Int = find(data2DS.datenum > anData.intTimeStart(cnt) & data2DS.datenum <= anData.intTimeEnd(cnt));
        if isempty(Manch_2DS_Int)
            Manch_2DS_Int = find(data2DS.datenum >= anData.intTimeStart(cnt),1,'first');
            if isempty(Manch_2DS_Int)
                Manch_2DS_Int = nan;
            end
        end
    else
        Manch_2DS_Int = find(data2DS.datenum > anData.timeStart(cnt) & data2DS.datenum <= anData.timeEnd(cnt));
        if isempty(Manch_2DS_Int)
            Manch_2DS_Int = find(data2DS.datenum >= anData.timeStart(cnt),1,'first');
            if isempty(Manch_2DS_Int)
                Manch_2DS_Int = nan;
            end
        end
    end
    
    
    anData.Manch_2DS_Int{cnt} = Manch_2DS_Int;
    if isfinite(Manch_2DS_Int)
        try
            anData.Manch2DS_PSD(:,cnt) = nanmean(data2DS.PSD(:,Manch_2DS_Int),2);
        catch
            anData.Manch2DS_PSD(:,cnt) = nan(128,1);
        end

    else
        anData.Manch2DS_PSD(:,cnt) = nan(128,1);
    end   
    
end