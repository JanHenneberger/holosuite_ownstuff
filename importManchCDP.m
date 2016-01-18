function dataOut = importManchCDP(path)

files = dir(fullfile(path,'*.min'));
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
    header = textscan(fid, '%s',3,'delimiter','\n');
    header =  header{1,1}{3};
    header = textscan(header, '%s');
    variables = genvarname(header{1,1});
    %header = header{1}(3:end);
    data = textscan(fid, '%s%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter','\t');
    data = {data{1:20}, data{25:end}};
    fclose(fid)
    clear concArray
    for cnt2 = 1:numel(variables)
        datatmp.(variables{cnt2})=data{cnt2};
    end

        tmp1 = datevec(datatmp.Date,'dd/mm/yy');
        tmp2 = datevec(datatmp.Time, 'HH:MM:SS');
        tmp = [tmp1(:,1:3) tmp2(:,4:6)];
        if ~exist('dataOut','var');
            dataOut.dateVec = tmp;
            dataOut.dateNum = datenum(tmp);
            for cnt3 = 4:20
                dataOut.(variables{cnt3}) = data{cnt3};
            end
            for cnt3 = 1:30
                concArray(:, cnt3)=data{cnt3+20};
            end
            dataOut.concentration = concArray;
            dataOut.binDiam = [3 4 5 6 7 8 9 10 11 12 13 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50];

        else
            dataOut.dateVec = [dataOut.dateVec; tmp];
            dataOut.dateNum = [dataOut.dateNum; datenum(tmp)];
            for cnt3 = 4:20
                dataOut.(variables{cnt3}) = [dataOut.(variables{cnt3}); data{cnt3}];
            end
            for cnt3 = 1:30
                concArray(:, cnt3)=data{cnt3+20};
            end
            dataOut.concentration = [dataOut.concentration; concArray];
        end  
end

