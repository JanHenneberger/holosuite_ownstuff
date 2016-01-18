function outFile = statParticlesOwn(data, cfg)
mainTic = tic;
if ischar(data)
        fileName = data;
        data = load(data);
    if  ~isfield(data, 'zs')
        error('field zs is missing in file %s.\n',fileName);
    end
end
if ~isstruct(data), error('data structure requried'); end
if ~isempty(data.voxelList) && strcmp(class(data.voxelList{1,1}), class(data.voxelList{2,1}))
    data.voxelList    = data.voxelList';
end

% Load the config file
if ischar(cfg)
    cfg = config(cfg);
end

% setup the outFile
if ~nargout
    outFilename = cfg.retag(data.hologram,'_ps.mat');
%     if exist(outFilename,'file');
%         outData = load(outFilename);
%         if ~isfield(outData, 'partIsValid')
%             fprintf('File old version, delete: %s\n',outFilename);
%             delete(outFilename);
%         else
%         outFile = [];
%         fprintf('File exists, skipping: %s\n',outFilename);
%         return;
%         end
%     end
    outFile = matfile(fullfile(cfg.localTmp,outFilename),'Writable',true);
end

% Copy any variables from inFile to outFile except 'pixels'
copyFields = fieldnames(data);
copyFields = copyFields(~strcmp(copyFields,'voxelList'));
for cnt=1:numel(copyFields)
    outFile.(copyFields{cnt}) = data.(copyFields{cnt});
end

%set some defaults
parameter.centerHW       = 3;    % How large the center half width is for the center traces
parameter.minPkD         = round(200e-6/cfg.dz); % Limit the peak spacing to 200 um
parameter.pkpct          = 90; % The percentile a peak (or trough) must be to be considered a peak.
parameter.maxNPks        = 1; % How many peaks are allowed.
parameter.minZSlices      = 0;
parameter.maxZSlices      = inf;

parameter.lminZ         =  1/1000; %minimum z Postion [m]
parameter.lmaxZ         =  20/1000; %minimum z Postion [m]
parameter.minZDistance  =  1/1000; %minimum z Distance between two Particle [m]
parameter.borderPixel   = 50;      %Border Pixel
parameter.factorDisXY   = 1.2;       % minimum Distance in XY between Particle is (Radius1 + Radius2)*factor DisXY
parameter.factorDisZ    = 2;       % minimum Distance in Z between Particle is (zExtension1 + zExtension2)*factor DisZ

%%%%%%%%%%%%%%%%%%%% Make the trace maps
%amplitude statistics
parameter.trM{1} = {'Max Center Amp' , 'getCenter', 'ampBlock', 'max'};
parameter.trM{end+1} = {'Min Center Amp' , 'getCenter', 'ampBlock', 'min'};
parameter.trM{end+1} = {'Mean Center Amp', 'getCenter', 'ampBlock', 'mean'};
parameter.trM{end+1} = {'STD Center Amp' , 'getCenter', 'ampBlock', 'std'};
parameter.trM{end+1} = {'STD Sobel Amp' , 'getSobel', 'ampBlock', 'std'};
parameter.trM{end+1} = {'STD Sobel Comp' , 'getSobel', 'pBlock', 'std'};
parameter.Trace_1_Tind = 1:numel(parameter.trM);

%phase statistics
parameter.trM{end+1} = {'Max Center Phase' , 'getCenter', 'phBlock', 'max'};
parameter.trM{end+1} = {'Min Center Phase' , 'getCenter', 'phBlock', 'min'};
parameter.trM{end+1} = {'Mean Center Phase', 'getCenter', 'phBlock', 'mean'};
parameter.trM{end+1} = {'STD Center Phase' , 'getCenter', 'phBlock', 'std'};
parameter.trM{end+1} = {'STD Sobel Phase' , 'getSobel', 'phBlock', 'std'};
parameter.Trace_2_Tind = max(parameter.Trace_1_Tind)+1:numel(parameter.trM);

%particle size
parameter.trM{end+1} = {'Particle Area', 'getWhole', 'ampBlock', 'area'};
parameter.trM{end+1} = {'Particle Diameter', 'getWhole', 'ampBlock', 'diameter'};
parameter.Trace_3_Tind = max(parameter.Trace_2_Tind)+1:numel(parameter.trM);

%%%%%%%%%%%%%%%%%%%% Make the value maps (peaks and troughs of traces)
% peaks and troughs
% parameter.valM{1} = {'STD Sobel Amp',    5, 'selSigPks'};
% parameter.valM{end+1} = {'STD Sobel Comp',    6, 'selSigPks'};
parameter.Trace_1_Vind = []; %1:numel(parameter.valM);

