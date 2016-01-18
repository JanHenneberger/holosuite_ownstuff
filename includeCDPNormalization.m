function [ anData2013All ] = includeCDPNormalization( anData2013All )

%Log Normalization for CDP Concentraction Spectra

CDPEdges = ((anData2013All.Parameter.ManchCDPBinSizes(2:end)+anData2013All.Parameter.ManchCDPBinSizes(1:end-1))/2)';
anData2013All.CDPEdgesUpper = [CDPEdges; 51];
anData2013All.CDPEdgesLower = [2.5; CDPEdges];
CDPEdgeLog = log(anData2013All.CDPEdgesUpper) - log(anData2013All.CDPEdgesLower);
CDPCorrArray = repmat(CDPEdgeLog, 1, size(anData2013All.ManchCDPConcArrayMean,2));
anData2013All.ManchCDPConcArrayMeanNorm = anData2013All.ManchCDPConcArrayMean./CDPCorrArray;


CDP2EdgesLower = [4.5 5.5 6.5 8.5 9.5 11.5 13.5 15 17 19 23 25 29 33 37]';
CDP2EdgesUpper = [CDP2EdgesLower(2:end); 49];
anData2013All.CDP2Sizes = (CDP2EdgesUpper + CDP2EdgesLower)./2;
CDP2EdgeLog = log(CDP2EdgesUpper) - log(CDP2EdgesLower);
clear CDP2ConcArray;
CDP2ConcArray(1,:) = anData2013All.ManchCDPConcArrayMean(3,:);
CDP2ConcArray(2,:) = anData2013All.ManchCDPConcArrayMean(4,:);
CDP2ConcArray(3,:) = nansum(anData2013All.ManchCDPConcArrayMean(5:6,:),1);
CDP2ConcArray(4,:) = anData2013All.ManchCDPConcArrayMean(7,:);
CDP2ConcArray(5,:) = nansum(anData2013All.ManchCDPConcArrayMean(8:9,:),1);
CDP2ConcArray(6,:) = nansum(anData2013All.ManchCDPConcArrayMean(10:11,:),1);
CDP2ConcArray(7,:) = anData2013All.ManchCDPConcArrayMean(12,:);
CDP2ConcArray(8,:) = anData2013All.ManchCDPConcArrayMean(13,:);
CDP2ConcArray(9,:) = anData2013All.ManchCDPConcArrayMean(14,:);
CDP2ConcArray(10,:) = nansum(anData2013All.ManchCDPConcArrayMean(15:16,:),1);
CDP2ConcArray(11,:) = anData2013All.ManchCDPConcArrayMean(17,:);
CDP2ConcArray(12,:) = nansum(anData2013All.ManchCDPConcArrayMean(18:19,:),1);
CDP2ConcArray(13,:) = nansum(anData2013All.ManchCDPConcArrayMean(20:21,:),1);
CDP2ConcArray(14,:) = nansum(anData2013All.ManchCDPConcArrayMean(22:23,:),1);
CDP2ConcArray(15,:) = nansum(anData2013All.ManchCDPConcArrayMean(24:29,:),1);
CDP2CorrArray = repmat(CDP2EdgeLog,1,size(CDP2ConcArray,2));
anData2013All.ManchCDP2ConcArrayMeanNorm = CDP2ConcArray./CDP2CorrArray;

end

