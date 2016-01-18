
%files.Times = {};
files.Times = {'10-24-31'};
for cntTime = 1:numel(files.Times)
    
    dilutionFactor = '1';
    
    files.Drive = 'Z:\1_Raw_Images\2013_CLACE2013';
    files.Date = '2013-02-07';
    files.Time = files.Times{cntTime};
    cd(fullfile(files.Drive, files.Date));
    cfg=config('holoviewer.cfg');
    
    files.Path = fullfile(files.Drive, files.Date, files.Time);
    cd(files.Path);
    
    
    files.Folders = dir('*.*');    
    files.isDir = {files.Folders.isdir};
    files.isDir = cell2mat(files.isDir);
    files.Folders = {files.Folders.name};
    files.Folders = files.Folders(files.isDir == 1);
    files.Folders = files.Folders(3:end);
    
    files.startFrom = 42;
    files.until = numel(files.Folders);
    
    cfg.hologram_filter = 'png';
    cfg.path = pwd;
    cfg.localTmp = pwd;
    
    
    cfg.threshOp = @or;
    cfg.ampLowThresh = -8;
    cfg.phaseLowThresh = -pi;
    cfg.phaseHighThresh = pi;
    cfg.dz = 50e-06;
    
    cfg.writefile(fullfile(pwd,'holoviewer.cfg'));
    
    for recPart = files.startFrom:files.until
        
        cd(fullfile(files.Path,cell2mat(files.Folders(recPart))));
        
        holofilenames = dir('*.png');
        holofilenames = {holofilenames.name};
        
        %check for ice on windows and double exposure
        [holofilenames blackList] = findBadHolograms(holofilenames);
        cfg.blacklist = blackList.holofilenamesBad';
        
        cfg.path = pwd;
        if ~isempty(holofilenames)
            cfg.current_holo = holofilenames(1);
            cfg.sequences = [cell2mat(holofilenames(1)) ' : ' dilutionFactor ...
                ' : ' cell2mat(holofilenames(end)) ', ' ...
                'HS2013_' , dilutionFactor, '_',...
                cell2mat(files.Folders(recPart))];
            cfg.writefile(fullfile(files.Path,cell2mat(files.Folders(recPart)),...
                'holoviewer.cfg'));
            batch_reconstruct('holoviewer.cfg');
        end
    end
end