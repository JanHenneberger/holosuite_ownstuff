%%batch_file to get particle information
%prerequisite: _pl-files in subfolders, config directory
%inputs: _pl-files, config file
%used routines: connectVoxels.connect, particleGroup.statParticle,
%               mergePSFilesSuite, mergeMSFilesSuite
%output:

%prename of reconstruction folder
files.preNameRecFolder = 'CL2014_Ov2';

%folder for reconstructed _pl files
files.recDrive = 'Z:\2_HOLOSUITE_Data\2014_CLACE2014\Overview2';

%find Dates of Measurements
files.recDate = dirFolder(files.recDrive);

%over Date
for recDate = 2:2%numel(files.recDate)
    
    %find Time of Measurements
    files.recTime = dirFolder(fullfile(files.recDrive,files.recDate{recDate}));
    
    %over Times
    for recTime = 2:2%numel(files.recTime)          
        
        %find subdirectories
        files.recFolders = dir(fullfile(files.recDrive,files.recDate{recDate},...
            files.recTime{recTime},[files.preNameRecFolder '_*']));
        files.isDir = {files.recFolders.isdir};
        files.isDir = cell2mat(files.isDir);
        files.recFolders = {files.recFolders.name};
        files.recFolders = files.recFolders(files.isDir == 1);
        
  
        %loop over supfolders with pl-files
        for recPart =1:numel(files.recFolders)
            
            %go to supdirectory
            cd(fullfile(files.recDrive,files.recDate{recDate},...
            files.recTime{recTime},cell2mat(files.recFolders(recPart))));
            
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
            
            mergePsFiles2014(pwd, [files.recDate{recDate} '-' files.recTime{recTime} '-' cell2mat(files.recFolders(recPart))]...
                , fullfile(files.recDrive, 'ParticleStats'));
        end
        
        %define name of as-files
        files.asName = [files.recDate{recDate} '-' files.recTime{recTime}];
        
        mergeMsFiles2014(fullfile(files.recDrive, 'ParticleStats'),  files.asName,...
            ['H-', files.recDate{recDate} '-' files.recTime{recTime} '-' files.recFolders{1}(1:3) '-' files.recFolders{1}(end-2:end) '-' files.recFolders{end}(end-2:end)],...
            fullfile(files.recDrive, 'ParticleStats'))
        
        
    end
end

