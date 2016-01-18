function [ caseStats ] = makeCaseStats( anData, cases, filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tmpInt = anData.chosenData & isfinite(anData.TWContent);
oTmp = droplevels(cases(tmpInt));

[caseStats.timeStart, caseStats.timeEnd] = grpstats(anData.timeStart(tmpInt),oTmp,{'min';'max'});

caseStats.dateStart = datestr(caseStats.timeStart,'dd.mm.yy');
caseStats.dateEnd = datestr(caseStats.timeEnd,'dd.mm.yy');
caseStats.timeStart = datestr(caseStats.timeStart,'HH:MM');
caseStats.timeEnd = datestr(caseStats.timeEnd,'HH:MM');

caseStats.cntIntervall = grpstats(real(anData.TWContent(tmpInt)),oTmp,'numel');

caseStats.name = grpstats(real(anData.TWContent(tmpInt)),oTmp,'gname');
caseStats.TWCMean = grpstats(real(anData.TWContent(tmpInt)),oTmp,'mean');
caseStats.TWCStd = grpstats(real(anData.TWContent(tmpInt)),oTmp,'std');
caseStats.TWCStdMean = grpstats(real(anData.TWContent(tmpInt)),oTmp,'sem')

caseStats.LWCMean = grpstats(real(anData.LWContent(tmpInt)),oTmp,'mean');
caseStats.LWCStd = grpstats(real(anData.LWContent(tmpInt)),oTmp,'std');
caseStats.LWCStdMean = grpstats(real(anData.LWContent(tmpInt)),oTmp,'sem');

caseStats.IWCMean = grpstats(real(anData.IWContent(tmpInt)),oTmp,'mean');
caseStats.IWCStd = grpstats(real(anData.IWContent(tmpInt)),oTmp,'std');
caseStats.IWCStdMean = grpstats(real(anData.IWContent(tmpInt)),oTmp,'sem');


caseStats.IWCTWCMean = grpstats(real(anData.IWContent(tmpInt)./anData.TWContent(tmpInt)),oTmp,'mean');
caseStats.IWCTWCStd = grpstats(real(anData.IWContent(tmpInt)./anData.TWContent(tmpInt)),oTmp,'std');
caseStats.IWCTWCStdMean = grpstats(real(anData.IWContent(tmpInt)./anData.TWContent(tmpInt)),oTmp,'sem');
% caseStats.IWCQuantile05 = ...
%     grpstats(real(anData.IWContent(tmpInt)),oTmp,{@(x) quantile(x,0.05)});
% caseStats.IWCQuantile25 = ...
%     grpstats(real(anData.IWContent(tmpInt)),oTmp,{@(x) quantile(x,0.25)});
% caseStats.IWCQuantile50 = ...
%     grpstats(real(anData.IWContent(tmpInt)),oTmp,{@(x) quantile(x,0.50)});
% caseStats.IWCQuantile75 = ...
%     grpstats(real(anData.IWContent(tmpInt)),oTmp,{@(x) quantile(x,0.75)});
% caseStats.IWCQuantile95 = ...
%     grpstats(real(anData.IWContent(tmpInt)),oTmp,{@(x) quantile(x,0.95)});


caseStats.TWConcMean = grpstats(real(anData.TWConcentraction(tmpInt)),oTmp,'mean');
caseStats.TWConcStd = grpstats(real(anData.TWConcentraction(tmpInt)),oTmp,'std');
caseStats.TWConcStdMean = grpstats(real(anData.TWConcentraction(tmpInt)),oTmp,'sem');

caseStats.LWConcMean = grpstats(real(anData.LWConcentraction(tmpInt)),oTmp,'mean');
caseStats.LWConcStd = grpstats(real(anData.LWConcentraction(tmpInt)),oTmp,'std');
caseStats.LWConcStdMean = grpstats(real(anData.LWConcentraction(tmpInt)),oTmp,'sem');

caseStats.IWConcMean = grpstats(real(anData.IWConcentraction(tmpInt)),oTmp,'mean');
caseStats.IWConcStd = grpstats(real(anData.IWConcentraction(tmpInt)),oTmp,'std');
caseStats.IWConcStdMean = grpstats(real(anData.IWConcentraction(tmpInt)),oTmp,'sem');

caseStats.IWConcMean = grpstats(real(anData.IWConcentraction(tmpInt)),oTmp,'mean');
caseStats.IWConcStd = grpstats(real(anData.IWConcentraction(tmpInt)),oTmp,'std');
caseStats.IWConcStdMean = grpstats(real(anData.IWConcentraction(tmpInt)),oTmp,'sem');

anData.IWConcRaw = real(anData.IWCountRaw)./anData.sample.VolumeReal*1e-6;
caseStats.IWConcRawMean = grpstats(real(anData.IWConcRaw(tmpInt)),oTmp,'mean');
caseStats.IWConcRawStd = grpstats(real(anData.IWConcRaw(tmpInt)),oTmp,'std');
caseStats.IWConcRawStdMean = grpstats(real(anData.IWConcRaw(tmpInt)),oTmp,'sem');

[caseStats.TWMeanDMean, caseStats.TWMeanDStd, caseStats.TWMeanDStdMean] = ...
    grpstats(real(anData.TWMeanD(tmpInt)),oTmp,{'mean','std','sem'});
[caseStats.LWMeanDMean, caseStats.LWMeanDStd, caseStats.LWMeanDStdMean] = ...
    grpstats(real(anData.LWMeanD(tmpInt)),oTmp,{'mean','std','sem'});
[caseStats.IWMeanDMean, caseStats.IWMeanDStd, caseStats.IWMeanDStdMean] = ...
    grpstats(real(anData.IWMeanD(tmpInt)),oTmp,{'mean','std','sem'});
[caseStats.IWMeanMaxDMean, caseStats.IWMeanMaxDStd, caseStats.IWMeanMaxDStdMean] = ...
    grpstats(real(anData.IWMeanMaxD(tmpInt)),oTmp,{'mean','std','sem'});

[caseStats.TempMean, caseStats.TempStd, caseStats.TempStdMean] = ...
    grpstats(anData.meteoTemperature(tmpInt),oTmp,{'mean','std','sem'});
[caseStats.WindVelMean, caseStats.WindVelStd, caseStats.WindVelStdMean] = ...
    grpstats(anData.meteoWindVel(tmpInt),oTmp,{'mean','std','sem'});
[caseStats.PressureMean, caseStats.PressureStd] = ...
    grpstats(anData.meteoPressure(tmpInt),oTmp,{'mean','std','sem'});

caseTable = table(caseStats.dateStart, caseStats.timeStart, caseStats.timeEnd, ...
    num2str(caseStats.cntIntervall), ...
    num2str(caseStats.TempMean,'%1.2f'), num2str(caseStats.TempStdMean,'%1.2f'),...
    num2str(caseStats.WindVelMean,'%1.1f'), num2str(caseStats.WindVelStdMean,'%1.1f'),...
    num2str(caseStats.TWCMean*1000,'%1.1f'), num2str(caseStats.TWCStdMean*1000,'%1.1f'),...
    num2str(caseStats.LWCMean*1000,'%1.1f'), num2str(caseStats.LWCStdMean*1000,'%1.1f'),...
    num2str(caseStats.IWCMean*1000,'%1.1f'), num2str(caseStats.IWCStdMean*1000,'%1.1f'),...
    num2str(caseStats.TWConcMean,'%1.0f'), num2str(caseStats.TWConcStdMean,'%1.0f'),...
    num2str(caseStats.LWConcMean,'%1.0f'), num2str(caseStats.LWConcStdMean,'%1.0f'),...
    num2str(caseStats.IWConcMean,'%1.3f'), num2str(caseStats.IWConcStdMean,'%1.3f'),...
    'VariableNames',{'Date'; 'TimeStart'; 'TimeEnd'; 'Intervalls';...
    'TempMean'; 'TempStd'; 'WindVelMean'; 'WindVelStd'; ...
    'TWCMean'; 'TWCStd'; 'LWCMean'; 'LWCStd'; 'IWCMean'; 'IWCStd';...
    'TWConcMean'; 'TWConcStd';'LWConcMean'; 'LWConcStd';'IWConcMean'; 'IWConcStd'});

   if anData.savePlots
    writetable(caseTable,fullfile(anData.saveDir,filename),'WriteVariableNAmes',1,'Delimiter',',');   
   end

end

