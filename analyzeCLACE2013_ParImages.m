
anParameter.lowSize = 6;
anParameter.maxSize = 250;
anParameter.divideSize = 34;

set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);

% anParameter.ParInfoFolder = 'F:\CLACE2013\All\01-29';
% anParameter.ParInfoFolder = 'F:\CLACE2013\All\02-04-09-53';
% anParameter.ParInfoFolder = 'F:\CLACE2013\All\02-04-16-45';
% anParameter.ParInfoFolder = 'F:\CLACE2013\All\02-05';
% anParameter.ParInfoFolder = 'F:\CLACE2013\All\02-06';
% anParameter.ParInfoFolder = 'F:\CLACE2013\All\02-07-12-25';
% anParameter.ParInfoFolder = 'F:\CLACE2013\All\02-07-17-47';
% anParameter.ParInfoFolder = 'F:\CLACE2013\All\02-11-14-31';
% anParameter.ParInfoFolder = 'F:\CLACE2013\All\02-11-15-43';
% anParameter.ParInfoFolder = 'F:\CLACE2013\All\02-11-16-21';
% anParameter.ParInfoFolder = 'F:\CLACE2013\All\02-11-17-22';
% anParameter.ParInfoFolder = 'F:\CLACE2013\All\02-12';


anParameter.ParInfoFolder = 'D:\CLACE2014-1s\ms';

if ~exist(anParameter.ParInfoFolder,'dir'), mkdir(anParameter.ParInfoFolder); end
cd(anParameter.ParInfoFolder);
anParameter.ParInfoFiles = dir('*_ms.mat');
anParameter.ParInfoFiles = {anParameter.ParInfoFiles.name};
for fileNr = 1:numel(anParameter.ParInfoFiles)
    cd(anParameter.ParInfoFolder);
    fileNr
    dataAll = load(anParameter.ParInfoFiles{fileNr});
    dataAll = dataAll.outFile;
    
    anParameter.cfg = config(fullfile('D:\CLACE2014-1s', 'holoviewer.cfg'));
    [anParameter.histBinBorder anParameter.histBinSizes anParameter.histBinMiddle] ...
        = getHistBorder(anParameter.divideSize, anParameter.maxSize, anParameter.cfg, 1);
    [anParameter.histBinBorderOldSizes anParameter.histBinSizesOldSizes anParameter.histBinMiddleOldSizes] ...
        = getHistBorder(anParameter.divideSize, anParameter.maxSize, anParameter.cfg, 0);
    
    anParameter.ParImageFolder = fullfile('D:\CLACE2014-1s\Particle\',anParameter.ParInfoFiles{fileNr}(1:end-7));
    if ~exist(anParameter.ParImageFolder,'dir'), mkdir(anParameter.ParImageFolder); end
    cd(anParameter.ParImageFolder);
    
    %Predict Class of Particles
    dataAll.pStats = predictClass(dataAll.pStats);
    
    for sizeBin = 2:numel(anParameter.histBinMiddle)
        
        anParameter.ParBinFolder{sizeBin} = fullfile(anParameter.ParImageFolder, ...
            [num2str(sizeBin, '%02u') '-' num2str(round(anParameter.histBinMiddle(sizeBin)), '%03u')]);
        
        
        binIndex = dataAll.pStats.pDiamOldThresh > anParameter.histBinBorder(sizeBin)*1e-6 ...
            & dataAll.pStats.pDiamOldThresh <= anParameter.histBinBorder(sizeBin+1)*1e-6...
            & dataAll.pStats.partIsReal;
        binImages = dataAll.pStats.pImage(binIndex);
        binClass = dataAll.pStats.predictedHClass(binIndex);
        if ~isempty(binImages)
            for cnt = 1:numel(binImages)
                imageAmp = abs(binImages{cnt});
                imageAmp = imageAmp - min(min(imageAmp));
                imageAmp = imageAmp / max(max(imageAmp));
                
                imagePh = angle(binImages{cnt});
                image = [imageAmp imagePh];
                fileName = [char(binClass(cnt)) num2str(cnt, '%04u') '.png'];
                
                if ~exist(anParameter.ParBinFolder{sizeBin},'dir'), mkdir(anParameter.ParBinFolder{sizeBin}); end
                cd(anParameter.ParBinFolder{sizeBin});
                imwrite(image,fileName);
            end
        end
    end
end
