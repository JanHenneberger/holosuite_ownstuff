clear all
msfiles = dir('H*');
msfiles = {msfiles.name};
mergeMsFilesSuite(pwd,  '' ,...
   [msfiles{1}(1:25) '-' msfiles{1}(29:31) '-' msfiles{end}(29:31)],...
   'F:\CLACE2013\All\AsFiles')