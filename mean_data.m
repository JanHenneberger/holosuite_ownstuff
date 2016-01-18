function [meanVar stdVar] = mean_data (Variable, indIntervall)
meanVar=[];
stdVar=[];
for cnt=1:size(indIntervall,1)
    meanIntervall=mean(Variable(indIntervall(cnt,1):indIntervall(cnt,2)));
    stdIntervall=std(Variable(indIntervall(cnt,1):indIntervall(cnt,2)));
    meanVar=[meanVar; meanIntervall];
    stdVar=[stdVar; stdIntervall];
end
meanVar = meanVar';
stdVar = stdVar';
end