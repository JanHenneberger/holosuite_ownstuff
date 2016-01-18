function [ data ] = calculateUpdraft( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% delta = 0.01;
% JFJlat = 46.54758;
% JFJlon = 7.98514;
% chosen = data.lat > JFJlat-delta & data.lat < JFJlat+delta & ...
%     data.lon > JFJlon-delta & data.lon < JFJlon+delta;
for cntFile = 1:numel(data.datenum)
    data.indLat = 35:36;
    data.indLon = 54:56;
    data.indLev = 12:14;  
    
    chosenData = data.W(data.indLat,data.indLon,data.indLev,cntFile);
    data.updraft(cntFile) = nanmedian(chosenData(:));
    data.updraftMean(cntFile) = nanmean(chosenData(:));
    data.updraftMax(cntFile) = nanmax(chosenData(:));
    data.updraftMin(cntFile) = nanmin(chosenData(:));


end

