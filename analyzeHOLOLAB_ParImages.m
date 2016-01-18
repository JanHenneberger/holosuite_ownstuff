%start after analyzeHOLOLAB_2014

anParameter.lowSize = 6;
anParameter.maxSize = 250;
anParameter.divideSize = 34;

set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);

%save Particle Images seperated per interval
if 0 
    anParameter.ParImageFolder = 'F:\HOLOLAB\Particle Images';
    if ~exist(anParameter.ParImageFolder,'dir'), mkdir(anParameter.ParImageFolder); end
    cd(anParameter.ParImageFolder);
    
    %Get Class Lables (Ice, Water, ...)
    classLabels = getlabels(dataAll.pStats.predictedHClass);
    
    for intervall = 1:max(dataAll.intervall)
        anParameter.ParBinFolder{cnt} = fullfile(anParameter.ParImageFolder,...
            num2str(intervall, '%02u'));
        if ~exist(anParameter.ParBinFolder{cnt},'dir'), mkdir(anParameter.ParBinFolder{cnt}); end
        cd(anParameter.ParBinFolder{cnt});
        
        for cnt = 1:numel(classLabels)
            if ~strcmp(classLabels{cnt}, 'Artefact')
                
                if ~exist(classLabels{cnt},'dir'), mkdir(classLabels{cnt}); end
                cd(classLabels{cnt});
                
                binIndex = dataAll.pStats.predictedHClass == classLabels{cnt} & ...
                    dataAll.pStats.partIsReal & dataAll.intervall == intervall;
                binImages = dataAll.pStats.pImage(binIndex);
                binIntervall = dataAll.intervall(binIndex);
                padDiam = dataAll.pStats.pDiamOldSizesOldThresh(binIndex);
                if ~isempty(binImages)
                    for cnt2 = 1:numel(binImages)
                        imageAmp = abs(binImages{cnt2});
                        imageAmp = imageAmp - min(min(imageAmp));
                        imageAmp = imageAmp / max(max(imageAmp));
                        
                        imagePh = angle(binImages{cnt2});
                        image = [imageAmp imagePh];
                        fileName = [classLabels{cnt} '_'  num2str(padDiam(cnt2)*1e6, '%03.0f') '_' num2str(binIntervall(cnt2)) '_' num2str(cnt2) '.png'];
                        imwrite(image,fileName);
                    end
                end
                cd ..
            end
        end
    end
end


