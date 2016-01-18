function ts = timeSerieAnalysis(data, intervall, constInletCorr, varargin) 


    if nargin == 5
        startTime = varargin{2}(1);
        endTime   = varargin{2}(2);
    else
        startTime = data.timeHolo(1);
        endTime = data.timeHolo(end);
    end

ts.StartTime = [];
ts.NumHolo = [];
ts.MeanD = [];
ts.TotalCount = [];
ts.LWC = [];
if (endTime-startTime) >= 0
ts.Intervall = 1 : ceil((endTime-startTime)/intervall);
else
    ts.Intervall = 1;
end
ts.MeasTime = ts.Intervall * intervall;
ts.Histogram = [];
ts.HistogramCorr = [];
ts.HistogramCount = [];

maxSize = max(data.pDiam)*1000000;
divideSize = 34;

%% old bin scheme for histogram

% bigInd = 12;
% smallBorder = (( 0.5 : 2389.5)*data.cfg.dx*data.cfg.dy*4/pi).^(1/2)*1000000;
% divideInd = find(smallBorder > divideSize, 1 ,'first');
% bigBorder = logspace(log10(smallBorder(divideInd)),log10(maxSize),bigInd);
% partBorder = [smallBorder(1:(divideInd-1)) bigBorder];
% partBorder = [partBorder partBorder(end)+1];
% tmp = partBorder;
% tmp(1) = [];
% partBorder(end) = [];
% edgesSize = tmp - partBorder;
% middle = (tmp + partBorder)/2;

maxBin = pi/4*(maxSize./1e6)^2./data.cfg.dx./data.cfg.dy;
cnt = 1;
while floor(exp(cnt*0.25)) <= maxBin
    numberBin(cnt) = floor(exp(cnt*0.25));
    cnt = cnt+1;
end
numberBin = [5 numberBin];
partBorder = 0.5;
for i = 1:numel(numberBin)
    partBorder(i+1) = partBorder(i)+ numberBin(i);
end
partBorder = (partBorder*data.cfg.dx*data.cfg.dy*4/pi).^(1/2)*1000000;
%second change
partBorderOld = partBorder;
smallBorder = partBorder(1: find(partBorder>divideSize,1));
bigBorder = logspace(log10(smallBorder(end)),log10(1000),10);
partBorder = [smallBorder bigBorder(2:end)];

%size correction of partBorder
partBorderOld = partBorder;
partBorder = correction_diameter(partBorder*1e-6)*1e6;

tmp = partBorder;
tmp(1) = [];
partBorder(end) = [];
edgesSize = tmp - partBorder;
middle = (tmp + partBorder)/2;




