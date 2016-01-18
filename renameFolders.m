baseFolder = 'Z:\1_Raw_Images\2015_JFJ';
cd(baseFolder);
dateFolder = dir('2015-01-27*');
dateFolder = {dateFolder.name};
%dateFolder = dateFolder(3:6);
dateFolder = dateFolder(1);

for cnt = 1:numel(dateFolder)
   cd(fullfile(baseFolder, cell2mat(dateFolder(cnt))));
   
   timeFolder = dir;
   timeFolder = {timeFolder.name};
   timeFolder = timeFolder(3:end);
   
   for cnt2 = 1:numel(timeFolder)
   disp([cnt cnt2])   
   movefile(cell2mat(timeFolder(cnt2)), ...
       fullfile(baseFolder, [cell2mat(dateFolder(cnt)) '-' ...
       cell2mat(timeFolder(cnt2))]));       
   end
   
   
   cd .. 
end
