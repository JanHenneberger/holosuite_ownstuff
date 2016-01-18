files.Drive = 'G:\Kalibrierung';
files.Date = 'HOLIMO';
files.Time = '2-15-45';
files.Path = fullfile(files.Drive, files.Date, files.Time);
%files.Time = '3-14-55';

cd(files.Path);

files.Folders = dir('suite*');
files.isDir = {files.Folders.isdir};
files.isDir = cell2mat(files.isDir);
files.Folders = {files.Folders.name};
files.Folders = files.Folders(files.isDir == 1);

cfg=config('holoviewer.cfg');
cfg.path = pwd;
cfg.localTmp = pwd;
cfg.writefile('holoviewer.cfg');


for recPart =1:numel(files.Folders)
    
    cd(fullfile(files.Path,cell2mat(files.Folders(recPart))));
    cfg=config('holoviewer.cfg');
    cfg.path = pwd;
    cfg.localTmp = pwd;
    cfg.writefile('holoviewer.cfg');
    
    
    
%     if matlabpool('size') > 1
%         %config.processPLFiles('holoviewer.cfg','.',[],1,30,2e8);
%         filestodo = config.getFilesToDo('.', '_pl.mat', '.',...
%             '_vg.mat', 5e8);
%         for cnt=1:numel(filestodo)
%             try
%                 connectVoxels.connect(filestodo{cnt}, cfg);
%             catch exception
%                 warning(sprintf('Error connection voxels in %s.\n %s', ...
%                     filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
%             end
%         end
%         
%         %config.processVGFiles('holoviewer.cfg','.',1,30,2e8);
%         %filestodo = config.getFilesToDo('.', '_vg.mat', '.', '_ps.mat', 5e8);
%         
%          vgfilenames = dir('*_vg.mat'); % Get the vg files
%          vgfilenames = {vgfilenames.name};
%         for cnt=1:numel(vgfilenames)
%             try
%                 particleGroup.statParticles(vgfilenames{cnt},cfg);
%             catch exception
%                 warning(sprintf('Error making PS Files for %s.\n %s',vgfilenames{cnt},exception.message)); %#ok<WNTAG,SPWRN>
%             end
%         end
%     else
%         %config.processPLFiles('holoviewer.cfg','.',[],1,30,2e8);
%         filestodo = config.getFilesToDo('.', '_pl.mat', '.',...
%             '_vg.mat', 5e8);
%         for cnt=1:numel(filestodo)
%             try
%                 connectVoxels.connect(filestodo{cnt}, cfg);
%             catch exception
%                 warning(sprintf('Error connection voxels in %s.\n %s', ...
%                     filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
%             end
%         end
%         
%         %config.processVGFiles('holoviewer.cfg','.',1,30,2e8);
%         filestodo = config.getFilesToDo('.', '_vg.mat', '.', '_ps.mat', 5e8);
%         for cnt=1:numel(filestodo)
%             try
%                 particleGroup.statParticles(filestodo{cnt},cfg);
%             catch exception
%                 warning(sprintf('Error making PS Files for %s.\n %s',filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
%             end
%         end
%     end
    
    mergePsFilesSuite(pwd, [files.Time '-' cell2mat(files.Folders(recPart))]...
        , fullfile(files.Drive, 'ParticleStats'));
end

mergeMsFilesSuite(fullfile(files.Drive, 'ParticleStats'), files.Time, 'Beads06um', fullfile(files.Drive, 'ParticleStats'))