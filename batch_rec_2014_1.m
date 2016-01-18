%%batch file to reconstruct holograms
%prerequisite: holograms saved in subfolders / config in directory
%inputs: holograms, config file
%used routines: batch_reconstruct
%output: writes reconstruction files (_pl) to subfolders with prenames

%reconstruct only any xxx file
dilutionFactor = '1';
%prename of reconstruction folder
files.preNameRecFolder = 'HS2013';
%start reconstruction von xxx subfolder
files.startFrom = 97;

%folder of the raw images (holgorams)
files.Drive = 'c:';
files.Date = '2013-02-12';
files.Time = '15-56-56';
files.Path = fullfile(files.Drive, files.Date, files.Time);

%go to hologram folder 
cd(files.Path);

%get subfolder names
files.Folders = dir('*.*');
files.isDir = {files.Folders.isdir};
files.isDir = cell2mat(files.isDir);
files.Folders = {files.Folders.name};
files.Folders = files.Folders(files.isDir == 1);
files.Folders = files.Folders(3:end);

%define and write reconstruction parameter to cfg file
cfg=config('holoviewer.cfg');
cfg.hologram_filter = 'png';
cfg.path = pwd;
cfg.localTmp = pwd;
cfg.threshOp = @or;
cfg.ampLowThresh = -8;
cfg.phaseLowThresh = -pi;
cfg.phaseHighThresh = pi;
cfg.dz = 50e-06;
cfg.writefile;

%loop over subfolders
for recPart = files.startFrom:numel(files.Folders)
    
    %go to subfolder
    cd(fullfile(files.Path,cell2mat(files.Folders(recPart))));
    
    %get hologram file names
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
            files.preNameRecFolder '_' , dilutionFactor, '_',...
            cell2mat(files.Folders(recPart))];
        cfg.writefile(fullfile(files.Path,cell2mat(files.Folders(recPart)),...
            'holoviewer.cfg'));
        batch_reconstruct('holoviewer.cfg');
    end
end