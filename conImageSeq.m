function conImageSeq(OriginalFolder,ImagesFolder)

Original_Files=dir(fullfile(OriginalFolder,'*.seq'));
Original_Files={Original_Files.name};

if ~exist(ImagesFolder,'dir'), ...
        mkdir(ImagesFolder);
end

    for i=1:numel(Original_Files)
        fprintf('%03u von %03u \n',i,numel(Original_Files));   
       
        convertSeq(fullfile(OriginalFolder, Original_Files{i}), ...
            ImagesFolder,10000);
    
%         try Resolution_image=imread(fullfile(OriginalFolder,Original_Files{i}));
%         catch exception, warning(sprintf('Error read in File %s\n%s', Original_Files{i} , exception.message));continue;
%         end
%         Resolution_image=double(Resolution_image);
%         Resolution_image=Resolution_image-min(min(Resolution_image));
%         Resolution_image=Resolution_image./max(max(Resolution_image)).*255;
%         Resolution_image=pinning(Resolution_image,2);
%         Resolution_image=uint8(Resolution_image);
%         File_Name=Original_Files{i}(1:end-4);
%         File_Name=regexprep(File_Name,'\.','-');
%         File_Name=[File_Name '.png'];
%         imwrite(Resolution_image,fullfile(Pinned_Folder,File_Name));
    end


    