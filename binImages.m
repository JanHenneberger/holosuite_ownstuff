clc
OriginalFolder='G:\RecTiming\03pin';
Pinned_Folder='G:\RecTiming\04pin';  %fullfile(OriginalFolder, 'Pinned\');
mkdir(Pinned_Folder);
Original_Files=dir(fullfile(OriginalFolder,'*.png'));
Original_Files={Original_Files.name};
uS = etd(clock, 1, numel(Original_Files), 30); 
for i=1:length(Original_Files);
    try Resolution_image=imread(fullfile(OriginalFolder,Original_Files{i}));
    catch exception, warning(sprintf('Error read in File %s\n%s', Original_Files{i} , exception.message));continue;
    end
    Resolution_image = pinning(double(Resolution_image),2); 
    Resolution_image=Resolution_image-min(min(Resolution_image));
    Resolution_image=Resolution_image./max(max(Resolution_image));
    Resolution_image=(Resolution_image);
    File_Name=Original_Files{i}(1:end-4);
    File_Name=regexprep(File_Name,'\.','-');
    File_Name=[File_Name '.png'];
    imwrite(single(Resolution_image),fullfile(Pinned_Folder,File_Name));
    
    uS=etd(uS, i);
end

