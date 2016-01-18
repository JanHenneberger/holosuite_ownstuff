function dataMeteo = importMeteoSwiss(varargin)
%%import of *.dat file from MeteoSwiss 
%varagin = path of dat-file
%dataMeteo = struct with all parameters
%
%Data from MeteoSchweiz
%Zeitangaben in UTC 0040 (UTC)  =  01:40 Uhr Winterzeit  =  02:40 Uhr Sommerzeit
%Station: Jungfraujoch 3580 m 641930/ 155275
%temperature    =	Lufttemperatur 2 m über Boden; Momentanwert  [°C]
%pressure       =  Luftdruck auf Stationshöhe (QFE); Momentanwert  [hPa]
%windMax        =  Böenspitze (Sekundenböe); Maximum  [m/s]
%sun            =  Sonnenscheindauer; Zehnminutensumme  [min]
%windDir        =  Windrichtung; Zehnminutenmittel  [°]
%windVel        =  Windgeschwindigkeit skalar; Zehnminutenmittel  [m/s]
%pressure0m     =  Luftdruck reduziert auf Meeresniveau mit Standardatmosphäre (QNH); Momentanwert  [hPa]
%radiation      =  Globalstrahlung; Zehnminutenmittel  [W/m²]
%dewPoint       =  Taupunkt 2 m über Boden; Momentanwert  [°C]
   
if nargin == 1
   MeteoSwiss_file = varargin{1};     
else
   %MeteoSwiss_file = 'F:\CLACE2013\MeteoSwiss\MeteoSwissDataJFJ2013.dat';
   MeteoSwiss_file = 'F:\CLACE2013\MeteoSwiss\MeteoSwissCLACE2013JFJData.dat';
end
fileID = fopen(MeteoSwiss_file);

formatSpec = '%s';
N = 111;
C_text = textscan(fileID, formatSpec, N);
C_data0 = textscan(fileID, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f')
fclose(fileID);

dataMeteo.year          = cell2mat(C_data0(2));
dataMeteo.month         = cell2mat(C_data0(3));
dataMeteo.day           = cell2mat(C_data0(4));
dataMeteo.hour          = cell2mat(C_data0(5));
dataMeteo.minute        = cell2mat(C_data0(6));
dataMeteo.dateNum       = datenum(dataMeteo.year, dataMeteo.month,...
    dataMeteo.day, dataMeteo.hour, dataMeteo.minute, zeros(numel(dataMeteo.year,1))); 

dataMeteo.temperature   = cell2mat(C_data0(7));
dataMeteo.pressure      = cell2mat(C_data0(8));
dataMeteo.windMax       = cell2mat(C_data0(9));
dataMeteo.sun           = cell2mat(C_data0(10));
dataMeteo.windDir       = cell2mat(C_data0(11));
dataMeteo.windVel       = cell2mat(C_data0(12));
dataMeteo.pressure0m    = cell2mat(C_data0(13));
dataMeteo.radiation     = cell2mat(C_data0(14));
dataMeteo.dewPoint      = cell2mat(C_data0(15));