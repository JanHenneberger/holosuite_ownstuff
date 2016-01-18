%matlabpool open 3

%
    files.Drive = 'Z:\1_Raw_Images\2013_CLACE2013';
    files.Date = '2013-02-07';
    cd(fullfile(files.Drive, files.Date));
    files.Times = dir('*.*');
    isdir = cell2mat({files.Times.isdir});
    files.Times = {files.Times.name};
    files.Times = files.Times(isdir);
    files.Times = files.Times(3:end);
    
for cntTime = [3]%numel(files.Times)
    % files.Drive = 'G:\Kalibrierung';
    % files.Date = 'HOLIMO';
    % files.Time = '3-14-55';
    % files.Part = '001';
    % files.asName = 'Beads10um';

    files.Time = files.Times{cntTime};
    files.Part = '';
    files.asName = [files.Date '-' files.Time];
    files.Path = fullfile(files.Drive, files.Date, files.Time, files.Part);
    
    cd(files.Path);
    
    files.Folders = dir('HS2013_*');
    files.isDir = {files.Folders.isdir};
    files.isDir = cell2mat(files.isDir);
    files.Folders = {files.Folders.name};
    files.Folders = files.Folders(files.isDir == 1);
    
    cfg=config('holoviewer.cfg');
    cfg.path = pwd;
    cfg.localTmp = pwd;
    cfg.writefile('holoviewer.cfg');
    
    
    for recPart =65:numel(files.Folders)
        
         cd(fullfile(files.Path,cell2mat(files.Folders(recPart))));
        cfg=config('holoviewer.cfg');
        cfg.path = pwd;
        cfg.localTmp = pwd;
        cfg.writefile('holoviewer.cfg');
        
        
        
        if matlabpool('size') > 1
            %config.processPLFiles('holoviewer.cfg','.',[],1,30,2e8);
            filestodo = config.getFilesToDo('.', '_pl.mat', '.',...
                '_vg.mat', 5e8);
            parfor cnt=1:numel(filestodo)
                try
                    connectVoxels.connect(filestodo{cnt}, cfg, 300);
                catch exception
                    warning(sprintf('Error connection voxels in %s.\n %s', ...
                        filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
                end
            end
            
            %config.processVGFiles('holoviewer.cfg','.',1,30,2e8);
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
                    connectVoxels.connect(filestodo{cnt}, cfg,300);
                catch exception
                    warning(sprintf('Error connection voxels in %s.\n %s', ...
                        filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
                end
            end
            
            %config.processVGFiles('holoviewer.cfg','.',1,30,2e8);
            filestodo = config.getFilesToDo('.', '_vg.mat', '.', '_ps.mat', 5e8);
            for cnt=1:numel(filestodo)
                try
                    particleGroup.statParticles(filestodo{cnt},cfg);
                catch exception
                    warning(sprintf('Error making PS Files for %s.\n %s',filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
                end
            end
        end
        
        mergePsFilesSuite(pwd, [files.Date '-' files.Time '-' cell2mat(files.Folders(recPart))]...
            , fullfile(files.Drive, 'ParticleStats'));
    end
    
    mergeMsFilesSuite(fullfile(files.Drive, 'ParticleStats'),  files.asName,...
        ['H-', files.Date '-' files.Time '-' files.Folders{1}(1:3) '-' files.Folders{1}(end-2:end) '-' files.Folders{end}(end-2:end)],...
        fullfile(files.Drive, 'ParticleStats'))
end