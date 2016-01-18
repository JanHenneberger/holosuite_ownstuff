% %matlabpool open 3
% 
% %
     files.Drive = 'Z:\1_Raw_Images\2014_Synthisch';
     cd(files.Drive);
%     files.Times = dir('*.*');
%     isdir = cell2mat({files.Times.isdir});
%     files.Times = {files.Times.name};
%     files.Times = files.Times(isdir);
%     files.Times = files.Times(3:end);
%     
% for cntTime = 1:1%numel(files.Times)
%     % files.Drive = 'G:\Kalibrierung';
%     % files.Date = 'HOLIMO';
%     % files.Time = '3-14-55';
%     % files.Part = '001';
%     % files.asName = 'Beads10um';
% 
%     files.Time = files.Times{cntTime};
%     files.Part = '';
%     files.asName = [files.Date '-' files.Time];
%     files.Path = fullfile(files.Drive, files.Date, files.Time, files.Part);
%     
%     cd(files.Path);
%     
     files.Folders = dir('SYNHOLO_*');
     files.isDir = {files.Folders.isdir};
     files.isDir = cell2mat(files.isDir);
     files.Folders = {files.Folders.name};
     files.Folders = files.Folders(files.isDir == 1);
     cfg=config('holoviewer.cfg');
     cfg.path = pwd;
     cfg.localTmp = pwd;
     cfg.writefile('holoviewer.cfg');
     
     
     for recPart =6:6%numel(files.Folders)
         
        cd(fullfile(files.Drive,cell2mat(files.Folders(recPart))));
        cfg=config('holoviewer.cfg');
         cfg.path = pwd;
         cfg.localTmp = pwd;
         cfg.writefile('holoviewer.cfg');
%         
%         
%         
%         if matlabpool('size') > 1
%             %config.processPLFiles('holoviewer.cfg','.',[],1,30,2e8);
%             filestodo = config.getFilesToDo('.', '_pl.mat', '.',...
%                 '_vg.mat', 5e8);
%             parfor cnt=1:numel(filestodo)
%                 try
%                     connectVoxels.connect(filestodo{cnt}, cfg, 300);
%                 catch exception
%                     warning(sprintf('Error connection voxels in %s.\n %s', ...
%                         filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
%                 end
%             end
%             
%             %config.processVGFiles('holoviewer.cfg','.',1,30,2e8);
%             filestodo = config.getFilesToDo('.', '_vg.mat', '.', '_ps.mat', 5e8);
%             parfor cnt=1:numel(filestodo)
%                 try
%                     particleGroup.statParticles(filestodo{cnt},cfg);
%                 catch exception
%                     warning(sprintf('Error making PS Files for %s.\n %s',filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
%                 end
%             end
%         else
%             %config.processPLFiles('holoviewer.cfg','.',[],1,30,2e8);
%             filestodo = config.getFilesToDo('.', '_pl.mat', '.',...
%                 '_vg.mat', 5e8);
%             for cnt=1:numel(filestodo)
%                 try
%                     connectVoxels.connect(filestodo{cnt}, cfg,300);
%                 catch exception
%                     warning(sprintf('Error connection voxels in %s.\n %s', ...
%                         filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
%                 end
%             end
%             
%             %config.processVGFiles('holoviewer.cfg','.',1,30,2e8);
%             filestodo = config.getFilesToDo('.', '_vg.mat', '.', '_ps.mat', 5e8);
%             for cnt=1:numel(filestodo)
%                 try
%                     particleGroup.statParticles(filestodo{cnt},cfg);
%                 catch exception
%                     warning(sprintf('Error making PS Files for %s.\n %s',filestodo{cnt},exception.message)); %#ok<WNTAG,SPWRN>
%                 end
%             end
%         end
        
        mergePsFilesSuiteSyntetisch(pwd, cell2mat(files.Folders(recPart))...
           , 'Z:\1_Raw_Images\2014_Synthisch');
     end
%     
% mergeMsFilesSuite(pwd,'06um','SYNHOLO_006um',pwd)
% end