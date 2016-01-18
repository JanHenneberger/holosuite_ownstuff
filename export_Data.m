function export_Data(anData,fileName,chosenData) 

outFile.time = anData.timeStart(chosenData);
outFile.BinBorder = anData.Parameter.histBinBorder(3:end-3);
outFile.BinMiddle = anData.Parameter.histBinMiddle(3:end-3);

outFile.LWPSD =  abs(anData.water.histRealCor(3:end-3,chosenData));
outFile.IWPSD =  abs(anData.ice.histRealCor(3:end-3,chosenData));
outFile.TWPSD =  outFile.LWPSD + outFile.IWPSD;

edges = outFile.BinBorder;
tmp = edges;
tmp(1) = [];
edges(end) = [];
edgesSize = log(tmp) - log(edges);

outFile.LWPSDnoNorm = outFile.LWPSD.*repmat(edgesSize',1,size(outFile.LWPSD,2));
outFile.IWPSDnoNorm = outFile.IWPSD.*repmat(edgesSize',1,size(outFile.IWPSD,2));
outFile.TWPSDnoNorm = outFile.TWPSD.*repmat(edgesSize',1,size(outFile.TWPSD,2));

outFile.LWMeanD = abs(anData.LWMeanD(chosenData));
outFile.LWConcentration = abs(anData.LWConcentraction(chosenData));
outFile.LWContent =  abs(anData.LWContent(chosenData));

outFile.IWMeanD = abs(anData.IWMeanD(chosenData));
outFile.IWMeanMaxD = abs(anData.IWMeanMaxD(chosenData));
outFile.IWConcentration = abs(anData.IWConcentraction(chosenData));
outFile.IWContent =  abs(anData.IWContent(chosenData));

outFile.TWMeanD = abs(anData.TWMeanD(chosenData));
outFile.TWConcentration = abs(anData.TWConcentraction(chosenData));
outFile.TWContent =  abs(anData.TWContent(chosenData));

outFile.IWContentTWContentRatio =  abs(outFile.IWContent./outFile.TWContent);

outFile.meteoTemperature = anData.meteoTemperature(chosenData);
outFile.meteoWindDir = anData.meteoWindDir(chosenData);
outFile.meteoWindVel = anData.meteoWindVel(chosenData);
outFile.meteoPressure = anData.meteoPressure(chosenData);

save(fullfile(anData.saveDir,fileName),'outFile');

timeVec = anData.timeVecStart(:,chosenData);
VarNames = {'DateNum' 'Year' 'Month' 'Day' 'Hour' 'Minute' 'Second'...
    'LWMeanD' 'LWConcentration' 'LWContent' ...
    'IWMeanD' 'IWMeanMaxD' 'IWConcentration' 'IWContent' ...
    'TWMeanD' 'TWConcentration' 'TWContent' ...
    'IWContentTWContentRatio' ...
    'meteoTemperature' 'meteoWindDir', 'meteoWindVel', 'meteoPressure'};
T = table(outFile.time', timeVec(1,:)', timeVec(2,:)', timeVec(3,:)',...
    timeVec(4,:)', timeVec(5,:)', timeVec(6,:)',...
    outFile.LWMeanD', outFile.LWConcentration',outFile.LWContent',...
    outFile.IWMeanD', outFile.IWMeanMaxD', outFile.IWConcentration', outFile.IWContent',...
    outFile.TWMeanD', outFile.TWConcentration', outFile.TWContent',...
    outFile.IWContentTWContentRatio',...
    outFile.meteoTemperature', outFile.meteoWindDir', outFile.meteoWindVel',...
    outFile.meteoPressure', 'VariableNames',VarNames);
writetable(T,fullfile(anData.saveDir, fileName));
    
