function output = importIDAWEB(MeteoSwiss_file, varargin)

%% imports data from IDAWEB
% MeteoSwiss_file = path to file from IDAWEB in bulletin format
% varargin = optional; reduce the lenght of the parameter name
%
% Example:  DAVWFJ_Sonne = importIDAWEB('order_26549_data.txt',6);
% Reads in the file 'order_26549_data.txt', which must be in the same
% directory. Reduces the paramter names to the first 6 characters

%open the file
fileID = fopen(MeteoSwiss_file);

%ignore the firt two lines
line1 = fgetl(fileID);
line2 = fgetl(fileID);

%read the parameter names in the third line
header = fgetl(fileID);
header = textscan(header, '%s');
header = header{1};

% if a varargin is given --> reduce the header names
if nargin >=2
    for cnt = 3:numel(header)
        header{cnt} = header{cnt}(1:varargin{1});
    end
end

%read the data
data = textscan(fileID, '%s%s%s%s%s%s%s%s%s%s%s%s%s%s');

%create the output as a struct
output = struct;

%Station names
output.(header{1}) = data{1};

%look in which format the date are present and convert it to MATLAB datenum format
switch numel(data{2}{1})        
    case 4
        output.datenum = datenum(data{2}, 'yyyy');
    case 6
        output.datenum = datenum(data{2}, 'yyyymm');
    case 8
        output.datenum = datenum(data{2}, 'yyyymmdd');
    case 10 
        output.datenum = datenum(data{2}, 'yyyymmddHH');
    case 12
        output.datenum = datenum(data{2}, 'yyyymmddHHMM');
    otherwise
        error('unknown date format')
end
%create date vector
output.datevec = datevec(output.datenum);

%convert date from strings to numbers
for cnt = 3:numel(header);   
       output.(header{cnt}) = str2double(data{cnt});  
end

%close the file
fclose(fileID);