%save Particle Images all intervall in ones
if 0 
    anParameter.ParImageFolder = 'F:\HOLOLAB\Particle Images2';
    if ~exist(anParameter.ParImageFolder,'dir'), mkdir(anParameter.ParImageFolder); end
    cd(anParameter.ParImageFolder);
    
    %Get Class Lables (Ice, Water, ...)
    classLabels = getlabels(dataAll.pStats.predictedHClass);
    
    %for intervall = 1:max(dataAll.intervall)
        %anParameter.ParBinFolder{cnt} = fullfile(anParameter.ParImageFolder, ...
        %    num2str(intervall, '%02u');
        %if ~exist(anParameter.ParBinFolder{cnt},'dir'), mkdir(anParameter.ParBinFolder{cnt}); end
        %cd(anParameter.ParBinFolder{cnt});
        
        for cnt = 1:numel(classLabels)
            if ~strcmp(classLabels{cnt}, 'Artefact')
                
                if ~exist(classLabels{cnt},'dir'), mkdir(classLabels{cnt}); end
                cd(classLabels{cnt});
                
                binIndex = dataAll.pStats.predictedHClass == classLabels{cnt} & dataAll.pStats.partIsReal;
                binImages = dataAll.pStats.pImage(binIndex);
                binIntervall = dataAll.intervall(binIndex);
                padDiam = dataAll.pStats.pDiamOldSizesOldThresh(binIndex);
                if ~isempty(binImages)
                    for cnt2 = 1:numel(binImages)
                        imageAmp = abs(binImages{cnt2});
                        imageAmp = imageAmp - min(min(imageAmp));
                        imageAmp = imageAmp / max(max(imageAmp));
                        
                        imagePh = angle(binImages{cnt2});
                        image = [imageAmp imagePh];
                        fileName = [classLabels{cnt} '_'  num2str(padDiam(cnt2)*1e6, '%03.0f') '_' num2str(binIntervall(cnt2)) '_' num2str(cnt2) '.png'];
                        imwrite(image,fileName);
                    end
                end
                cd ..
            end
        end
    %end
end

if 1
    figure(4)
    bins = (65:2.5:250)*1e-6;
    
    chosenData = ~ismember(dataAll.pStats.predictedHClass,'Artefact');
    histAll = histc(dataAll.pStats.pDiamOldSizesOldThresh(chosenData),bins);
    
    
    chosenData = ismember(dataAll.pStats.predictedHClass,'Water') | ismember(dataAll.pStats.predictedHClass,'Small Water');
    histWater = histc(dataAll.pStats.pDiamOldSizesOldThresh(chosenData),bins);
    %histWaterS = sgolayfilt(histWater,7,21);
    chosenData = ismember(dataAll.pStats.predictedHClass,'Ice') | ismember(dataAll.pStats.predictedHClass,'Small Ice') | ismember(dataAll.pStats.predictedHClass,'Aggregation');
    
    histIce = histc(dataAll.pStats.pDiamOldSizesOldThresh(chosenData),bins);
    %histIceS = sgolayfilt(histIce,7,21);
%     chosenData = ismember(dataAll.pStats.predictedHClass,'Aggregation');
%     histAggregation = histc(dataAll.pStats.pDiamOldSizesOldThresh(chosenData),bins);
    
    plot(bins, histWater, bins, histIce)
    legend({'Water'; 'Ice'; 'Aggregation'});
    %set(gca,'YScale','log');
    %set(gca,'XScale','log');
    xlim([65 160]*1e-6)
     ylim([0 180])
     xlabel('diameter [m]')
     ylabel('frequency')

    %diameter one droplet
    d1 = mean(dataAll.pStats.pDiamOldSizesOldThresh(ismember(dataAll.pStats.predictedHClass,'Water')...
        & dataAll.pStats.pDiamOldSizesOldThresh < 104e-6));
    upperB = max(histWater)*1.3;
    line([d1 d1],[0 upperB]);
    line([nthroot(2,3)*d1 nthroot(2,3)*d1],[0 upperB]);
    line([nthroot(3,3)*d1 nthroot(3,3)*d1],[0 upperB]);
end

%spatial distribution check
if 0
    %% Spatial Distribution Check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 03
   
    theta = -21;

    dataAll.pStats.xPosN= cos(theta)*dataAll.pStats.xPos-sin(theta)*dataAll.pStats.yPos;
    dataAll.pStats.yPosN= sin(theta)*dataAll.pStats.xPos+cos(theta)*dataAll.pStats.yPos;
    
    chosenData = dataAll.pStats.partIsReal & dataAll.pStats.pDiam > 40e-6;
    
    figure(1);
    clf;
    

    subplot(3,2,1);
    hold on;
    [a b] = hist(dataAll.pStats.xPosN().*1e3,30);
    a = a./(sum(a)/numel(a))-1;
    bar(b,a)
    
    xlim([-2.2 2.2]);
    %ylim([-.2 .2]);
    title('Y position frequency');
    xlabel('Y Position (mm)');
    ylabel('Relative Count');
    
    subplot(3,2,3);
    hold on;
    [a, b] = hist(dataAll.pStats.yPosN(chosenData).*1e3,30);
    a = a./(sum(a)/numel(a))-1;
    bar(b,a)
    xlim([-1.8 1.8]);
    %ylim([-.2 .2]);
    title('X position frequency');
    xlabel('X Position (mm)');
    ylabel('Relative Count');
    
    subplot(3,2,5);
    hold on;
    [a, b] = hist(dataAll.pStats.zPos(chosenData).*1e3,30);
    a = a./(sum(a)/numel(a))-1;
    bar(b,a)
    %ylim([-.6 .6]);
    title('Z position frequency');
    xlabel('Z Position (mm)');
    ylabel('Relative Count');
    
    subplot(3,2,[2 4 6]);
    bln = .5e-3;
    x = dataAll.pStats.xPosN(chosenData);
    y = dataAll.pStats.yPosN(chosenData);
    xrange = min(x):bln:max(x);
    yrange = min(y):bln:max(y);
    count = hist2([x;y]',xrange,yrange);
    count = count./(sum(count(:))/numel(count)) - 1;
    count = interp2(count,4);
    [nx, ny] = size(count);
    xrange = linspace(min(x),max(x),nx).*1e3;
    yrange = linspace(min(y),max(y),ny).*1e3;
    %xrange = (xrange(2:end) - bln/2).*1e3;
    %yrange = (yrange(2:end) - bln/2).*1e3;
    contourf(yrange,xrange,count);
    
    title('Relative Frequency of Occurance');
    xlabel('X position (mm)');
    ylabel('Y position (mm)');
    %caxis([-.5 .5]);
    
    mtit([num2str(cnt,'%02u')  ': ' dataAll.pStats.timeString ''','], 'xoff' , -.2, 'yoff' , +.02);
    set(gcf, 'Units', 'normalized');
    set(gcf, 'OuterPosition', [.6 .3 0.7 0.7])
end
