function dataOut = importManchRotor(path)

files = dir(fullfile(path,'*.qst'));
files = {files.name};

for cnt = 1:numel(files)
    name = files{cnt};
    day = str2double(name(1:2));
    month = str2double(name(3:4));
    hour = str2double(name(5:6));
    minute = str2double(name(7:8));
    date(cnt) = datenum([2013 month day hour minute 0]);
end
[dateSort, index] = sort(date);


for cnt = index
    fid = fopen(fullfile(path,files{cnt}));
    header = textscan(fid, '%s',9,'delimiter',' ');
    header = header{1}(3:end);
    data = textscan(fid, '%s%s%f%f%f%f','delimiter','\t');
    fclose(fid)
    data{1} = data{1}(1:end-1);
    
    if  ~isempty(data{2}) && numel(data{1})>2
        tmp1 = datevec(data{1},'dd/mm/yy');
        tmp2 = datevec(data{2}, 'HH:MM:SS');
        tmp = [tmp1(:,1:3) tmp2(:,4:6)];
        if ~exist('dataOut','var');
           dataOut.dateVec = tmp;
            dataOut.dateNum = datenum(tmp);
            dataOut.windAzimuth = double(data{3});
            dataOut.windElevation = double(data{4});
            dataOut.wingAzimuth = double(data{5});
            dataOut.wingElevation = double(data{6});
        else
            dataOut.dateVec = [dataOut.dateVec; tmp];
            dataOut.dateNum = [dataOut.dateNum; datenum(tmp)];
            dataOut.windAzimuth = [dataOut.windAzimuth; double(data{3})];
            dataOut.windElevation = [dataOut.windElevation; double(data{4})];
            dataOut.wingAzimuth = [dataOut.wingAzimuth; double(data{5})];
            dataOut.wingElevation = [dataOut.wingElevation; double(data{6})];
        end
    end
end

