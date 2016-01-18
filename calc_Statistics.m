function wholeData = calc_Statistics(anData)
%UNTITLED17 Summary of this function goes here
%   Detailed explanation goes here

    %Whole Campaign
    tmpInd = anData.chosenData;
    
    %'Total conc'
    tmp = anData.TWConcentraction(tmpInd);
    tmp(~isfinite(tmp)) = [];
    wholeData.TWConc = abs([quantile(tmp, [0.05 0.25 0.5 0.75 0.95]) nanmean(tmp)]);
    
    %'Liquid conc'
    tmp = anData.LWConcentraction(tmpInd);
    tmp(~isfinite(tmp)) = [];
    wholeData.LWConc = abs([quantile(tmp, [0.05 0.25 0.5 0.75 0.95]) nanmean(tmp)]);
    
    %'Ice conc'
    tmp = anData.IWConcentraction(tmpInd);
    tmp(~isfinite(tmp)) = [];
    wholeData.IWConc = abs([quantile(tmp, [0.05 0.25 0.5 0.75 0.95]) nanmean(tmp)]);
    
    %'TWC';
    tmp = anData.TWContent(tmpInd);
    tmp(~isfinite(tmp)) = [];
    wholeData.TWC = 1000*abs([quantile(tmp, [0.05 0.25 0.5 0.75 0.95]) nanmean(tmp)]);
    
    
    %'LWC'
    tmp = anData.LWContent(tmpInd);
    tmp(~isfinite(tmp)) = [];
    wholeData.LWC = 1000*abs([quantile(tmp, [0.05 0.25 0.5 0.75 0.95]) nanmean(tmp)]);
    
    %'IWC'
    tmp = anData.IWContent(tmpInd);
    tmp(~isfinite(tmp)) = [];
    wholeData.IWC = 1000*abs([quantile(tmp, [0.05 0.25 0.5 0.75 0.95]) nanmean(tmp)]);
    
    %'total mean d'
    tmp = anData.TWMeanD(tmpInd);
    tmp(~isfinite(tmp)) = [];
    wholeData.TmeanD = 1e6*abs([quantile(tmp, [0.05 0.25 0.5 0.75 0.95]) nanmean(tmp)]);
    
    %'liquid mean d'
    tmp = anData.LWMeanD(tmpInd);
    tmp(~isfinite(tmp)) = [];
    wholeData.LmeanD = 1e6*abs([quantile(tmp, [0.05 0.25 0.5 0.75 0.95]) nanmean(tmp)]);
    
    %'ice mean d'
    tmp = anData.IWMeanD(tmpInd);
    tmp(~isfinite(tmp)) = [];
    wholeData.ImeanD = 1e6*abs([quantile(tmp, [0.05 0.25 0.5 0.75 0.95]) nanmean(tmp)]);
    
    %Temperature
    tmp = anData.meteoTemperature(tmpInd);
    tmp(~isfinite(tmp)) = [];
    wholeData.Temp = abs([quantile(tmp, [0.05 0.25 0.5 0.75 0.95]) nanmean(tmp)]);
    
    %wind speed
    tmp = anData.meteoWindVel(tmpInd);
    tmp(~isfinite(tmp)) = [];
    wholeData.WindVel = abs([quantile(tmp, [0.05 0.25 0.5 0.75 0.95]) nanmean(tmp)]);
    
    wholeDataMatrix = [wholeData.TWConc; wholeData.LWConc; wholeData.IWConc;...
        wholeData.TWC; wholeData.LWC; wholeData.IWC; ...
        wholeData.TmeanD; wholeData.LmeanD; wholeData.ImeanD;
        wholeData.Temp; wholeData.WindVel];
    
    %wholeDataMatrix = num2str(wholeDataMatrix, 2);
    dlmwrite('wholeDataTable', wholeDataMatrix,'precision',2,'delimiter','&');
    
    if anData.savePlots
        fileName = 'wholeDataTable.txt';
        dlmwrite(fullfile(anData.saveDir,fileName), wholeDataMatrix,'precision',2,'delimiter','&');
    end
end

