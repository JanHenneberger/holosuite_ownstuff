function dataOut = import2DSH5(path)
    file = dir(fullfile(path,'PSDs.h5'));
    file = {file.name};
    file = file{1};
    
    info = h5info(file);
    
    dataOut.datenum = [];
    dataOut.PSD = [];
    
    
    for cnt = [10:24 1:9]
        ds = info.Datasets(cnt);
        day = ds.Name(4:end-17);
        data = h5read(file,['/' ds.Name]);

        if strcmp(ds.Name(end),'x')
            var = 'datenum';
            dayNum = str2double(day);
            if cnt == 10 || cnt == 11 || cnt == 12
                dateBase = datenum([2013 1 dayNum 0 0 0]);
            else
                dateBase = datenum([2013 2 dayNum 0 0 0]);
            end            
            if numel(day) == 1
                day = ['0' day];
            end
            data = data/60/60/24+dateBase;
            dataOut.datenum = [dataOut.datenum; data];
        elseif strcmp(ds.Name(end),'y')
            var = 'size';
            dataOut.binBorders = data;
            dataOut.binMiddle = data(1:end-1)+5;
            dataOut.binWidth = 10*ones(numel(dataOut.binMiddle),1);
        else strcmp(ds.Name(end),'z')
            var = 'PSD';
            dataOut.PSD = [dataOut.PSD data];
        end   
    end
end

