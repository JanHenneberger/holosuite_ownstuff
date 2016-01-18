function dataOut = importNetcdf(path,year)
file = dir(fullfile(path,'*.nc'));
file = {file.name};

if strcmp(year, '2013')
    month = '02';
else
    month = '04';
end

info = ncinfo(fullfile(path,file{1}));

dataOut.datenum = [];
for cnt = 1:3
    data = ncread(fullfile(path,file{1}),info.Variables(cnt).Name);
    dataOut.(info.Variables(cnt).Name) = data;
end

for cntFile = 1:numel(file)
    dataOut.datenum(cntFile) = datenum([year month file{cntFile}(5:10)],'yyyymmddHHMM');
    
    
    for cnt = 4:numel(info.Variables)
        data = ncread(fullfile(path,file{cntFile}),info.Variables(cnt).Name);
        dataOut.(info.Variables(cnt).Name)(:,:,:,cntFile) = data;
    end
    
end


end

