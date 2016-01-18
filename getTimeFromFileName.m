function [timeNum, timeVec] = getTimeFromFileName(filename)

timeStamp = filename(1:end-4);
timeStamp = regexprep(timeStamp, '\.' , '-');
timeStamp = textscan(timeStamp, '%u','delimiter','-');
timeStamp =double(timeStamp{1});
if numel(timeStamp) == 7
    tmp =  num2str(timeStamp(7),'%03u');
    tmp = tmp(1:3);
    timeStamp(7) = double(str2num(tmp));
  %  timeStamp = timeStamp(3)*3600*24+timeStamp(4)*3600+timeStamp(5)*60+timeStamp(6)+timeStamp(7)/1000;
    timeStamp = timeStamp';
    timeNum = datenum(timeStamp(1:6))+timeStamp(7)/24/60/60/1000;
    timeVec = datevec(timeNum);
    %timeVec(7) = timeStamp(7);
   
else
    %old
%     timeStamp = timeStamp(1)*3600+timeStamp(2)*60+timeStamp(3)+timeStamp(4)/1000;
%     timeNum = datenum(timeStamp);
%     timeVec = datevec(timeStamp);
    %new 2014/10/24
    timeNum = datenum([0 0 0 timeStamp(1:3)']);
    timeNum = timeNum+timeStamp(4)/24/60/60/1000;
    timeVec = datevec(timeNum);
    
end