parameter.valM{1} = {'STD Sobel Phase',    11, 'selSigPks'};
parameter.Trace_2_Vind = 1:numel(parameter.valM); %max(parameter.Trace_1_Vind)+1:numel(parameter.valM);

parameter.Trace_3_Vind = [];

%copy parameter to outfile
outFile.parameter = parameter;

nPart = size(data.voxelList,2);

partIsValid = false(1,numel(nPart));
clear partStats;
partXYExtend = zeros(1,numel(nPart));
partZExtend = zeros(1,numel(nPart));
clear partImage;
partIsBorder = false(1,numel(nPart));

for i = 1:nPart;
    %particle creation
    part=particle(data.voxelList{1,i},data.voxelList{2,i},data.Nx,data.Ny,data.zs);
    
    part.ampLowThresh    = data.ampThresh(1);
    part.ampHighThresh   = data.ampThresh(2);
    part.config_handle   = cfg;
    part.phaseLowThresh  = cfg.phaseLowThresh;
    part.phaseHighThresh = cfg.phaseHighThresh;
    
    part.centerHW = parameter.centerHW;
    part.minPkD = parameter.minPkD;
    part.pkpct = parameter.pkpct;
    part.maxNPks = parameter.maxNPks;
    part.minZSlices = parameter.minZSlices;
    part.maxZSlices = parameter.maxZSlices;
    
    %part.refreshPB;
    
    %Add all of the traces to the particleGroup object
    for cnt = 1:numel(parameter.trM)
        part.addTrace(parameter.trM{cnt});
    end
    %Add all the value maps to the particleGroup object
    for cnt = 1:numel(parameter.valM)
        part.addValue(parameter.valM{cnt});
    end
    
    % Assign the zPosText selection function and which values we want
    part.zPosSelFcn = @mean;
    part.zPosValues = 1:part.Nvalues;
    part.refreshPB;
    partIsValid(i) = part.isValidParticle(parameter.minZSlices, parameter.maxZSlices, ...
        cfg.phaseLowThresh, cfg.phaseHighThresh, ...
        data.ampThresh(1), data.ampThresh(2));
    
    partStats(i)   = part.spitOutEssStats;
    partZExtend(i) = part.lNz*part.dz;
    partXYExtend(i) = sqrt(part.lNx*part.dx*part.lNy*part.dy);
    
    partImage{i} = part.pImage;
    
    partIsBorder(i) = isBorderParticle(part, partStats(i), parameter.lminZ, parameter.lmaxZ, parameter.borderPixel);   
end

if nPart == 0
    partIsSatelite = nan;
    partSateliteTo = nan;
else
    [partIsSatelite partSateliteTo] = isSateliteParticle(partStats, partXYExtend, partZExtend, parameter.factorDisXY , parameter.factorDisZ, parameter.minZDistance); 
end


    
if nPart == 0
    outFile.pImage = {[]};
    outFile.xPos = nan;
    outFile.yPos = nan;
    outFile.zPos = nan;
    outFile.zLInd = nan;
    outFile.xyExtend = nan;
    outFile.zExtend = nan;
    outFile.pDiam = nan;
    outFile.pDiamFilled = nan;
    outFile.minPh = nan;
    outFile.maxPh = nan;
    outFile.pEssent = nan;
    outFile.pEssentFilled = nan;
    outFile.partIsValid = nan;
    outFile.partIsBorder = nan;
    outFile.partIsSatelite = nan;
    outFile.partSateliteTo = nan;
else
    outFile.pImage = partImage;
    outFile.xPos = cell2mat({partStats.xPos});
    outFile.yPos = cell2mat({partStats.yPos});
    outFile.zPos = cell2mat({partStats.zPos});
    outFile.zLInd = cell2mat({partStats.zLInd});
    outFile.xyExtend = partXYExtend;
    outFile.zExtend = partZExtend;
    outFile.pDiam = cell2mat({partStats.pDiam});
    outFile.pDiamFilled = cell2mat({partStats.pDiamFilled});
    outFile.minPh = cell2mat({partStats.minPh});
    outFile.maxPh = cell2mat({partStats.maxPh});
    outFile.pEssent = cell2mat({partStats.pEccent});
    outFile.pEssentFilled = cell2mat({partStats.pEccentFilled});
    outFile.partIsValid = partIsValid;
    outFile.partIsBorder = partIsBorder;
    outFile.partIsSatelite = partIsSatelite;    
    outFile.partSateliteTo = partSateliteTo;  
