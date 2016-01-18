dilutionFactor = '1';

files.Drive = 'G:';
files.Date = 'TestCase13';
files.Time = '';
files.startFrom = 1;
files.Path = fullfile(files.Drive, files.Date, files.Time);

cd(files.Path);

cfg=config('holoviewer.cfg');
cfg.hologram_filter = 'png';
cfg.path = pwd;
cfg.localTmp = pwd;

cfg.threshOp = @or;
cfg.ampLowThresh = -8;
cfg.phaseLowThresh = -pi;
cfg.phaseHighThresh = pi;
cfg.dz = 50e-06;

cfg.writefile('holoviewer.cfg');   
    
    holofilenames = dir('*.png');
    holofilenames = {holofilenames.name};   
   
    cfg.path = pwd;
    if ~isempty(holofilenames)
        cfg.current_holo = holofilenames(1);
        cfg.sequences = [cell2mat(holofilenames(1)) ' : ' dilutionFactor ...
            ' : ' cell2mat(holofilenames(end)) ', ' ...
            'Rec'];
        cfg.writefile('holoviewer.cfg');
        batch_reconstruct('holoviewer.cfg');
    end