dilutionFactor = '15';
serieName = 'April';

cfg=config('holoviewer.cfg');
cfg.hologram_filter = 'png';
cfg.path = pwd;
cfg.localTmp = pwd;
holofilenames = dir('*.png');
holofilenames = {holofilenames.name};

cfg.threshOp = @or;
cfg.ampLowThresh = -8;
cfg.phaseLowThresh = -pi;
cfg.phaseHighThresh = pi;
cfg.dz = 50e-06;

cfg.hologram_filter = 'png';

%check for ice on windows and double exposure
% [holofilenames blackList] = findBadHolograms(holofilenames);
% cfg.blacklist = blackList.holofilenamesBad';

cfg.writefile('holoviewer.cfg');

%Devide outputFile in Portion of portionSize Particles
fileNumber = numel(holofilenames);
portionSize = 1000;
portionSize = portionSize * str2num(dilutionFactor);
for recPart = 1:ceil(fileNumber/portionSize)
    
    if recPart ~= ceil(fileNumber/portionSize)
        fileIndex = (1:portionSize)+(recPart-1)*portionSize;
    else
        fileIndex = ((recPart-1)*portionSize+1):fileNumber;
    end
    folderName = [serieName num2str(recPart,'%03u')];
    
    
    
    cfg.current_holo = holofilenames(fileIndex(1));
    cfg.sequences = [cell2mat(holofilenames(fileIndex(1))) ' : ' dilutionFactor ...
        ' : ' cell2mat(holofilenames(fileIndex(end))) ' , ' folderName];
    cfg.writefile('holoviewer.cfg');
    
    batch_reconstruct('holoviewer.cfg');    
end