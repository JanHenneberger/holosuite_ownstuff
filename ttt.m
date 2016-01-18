        for cnt2 = 1:numel(temp.pStats.dateNumPar)
            if temp.pStats.dateNumPar(cnt2) < 4e5
                timeStamp = anParameter.ParInfoFiles{cnt}(3:end-4);
                timeStamp = regexprep(timeStamp, '\.' , '-');
                timeStamp = textscan(timeStamp, '%u','delimiter','-');
                timeStamp =double(timeStamp{1}(1:3));
                timeStamp = timeStamp';
                temp.pStats.dateNumPar(cnt2) = datenum([timeStamp 0 0 temp.pStats.dateNumPar(cnt2)]);
            end
        end