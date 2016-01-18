function ts = timeSerieAnalysisApril(data, intervall, constInletCorr, varargin) 

ts = [];
ts.StartTime = [];
ts.NumHolo = [];
ts.MeanD = [];
ts.TotalCount = [];
ts.Intervall = [];
ts.MeasTime = [];
ts.Histogram = [];
ts.HistogramCorr = [];
ts.HistogramCount = [];
ts.SampleVolume = [];
ts.TWCRaw = [];
ts.TWC = [];
ts.TWCon =[];
ts.TWCCount = [];
ts.LWCRaw = [];
ts.LWC = [];
ts.LWCon =[];
ts.LWCCount = [];
ts.IWCRaw = [];
ts.IWC = [];
ts.IWCon =[];
ts.IWCCount = [];

for cint=1:numel(data.measIndStart)
    cint
    constInletCorr.pressure      = 656;    %[hPa]
    constInletCorr.dPipe         = 0.05;    %[m]
    constInletCorr.windSpeed = data.measMeanV(cint);
    constInletCorr.temperature   = 273.15 + data.measMeanT(cint); %[K];
    constInletCorr.massflow = data.measMeanFlow(cint)/2;  %[l/min]
    
    startInd = data.measIndStart(cint);
    endInd = data.measIndEnd(cint);
    startTime = data.timeHolo(startInd);
    endTime = data.timeHolo(endInd);
    
    if nargin >= 4
        intervallData = varargin{1};
    else
        intervallData = data.partIsReal;
    end
    tsPeriod = timeSerieAnalysis(data, intervall, constInletCorr, intervallData, [startTime endTime]);
    %if ~isempty(tsPeriod.Intervall)
    ts.StartTime = [ts.StartTime tsPeriod.StartTime];
    ts.NumHolo = [ts.NumHolo tsPeriod.NumHolo];
    ts.MeanD = [ts.MeanD tsPeriod.MeanD];
    ts.TotalCount = [ts.TotalCount tsPeriod.TotalCount];
    ts.Intervall = [ts.Intervall tsPeriod.Intervall];
    ts.MeasTime = [ts.MeasTime tsPeriod.MeasTime];
    ts.Histogram = [ts.Histogram; tsPeriod.Histogram];
    ts.HistogramCorr = [ts.HistogramCorr; tsPeriod.HistogramCorr];
    ts.HistogramCount = [ts.HistogramCount; tsPeriod.HistogramCount];
    ts.SampleVolume = [ts.SampleVolume tsPeriod.SampleVolume];
    ts.TWCRaw = [ts.TWCRaw tsPeriod.TWCRaw];
    ts.TWC = [ts.TWC tsPeriod.TWC];
    ts.TWCCount = [ts.TWCCount tsPeriod.TWCCount];
    ts.TWCon = [ts.TWCon tsPeriod.TWCon];
    ts.LWCRaw = [ts.LWCRaw tsPeriod.LWCRaw];
    ts.LWC = [ts.LWC tsPeriod.LWC];
    ts.LWCCount = [ts.LWCCount tsPeriod.LWCCount];
    ts.LWCon = [ts.LWCon tsPeriod.LWCon];
    ts.IWCRaw = [ts.IWCRaw tsPeriod.IWCRaw];
    ts.IWC = [ts.IWC tsPeriod.IWC];
    ts.IWCCount = [ts.IWCCount tsPeriod.IWCCount];  
    ts.IWCon = [ts.IWCon tsPeriod.IWCon];
    
    ts.edges  = tsPeriod.edges;
    ts.middle = tsPeriod.middle;
    %end
end
