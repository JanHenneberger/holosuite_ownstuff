%%batch_file to get particle information
%prerequisite: _pl-files in subfolders, config directory
%inputs: _pl-files, config file
%used routines: connectVoxels.connect, particleGroup.statParticle,
%               mergePSFilesSuite, mergeMSFilesSuite
%output: 


% files.Drive = 'G:\Kalibrierung';
% files.Date = 'HOLIMO';
% files.Time = '3-14-55';
% files.Part = '001';
% files.asName = 'Beads10um';

%folder of the pl-files
files.Drive = 'Z:\2_HOLOSUITE_Data\2013_CLACE2013_All';
files.Date = '2013-02-12';
files.Time = '15-56-56';
files.Part = '';
files.preNameRecFolder = 'All';
%define name of as-files
files.asName = [files.Date '-' files.Time];

%go to directory whre as files are
files.Path = fullfile(files.Drive, files.Date, files.Time, files.Part);
cd(files.Path);

%find subdirectories
files.Folders = dir([files.preNameRecFolder '_*']);
files.isDir = {files.Folders.isdir};
files.isDir = cell2mat(files.isDir);
files.Folders = {files.Folders.name};
files.Folders = files.Folders(files.isDir == 1);

%update config file
cfg=config('holoviewer.cfg');
cfg.path = pwd;
cfg.localTmp = pwd;
cfg.writefile('holoviewer.cfg');

%loop over supfolders with pl-files
for recPart =1:numel(files.Folders)
    
    %go to supdirectory
    cd(fullfile(files.Path,cell2mat(files.Folders(recPart))));
    
    %update config file
    cfg=config('holoviewer.cfg');
    cfg.path = pwd;
    cfg.localTmp = pwd;
    cfg.writefile('holoviewer.cfg');
    
    
    %more than one GPU
     if matlabpool('size') > 1
        %config.processPLFiles('holoviewer.cfg','.',[],1,30,2e8);
        
        %do connectVoxels (pl-->vg)
        filestodo = config.getFilesToDo('.', '_pl.mat', '.',...
            '_vg.mat', 5e8);
        parfor cnt=1:numel(filestodo)
            try
                connectVoxels.connect(filestodo{cnt}, cfg);
            catch exception
                warning(sprintf('Error connection voxels in %s.\n %s', ...
                    filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
            end
        end
        
        %config.processVGFiles('holoviewer.cfg','.',1,30,2e8);
        
        %do statParticles (vg-->ps), deletes vg files
        filestodo = config.getFilesToDo('.', '_vg.mat', '.', '_ps.mat', 5e8);
        parfor cnt=1:numel(filestodo)
            try
                particleGroup.statParticles(filestodo{cnt},cfg);
            catch exception
                warning(sprintf('Error making PS Files for %s.\n %s',filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
            end
        end
     else
        %config.processPLFiles('holoviewer.cfg','.',[],1,30,2e8);
        filestodo = config.getFilesToDo('.', '_pl.mat', '.',...
            '_vg.mat', 5e8);
        for cnt=1:numel(filestodo)
            try
                connectVoxels.connect(filestodo{cnt}, cfg);
            catch exception
                warning(sprintf('Error connection voxels in %s.\n %s', ...
                    filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
            end
        end
        
        config.processVGFiles('holoviewer.cfg','.',1,30,2e8);
        filestodo = config.getFilesToDo('.', '_vg.mat', '.', '_ps.mat', 5e8);
        for cnt=1:numel(filestodo)
            try
                particleGroup.statParticles(filestodo{cnt},cfg);
            catch exception
                warning(sprintf('Error making PS Files for %s.\n %s',filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
            end
        end
    end
    
    mergePsFiles2014(pwd, [files.Date '-' files.Time '-' cell2mat(files.Folders(recPart))]...
       , fullfile(files.Drive, 'ParticleStats'));
end

mergeMsFiles2014(fullfile(files.Drive, 'ParticleStats'),  files.asName,...
    ['H-', files.Date '-' files.Time '-' files.Folders{1}(1:3) '-' files.Folders{1}(end-2:end) '-' files.Folders{end}(end-2:end)],...
    fullfile(files.Drive, 'ParticleStats'))