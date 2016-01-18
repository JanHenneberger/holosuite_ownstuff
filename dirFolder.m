function [folders ] = dirFolder( searchPath )
%DIRFOLDER returns the name of all folder in the searchPath
%   Detailed explanation goes here
tmp = dir(searchPath);
isFolder = [tmp(:).isdir];
folders = {tmp(isFolder).name}';
folders(ismember(folders,{'.','..'})) = [];

end

