%%import the _clas files

classFiles = dir('*_class.mat');
classFiles = {classFiles.name};

classData.X = [];
classData.Y = [];

for cnt = 1:numel(classFiles)
    temp1 = load(classFiles{cnt},'temp1');
    try
        classDataIn= temp1.temp1;
    end
    if cnt == 1
        classData.X = classDataIn.X;
        classData.Y = classDataIn.Y;
        classData.prtclIm = classDataIn.prtclIm;
        classData.PredictorNames = classDataIn.PredictorNames;
    else
        %choose only Predictor that exist in every _class file
        [classData.PredictorNames, ia, ib] = ...
            intersect(classData.PredictorNames, classDataIn.PredictorNames);
        
        classData.X = [classData.X(:,ia); classDataIn.X(:,ib)];
        classData.Y = [classData.Y; classDataIn.Y];
        classData.prtclIm = [classData.prtclIm; classDataIn.prtclIm];
    end
end
classData.Y = mergecats(classData.Y,{'Artifact','Unsure','Out_of_focus_Particle'});

%%train classification

cost.ClassNames = categories(classData.Y);
cost.ClassificationCosts = [0 1 1; 1 0 1; 1 1 0]; 

Mdl = fitensemble(classData.X, classData.Y,'AdaBoostM2',100,'Tree',...
   'PredictorNames',classData.PredictorNames,'Cost', cost);
% Mdl = fitensemble(classData.X, classData.Y,'RUSBoost',1000,'Tree',...
%     'PredictorNames',classData.PredictorNames,'LearnRate',0.1);
%%test classification
cvpart = cvpartition(classData.Y,'holdout',0.3);
Xtrain = classData.X(training(cvpart),:);
Ytrain = classData.Y(training(cvpart),:);
Xtest = classData.X(test(cvpart),:);
Ytest = classData.Y(test(cvpart),:);

figure;
plot(loss(Mdl,Xtest,Ytest,'mode','cumulative'));
xlabel('Number of trees');
ylabel('Test classification error');

figure
C = confusionmat(Ytest,Mdl.predict(Xtest));
plotconfusion(Ytest,a);
% cv = fitensemble(classData.X, classData.Y,'AdaBoostM2',100,'Tree',...
%     'type','classification','kfold',5);
% 
% 
% 
% figure;
% plot(loss(Mdl,Xtest,Ytest,'mode','cumulative'));
% hold on;
% plot(kfoldLoss(cv,'mode','cumulative'),'r.');
% hold off;
% xlabel('Number of trees');
% ylabel('Classification error');
% legend('Test','Cross-validation','Location','NE');