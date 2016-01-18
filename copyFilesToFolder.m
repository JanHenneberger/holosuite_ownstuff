holofilenames = dir('*.png');
holofilenames = {holofilenames.name};

fileNumber = numel(holofilenames);
portionSize = 1000;
for recPart = 1:ceil(fileNumber/portionSize)
    folderName = num2str(recPart,'%03u');
    if ~exist(folderName,'dir'), mkdir(folderName); end
end