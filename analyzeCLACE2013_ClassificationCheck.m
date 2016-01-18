
anParameter.lowSize = 6;
anParameter.maxSize = 250;
anParameter.divideSize = 34;

set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);

anParameter.ParInfoFolder = 'F:\CLACE2013\All\ClassFiles';
cd(anParameter.ParInfoFolder);
anParameter.ParInfoFiles = 'ClassificatonTreeNeu.mat';
if ~exist('dataAll', 'var');
    dataAll = load(anParameter.ParInfoFiles);
    dataAll = dataAll.treeFile;
end

choosenData = ~dataAll.pStats.isBorder & dataAll.pStats.isInVolume & ~dataAll.pStats.partIsOnBlackList ...
     & dataAll.pStats.imDiamMean > 6e-6 & dataAll.pStats.imDiamMean <250e-6;
     %& ~dataAll.pStats.isUnkown...
     %& dataAll.pStats.imDiamMean > 23e-6...
X = [dataAll.pStats.minPh(choosenData); dataAll.pStats.maxPh(choosenData); ...
    dataAll.pStats.minAmp(choosenData); dataAll.pStats.maxAmp(choosenData); ...
    dataAll.pStats.imDiamMean(choosenData); dataAll.pStats.imStdAngles(choosenData);...
    dataAll.pStats.imPerimRatio(choosenData); dataAll.pStats.imEccentricity(choosenData);...
    dataAll.pStats.imSolidity(choosenData); dataAll.pStats.imMeanRadii(choosenData);...
    dataAll.pStats.imStdRadii(choosenData); dataAll.pStats.imEquivDiaOldSizes(choosenData);...
    dataAll.pStats.pDiam(choosenData); dataAll.pStats.pDiamOldThresh(choosenData)]';
X2 = [dataAll.pStats.maxPh(choosenData); ...
    dataAll.pStats.maxAmp(choosenData); ...
    dataAll.pStats.imPerimRatio(choosenData); dataAll.pStats.imDiamMean(choosenData); ...
    ]';
% X = [dataAll.pStats.maxPh(choosenData); ...
%     dataAll.pStats.minAmp(choosenData)]';
Y = dataAll.pStats.parClass;
Y = droplevels(Y,'notSpez');
Y = Y(choosenData);
Y = droplevels(Y,'Unknown');

varNames = {'minPh';'maxPh';'minAmp';'maxAmp';'pDiam';'imStdAngles';...
    'imPerimRatio';'imEccentricity';'imSolidity';'imMeanRadii';...
    'imStdRadii';'imEquivDiaOldSizes';'pDiamThresh';'pDiamOldThresh'};
varNames2 = {'maxPh';'maxAmp';' imPerimRatio';'pDiam';};
figure(1)
gplotmatrix(X2,[],Y,[],'o',4,'on','',varNames2,varNames2)
legend(varNames2);
% 
% figure(2)
% %Y = mergelevels(Y, {'Ice','Water'},'Particle');
% ens = fitensemble(X,Y,'AdaBoostM2',10,'Tree');
% plot(resubLoss(ens,'mode','cumulative'));

YArt = mergelevels(Y, {'Ice','Water'},'Particle');
ctreeArt = ClassificationTree.fit(X,YArt,'PredictorNames', varNames,'minleaf',10,...
'AlgorithmForCategorical','PCA');
view(ctreeArt,'mode','graph')
resuberrorArt = resubLoss(ctreeArt)

YIce = droplevels(Y, 'Artefact');
ctreeIce = ClassificationTree.fit(X,YIce,'PredictorNames', varNames,'minleaf',5,...
'AlgorithmForCategorical','PCA');
view(ctreeIce,'mode','graph')
resuberrorIce = resubLoss(ctreeIce)

YArtIce = Y;
ctreeArtIce = ClassificationTree.fit(X,YArtIce,'PredictorNames', varNames,'minleaf',10,...
'AlgorithmForCategorical','PCA');
view(ctreeArtIce,'mode','graph')
resuberrorArtIce = resubLoss(ctreeArtIce)
% figure(2)
% getlevels(Y)
% Y = droplevels(Y,'Unknown');
% Y = mergelevels(Y, {'Ice','Water'},'Particle');
% getlevels(Y)
% svmStruct = svmtrain(X, Y,'Kernel_Function','rbf','showplot','true')




% figure(2)
% subplot(2,2,1)
% boxplot(dataAll.pStats.minPh(choosenData), Y)
% title(varNames{1})
% subplot(2,2,2)
% boxplot(dataAll.pStats.maxPh(choosenData), Y)
% title(varNames{2})
% subplot(2,2,3)
% boxplot(dataAll.pStats.minAmp(choosenData), Y)
% title(varNames{3})
% subplot(2,2,4)
% boxplot(dataAll.pStats.maxAmp(choosenData), Y)
% title(varNames{4})
% anParameter.cfg = config(fullfile(anParameter.ParInfoFolder, 'holoviewer.cfg'));
% [anParameter.histBinBorder anParameter.histBinSizes anParameter.histBinMiddle] ...
%     = getHistBorder(anParameter.divideSize, anParameter.maxSize, anParameter.cfg, 1);
% [anParameter.histBinBorderOldSizes anParameter.histBinSizesOldSizes anParameter.histBinMiddleOldSizes] ...
%     = getHistBorder(anParameter.divideSize, anParameter.maxSize, anParameter.cfg, 0);
% 
% anParameter.ParImageFolder = fullfile('F:\CLACE2013\Particle',anParameter.ParInfoFiles(1:end-7));
% if ~exist(anParameter.ParImageFolder,'dir'), mkdir(anParameter.ParImageFolder); end
% cd(anParameter.ParImageFolder);
% 
% for sizeBin = 2:numel(anParameter.histBinMiddle)
%     
%     anParameter.ParBinFolder{sizeBin} = fullfile(anParameter.ParImageFolder, ...
%         [num2str(sizeBin, '%02u') '-' num2str(round(anParameter.histBinMiddle(sizeBin)), '%03u')]);
%     if ~exist(anParameter.ParBinFolder{sizeBin},'dir'), mkdir(anParameter.ParBinFolder{sizeBin}); end
%     cd(anParameter.ParBinFolder{sizeBin});
%     
%     binIndex = dataAll.pStats.pDiamOldThresh > anParameter.histBinBorder(sizeBin)*1e-6 ...
%         & dataAll.pStats.pDiamOldThresh <= anParameter.histBinBorder(sizeBin+1)*1e-6...
%         & dataAll.pStats.partIsReal;
%     binImages = dataAll.pStats.pImage(binIndex);
%     
%     if ~isempty(binImages)
%         for cnt = 1:numel(binImages)
%             image = abs(binImages{cnt});
%             image = image - min(min(image));
%             image = image / max(max(image));
%             fileName = [num2str(cnt, '%04u') '.png'];
%             imwrite(image,fileName);
%         end
%     end
% end
