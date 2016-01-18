%%batch file to reconstruct holograms from CLACE2014
%%Overview of data with 1 hologram/s

%prerequisite: holograms saved in subfolders / config in directory
%inputs: holograms, config file
%used routines: batch_reconstruct
%output: writes reconstruction files (_pl) to subfolders with prenames

%reconstruct xxx files per second
framerate = 0;
%prename of reconstruction folder
files.preNameRecFolder = 'CL2014_Blowtest';
%start reconstruction von xxx subfolder
files.startFrom = 1;

%folder of the raw images (holgorams)
files.Drive = 'Z:\1_Raw_Images\2014_CLACE2014_BLOWTEST';

%folder for reconstructed _pl files
files.RecDrive = 'Z:\2_HOLOSUITE_Data\CL2014_Blowtest';

%load config file
cd(files.Drive);
cfg=config('holoviewer.cfg');
cfg.hologram_filter = 'png';
cfg.threshOp = @or;
cfg.ampLowThresh = -6.5;
cfg.phaseLowThresh = -pi;
cfg.phaseHighThresh = pi;
cfg.dz = 50e-06;
cfg.zMax = 52e-03;
cfg.GPU = [1 2];
cfg.workers = 2;

%find Dates of Measurements
files.Date = dirFolder(files.Drive);

%over Dates
for recDate = 1%numel(files.Date)
    
    %find Time of Measurements
    files.Time = dirFolder(fullfile(files.Drive,files.Date{recDate}));
    
    %over Times
    for recTime = 7:11%1:numel(files.Time)
        
        %get subfolder names
        files.Folders = dirFolder(fullfile(files.Drive, files.Date{recDate}, files.Time{recTime}));
        
        %loop over subfolders
        for recPart = files.startFrom:numel(files.Folders)
            
            
            %go to subfolder
            files.Path = (fullfile(files.Drive, files.Date{recDate}, ...
                files.Time{recTime}, cell2mat(files.Folders(recPart))));
            files.recPath = (fullfile(files.RecDrive, files.Date{recDate}, ...
                files.Time{recTime}));
            
            %get hologram file names
            cd(files.Path);
            holofilenames = dir('*.png');
            holofilenames = {holofilenames.name};
            
            %check for ice on windows and double exposure
            [holofilenames, blackList] = findBadHolograms2014(holofilenames, 100000);
            cfg.blacklist = blackList.holofilenamesBad';
            
            %reduce hologfilenames list to framerate
            if framerate ~= 0
                holofilenames = reduceHololist(holofilenames, framerate);
            end
            
            %define and write reconstruction parameter to cfg file
            cfg.path = files.Path;
            cfg.localTmp = files.recPath;
            cfg.writefile;
            
            if ~isdir(files.recPath); mkdir(files.recPath); end
            cd(files.recPath);
            cfg.writefile;
            cd(files.Path);
            
            seq{1}=holofilenames;
            seq{2}=[files.preNameRecFolder '_' cell2mat(files.Folders(recPart))];
            reconstruct_sequence(cfg, seq);
            
        end
    end
end