% particleNumber = 1;
% 
% filesPerFolder = 500;
% tmp = find(data.pDiam > 34e-6 & data.partIsRealCor);
% tmp2 = data.indHolo(tmp(particleNumber))
% 
% if tmp2 < 14006
%     serieName = '001';
% else
%     tmp2 = tmp2-14005;
%     serieName = '002';
% end
% folderNumber = ceil(tmp2/filesPerFolder);
% filesNumber = mod(tmp2, filesPerFolder);
% 

% holopath = fullfile(rootpath, serieName);

% infopath = fullfile(rootpath, ['All_Folder' serieName '_Part' num2str(folderNumber,'%03u')]);
% cd(infopath);
% 

filesNumber = 10;
date = '2014-02-15\23-14-55';
part = '099';
rootpath = ['D:\2014_CL2014_Overview\' date '\CL2014_Ov_' part];
holopath = ['Z:\1_Raw_Images\2014_CLACE2014\' date '\' part];
infopath = 'D:\HOLIMO_synthetisch\ReconPDHOLIMO18um';
% 
cd(rootpath);
psfilenames = dir('*_ps.mat');
psfilenames = {psfilenames.name};
showPartHoloViewer(psfilenames{filesNumber},rootpath, holopath, infopath);
cd (rootpath);