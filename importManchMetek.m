function dataOut = importManchMetek(path)

files = dir(fullfile(path,'*.met'));
files = {files.name};

for cnt = 1:numel(files)
    cnt
    name = files{cnt};
    day = str2double(name(1:2));
    month = str2double(name(3:4));
    hour = str2double(name(5:6));
    minute = str2double(name(7:8));
    date(cnt) = datenum([2013 month day hour minute 0]);
end
[dateSort, index] = sort(date);


for cnt = index
    cnt
    fid = fopen(fullfile(path,files{cnt}));
    header = textscan(fid, '%s',11,'delimiter',',');
    data = textscan(fid, '%s%f%f%f%f%f%f%f%f%f%f','delimiter',',');
    fclose(fid)
    if  ~isempty(data{2}) && numel(data{1})>2
    if ~exist('dataOut','var');        
        tmp = datevec(data{1},'dd/mm/yy HH:MM:SS');
        dataOut.dateVec = tmp;
        dataOut.dateNum = datenum(tmp);
        dataOut.vAzimuth = double(data{2})/100;
        dataOut.vElevation = double(data{3})/100;
        dataOut.vWind = double(data{4})/100;
        dataOut.dirAzimuth = double(data{7});
        dataOut.dirAzimuthMean = double(data{8});
        dataOut.dirElevation = double(data{5});
        dataOut.dirElevationMean = double(data{6});
    else        
        tmp = datevec(data{1},'dd/mm/yy HH:MM:SS');
        dataOut.dateVec = [dataOut.dateVec; tmp];
        dataOut.dateNum = [dataOut.dateNum; datenum(tmp)];
        dataOut.vAzimuth = [dataOut.vAzimuth; double(data{2})/100];
        dataOut.vElevation = [dataOut.vElevation; double(data{3})/100];
        dataOut.vWind = [dataOut.vWind; double(data{4})/100];
        dataOut.dirAzimuth = [dataOut.dirAzimuth; double(data{7})];
        dataOut.dirAzimuthMean = [dataOut.dirAzimuthMean; double(data{8})];
        dataOut.dirElevation = [dataOut.dirElevation; double(data{5})];
        dataOut.dirElevationMean = [dataOut.dirElevationMean; double(data{6})];
    end
    end
end

