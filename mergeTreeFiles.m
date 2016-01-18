TreeInfoFiles = dir('Tree*_ms.mat');
TreeInfoFiles = {TreeInfoFiles.name};

for cnt = 1:numel(TreeInfoFiles)
    tmp = load(TreeInfoFiles{1});
    tmp = tmp.treeFile;
    if cnt == 1
        dataTree = tmp
    else
        dataTree.X = [dataTree.X; tmp.X];
        dataTree.HX = [dataTree.HX; tmp.HX];
        dataTree.Y = [dataTree.Y tmp.Y];
    end
end

dataTree.Y(dataTree.HX(:,5)<6e-6) = 'Unknown';
dataTree.Y((dataTree.HX(:,5)<19.3e-6)' & dataTree.Y == 'Ice') = 'Artefact';
dataTree.Y = droplevels(dataTree.Y,{'notSpez','Unknown'});
dataTree.classificationTree = ClassificationTree.fit(dataTree.X,dataTree.Y,...
    'PredictorNames', dataTree.varNames,'minleaf',12,...
    'AlgorithmForCategorical','PCA');
%view(dataTree.classificationTree,'mode','graph')

% resubLoss(dataTree.classificationTree);
% cvrtree = crossval(dataTree.classificationTree);
% cvloss = kfoldLoss(cvrtree);
% 
% leafs = linspace(1,20,20);
% N = numel(leafs);
% err = zeros(N,1);
% for n=1:N
%     t = ClassificationTree.fit(dataTree.X,dataTree.Y,...
%     'PredictorNames', dataTree.varNames,'minleaf',leafs(n),...
%     'AlgorithmForCategorical','PCA');
%     err(n) = kfoldLoss(crossval(t));
% end
% plot(leafs,err);
% xlabel('Min Leaf Size');
% ylabel('cross-validated error');
% 
% [~,~,~,bestlevel] = cvLoss(dataTree.classificationTree,...
%     'subtrees','all','treesize','min')
% [~,~,~,bestlevel] = cvLoss(dataTree.classificationTree,...
%     'subtrees','all')
% 
% dataTree.classificationTree = prune(dataTree.classificationTree,'Level',bestlevel);
% %view(dataTree.classificationTree,'mode','graph')




dataTree.classificationHTree = ClassificationTree.fit(dataTree.HX,dataTree.Y,...
    'PredictorNames', dataTree.varHNames,'minleaf',4,...
    'AlgorithmForCategorical','PCA');
view(dataTree.classificationHTree,'mode','graph')

resubLoss(dataTree.classificationHTree)
cvrtree = crossval(dataTree.classificationHTree);
cvloss = kfoldLoss(cvrtree)

leafs = linspace(1,20,20);
N = numel(leafs);
err = zeros(N,1);
for n=1:N
    t = ClassificationTree.fit(dataTree.HX,dataTree.Y,...
    'PredictorNames', dataTree.varHNames,'minleaf',leafs(n),...
    'AlgorithmForCategorical','PCA');
    err(n) = kfoldLoss(crossval(t));
end
figure(2)
plot(leafs,err);
xlabel('Min Leaf Size');
ylabel('cross-validated error');

[~,~,~,bestlevel] = cvLoss(dataTree.classificationHTree,...
    'subtrees','all','treesize','min')
[~,~,~,bestlevel] = cvLoss(dataTree.classificationHTree,...
    'subtrees','all')

dataTree.classificationHTree = prune(dataTree.classificationHTree,'Level',bestlevel);
view(dataTree.classificationHTree,'mode','graph')

dataTree.classificationTree = dataTree.classificationHTree;
treeFile = dataTree;
save('ClassificatonTreeNeu', 'treeFile');