for cnt = ts.Intervall;
    
    startTimeIntervall = startTime + (cnt-1) * intervall;
    endTimeIntervall = startTimeIntervall + intervall;
    
    
    intervallData    = data.timeHolo >= startTimeIntervall & data.timeHolo < endTimeIntervall;
    if nargin >= 4
    intervallData    = intervallData &  varargin{1};
    end
    
    if numel(unique(data.indHolo(intervallData))) > intervall * 15 * 0.23 * 0.1
        
        ts.StartTime(cnt)    = startTimeIntervall;
        ts.NumHolo(cnt)      = numel(unique(data.indHolo(intervallData)));
        ts.SampleVolume(cnt) = ts.NumHolo(cnt) * data.sampleVolumeHolo;
        
        ts.MeanD(cnt)   = nanmean(data.pDiam(intervallData & data.pDiam > 6.8e-6));
        ts.TotalCount(cnt) = nansum(intervallData & data.pDiam > 6.8e-6);
        
        %TWC
        ts.TWCRaw(cnt)     = nansum(1/6*pi.*(data.pDiam(intervallData & data.pDiam > 6.8e-6)).^3)...
            / ts.SampleVolume(cnt) * 1000000;
        
        temp = data.pDiam(intervallData & data.pDiam > 6.8e-6);  
        hist1 = histc(temp, partBorder/1000000);
        corr1 = Paik_inert(middle/1000000, constInletCorr);
        
        ts.TWCCount(cnt) = sum(hist1./corr1);
        ts.TWCon(cnt) = ts.TWCCount(cnt)/ ts.SampleVolume(cnt) / 1000000;
        ts.TWC(cnt) = nansum((1/6*pi.*(middle/1000000).^3).*hist1./corr1)...
            / ts.SampleVolume(cnt) * 1000000;
        
        %LWC
        intervallDataLWC = intervallData & data.pDiam < divideSize / 1000000  & data.pDiam > 6.8e-6;
        ts.LWCRaw(cnt)     = nansum(1/6*pi.*(data.pDiam(intervallDataLWC)).^3)...
            / ts.SampleVolume(cnt) * 1000000;
        
        temp = data.pDiam(intervallDataLWC);  
        hist1 = histc(temp, partBorder/1000000);
        corr1 = Paik_inert(middle/1000000, constInletCorr);
        
        ts.LWCCount(cnt) = sum(hist1./corr1); 
        ts.LWCon(cnt) = ts.LWCCount(cnt)/ ts.SampleVolume(cnt) / 1000000;
        ts.LWC(cnt) = nansum((1/6*pi.*(middle/1000000).^3).*hist1./corr1)...
            / ts.SampleVolume(cnt) * 1000000;
        
        %IWC
        intervallDataIWC = intervallData & data.pDiam >= divideSize / 1000000  & data.pDiam > 6.8e-6;
        ts.IWCCountRaw(cnt)      = nansum(intervallDataIWC);        
        ts.IWCRaw(cnt)     = nansum(1/6*pi.*(data.pDiam(intervallDataIWC)).^3)...
            / ts.SampleVolume(cnt) * 1000000;
        
        temp = data.pDiam(intervallDataIWC);  
        hist1 = histc(temp, partBorder/1000000);
        corr1 = Paik_inert(middle/1000000, constInletCorr);
        
        ts.IWCCount(cnt) = sum(hist1./corr1); 
        ts.IWCon(cnt) = ts.IWCCount(cnt)/ ts.SampleVolume(cnt) / 1000000;
        ts.IWC(cnt) = nansum((1/6*pi.*(middle/1000000).^3).*hist1./corr1)...
            / ts.SampleVolume(cnt) * 1000000;
        
        %histogram
        [ts.Histogram(cnt,:) ts.edges ts.middle] = histogram(data.pDiam(intervallData)*1000000, ...
            data.sampleVolumeHolo * ts.NumHolo(cnt), partBorder);
        ts.HistogramCorr(cnt,:) = ts.Histogram(cnt,:)./Paik_inert(ts.middle/1000000, constInletCorr);
        ts.HistogramCount(cnt,:) =  histc(data.pDiam(intervallData)*1000000, partBorder(1:end-1));
    else
        ts.StartTime(cnt)    = startTimeIntervall;
        ts.NumHolo(cnt)      = 0;
        ts.SampleVolume(cnt) = nan;
        
        ts.MeanD(cnt)   = nan;
        ts.TotalCount(cnt) = 0;
        
        %TWC
        ts.TWCRaw(cnt)     = nan;
        
        ts.TWCCount(cnt) = nan; 
        ts.TWCon(cnt) = nan;
        ts.TWC(cnt) = nan;
        
        %LWC
        ts.LWCount(cnt)      = nan;
        ts.LWCRaw(cnt)     = nan;
        
        ts.LWCCount(cnt) = nan; 
        ts.LWCon(cnt) = nan;
        ts.LWC(cnt) = nan;
        
        %IWC
        ts.IWCCountRaw(cnt)      = nan;
        ts.IWCRaw(cnt)     = nan;
        
        ts.IWCCount(cnt) = nan; 
        ts.IWCon(cnt) = nan;
        ts.IWC(cnt) = nan;
        
        %histogram
        ts.Histogram(cnt,:) = zeros(1,numel(middle)-1);
        ts.edges = zeros(1,numel(middle)-1);
        ts.middle = zeros(1,numel(middle)-1);
        ts.HistogramCorr(cnt,:) = zeros(1,numel(middle)-1);
        ts.HistogramCount(cnt,:)= zeros(1,numel(middle)-1);
    end
end