end

mainTime = toc(mainTic);
fprintf('---------------------------\nFinal Time for Particle Statistik: %.2f\n',mainTime);
logText(cfg.statusLog, sprintf('Final Time for Particle Statistik: %.2f',mainTime));

% %call HoloViewer
% data.cfg.writefile(fullfile(pwd,'holoviewer2.cfg'));
% handles = holoViewer('holoviewer2.cfg');
% 
% for cpar = 1:numel(partStats);
%     temp(1) = partStats(cpar).xPos - partXYExtend(cpar)*parameter.factorDisXY/2;
%     temp(2) = partStats(cpar).yPos - partXYExtend(cpar)*parameter.factorDisXY/2;
%     temp(3) = partXYExtend(cpar)*parameter.factorDisXY;
%     temp(4) = partXYExtend(cpar)*parameter.factorDisXY;
%     
%     if sum(isnan(temp)) == 0;
%        temp = temp.*1000000;
%        text(temp(1), temp(2), ...
%            num2str(cpar), 'Parent', handles.imagePlot);
%        text(temp(1), temp(2)+temp(4), ...
%            num2str(partStats(cpar).zPos*1000,'%04.2f'), 'Parent', handles.imagePlot);
%        text(temp(1)+temp(3), temp(2), ...
%            num2str(partXYExtend(cnt)*1000,'%04.2f'), 'Parent', handles.imagePlot);
%        text(temp(1)+temp(3), temp(2)+temp(4), ...
%            num2str(partStats(cpar).pEccent,'%04.3f'), 'Parent', handles.imagePlot);
%        if ~partIsValid(cpar)
%            rectangle('Parent', handles.imagePlot, 'Position', temp, ...
%                'EdgeColor', 'w', 'Curvature', [1,1]);
%        elseif ~partIsBorder(cpar)
%            rectangle('Parent', handles.imagePlot, 'Position', temp, ...
%                'EdgeColor', 'y', 'Curvature', [1,1]);
%        elseif ~partIsSatelite(cpar)
%            rectangle('Parent', handles.imagePlot, 'Position', temp, ...
%                'EdgeColor', 'r', 'Curvature', [1,1]);
%        else
%            rectangle('Parent', handles.imagePlot, 'Position', temp, ...
%                'EdgeColor', 'g', 'Curvature', [1,1]);
%        end       
%     end
% end
% 
% temp(1) = (parameter.borderPixel-data.Nx/2)*cfg.dx;
% temp(2) = (parameter.borderPixel-data.Ny/2)*cfg.dy;
% temp(3) = abs(data.Nx-2*parameter.borderPixel)*cfg.dx;
% temp(4) = abs(data.Ny-2*parameter.borderPixel)*cfg.dy;
% temp = temp.*1000000;
% rectangle('Parent', handles.imagePlot, 'Position', temp, ...
%            'EdgeColor', 'y');

end

function isBorder = isBorderParticle(part, stats, lminZ, lmaxZ, borderPixel)
    if stats.zPos < part.allZ(2) || ...
           stats.zPos > part.allZ(end-1) || ...
           stats.zPos < lminZ || ...
           stats.zPos > lmaxZ;
       isBorder = true;
    elseif stats.xPos < (borderPixel - part.gNx/2)*part.dx || ...
            stats.yPos < (borderPixel - part.gNy/2)*part.dy || ...
            stats.xPos > (part.gNx/2 - borderPixel)*part.dx || ...
            stats.yPos > (part.gNy/2 - borderPixel)*part.dy;
        isBorder = true;
    else
        isBorder = false;
    end
end

function [isSatelite sateliteTo] = isSateliteParticle(stats, xyExtend, zExtend, factorDisXY, factorDisZ, minZDistance)
    isSatelite = false(1,numel(stats));
    sateliteTo = zeros(1,numel(stats));
    for i = 1:numel(stats)
        for j = 1:numel(stats);
            if i~=j && stats(i).pDiam < stats(j).pDiam
                if ((stats(i).xPos - stats(j).xPos)^2 + (stats(i).yPos - stats(j).yPos)^2)^(1/2)...
                        <= (xyExtend(i) + xyExtend(j)) / 2 * factorDisXY ...
                        && ...
                        abs(stats(i).zPos - stats(j).zPos)...
                        <= max([(zExtend(i) + zExtend(j)) / 2 * factorDisZ minZDistance])
                    isSatelite(i) = true;
                    sateliteTo(i) = j;
                    break
                end
            end
        end
    end
end


