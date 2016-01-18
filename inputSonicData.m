function dataSonic = inputSonicData(dataSonicFolder, varargin)

if nargin == 2
        
else
   Sonic_file = dir(fullfile(dataSonicFolder,'*.txt'));
   Sonic_file = {Sonic_file.name};
end
Sonic_FileCnt = numel(Sonic_file);
for Sonic_Numb=1:Sonic_FileCnt
    Sonic_Data(Sonic_Numb) = importdata(fullfile(dataSonicFolder,Sonic_file{Sonic_Numb}));
end

for i = 1:size(Sonic_Data(1).colheaders, 2)
    eval([genvarname(Sonic_Data(1).colheaders{i}) '= Sonic_Data(1).data(:,i)']);
    if (Sonic_FileCnt >1)
        for Sonic_Numb=2:Sonic_FileCnt
            tmp=Sonic_Data(1).colheaders{i};        
            tmp=strrep(tmp, ' s' , 'S');
            tmp=strrep(tmp, 'THIES-Status','THIES0x2DStatus');
            tmp2=[num2str(tmp),'=[',num2str(tmp),';Sonic_Data(Sonic_Numb).data(:,i)];'];
            eval(tmp2);        
        end
    end
end

Date_Year=Year;
Date_Month=Month;
Date_Day_of_Year=Day_of_Year;
Date_Hour=Hour;
Date_Minute=Minute;
Date_Second=Second;
Date_FractionalSecond=FractionalSecond;
Date_Julian=Julian;

clear('Year','Month','Day_of_Year','Hour','Minute','Second','FractionalSecond','Julian');
clear('Sonic_Data','Sonic_FileCnt','Sonic_Numb','Sonic_file','dataSonicFolder','i','tmp','tmp2','varargin');

%Create Sonic Date Vector and Serial Date Numbers
Date=[Date_Year zeros(size(Date_Year)) Date_Day_of_Year Date_Hour Date_Minute Date_Second+Date_FractionalSecond/1000];
Date_Num=datenum(Date);
Date_Vec=datevec(Date_Num);

varList = who;

 %initialiste a structure
 dataSonic = struct;

 %use dynamic fieldnames
 for index = 1:numel(varList)
     dataSonic.(varList{index}) = eval(varList{index});
 end