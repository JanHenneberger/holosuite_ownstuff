
%% Start up
%new
%1 Number Size Spectra Comparision
anParameter.plotShowNumbSpectrum = 1;
%2 Volume Size Spectra Comparision
anParameter.plotShowVolSpectrum = 1;
%3 Spatial Distribution Check
anParameter.plotShowSpatDist = 0;
anParameter.spatialDisCase = 12;
%4 Correction Check
anParameter.plotCorrectionCheck = 1;
anParameter.correctionCheckCase = 12;

anParameter.lowSize = 6;
anParameter.maxSize = 250;
anParameter.divideSize = 34;

set(0,'DefaultAxesFontSize',15);
set(0,'DefaultAxesLineWidth',2);
anParameter.plotColors = {'k','b','r','g','c','m','y'};
anParameter.plotLineStyle = {'-','--',':','-.'};
anParameter.ParInfoFolder = 'G:\Kalibrierung\ParticleStats';
anParameter.ParInfoFile = {'Beads06um_as.mat', 'Beads10um_as.mat', 'Beads18um_as.mat'};

anParameter.ParInfoFolderSyn = 'D:\HOLIMO_synthetisch\ParticleStats';
anParameter.ParInfoFileSyn = {'PartStats_Syn06um_ps.mat', ...
    'PartStats_Syn10um_ps.mat', 'PartStats_Syn18um_ps.mat'};
anParameter.cfg = config(fullfile(anParameter.ParInfoFolder, 'holoviewer.cfg'));
[anParameter.histBinBorder, anParameter.histBinSizes, anParameter.histBinMiddle] ...
    = getHistBorderCalibration(anParameter.cfg);

if ~exist('dataAll','var')
    for caseH = 1:3
        %Syn Data input
        tmpSyn = load(fullfile(anParameter.ParInfoFolderSyn, anParameter.ParInfoFileSyn{caseH}));
        tmpSyn = tmpSyn.dataParticle;
        
        tmpSyn.sampleSize.x      = (tmpSyn.Nx - tmpSyn.parameter.borderPixel)*tmpSyn.cfg.dx;
        tmpSyn.sampleSize.y      = (tmpSyn.Ny - tmpSyn.parameter.borderPixel)*tmpSyn.cfg.dy;
        tmpSyn.sampleSize.z      = tmpSyn.parameter.lmaxZ - tmpSyn.parameter.lminZ;
        tmpSyn.sampleVolumeHolo  = tmpSyn.sampleSize.x * tmpSyn.sampleSize.y * tmpSyn.sampleSize.z;
        tmpSyn.sampleNumber      = tmpSyn.indHolo(end);
        tmpSyn.sampleVolumeAll   = tmpSyn.sampleVolumeHolo * tmpSyn.sampleNumber;
        
        nanParticleInd = find(isnan(tmpSyn.partIsSatelite));
        tmpSyn.partIsSatelite(nanParticleInd) = 1;
        tmpSyn.partIsBorder(nanParticleInd) = 1;
        
        tmpSyn.partIsReal     = ~tmpSyn.partIsSatelite & ~tmpSyn.partIsBorder;
        tmpSyn.sampleNumberReal = tmpSyn.sampleNumber;
        tmpSyn.sampleVolumeReal   = tmpSyn.sampleVolumeHolo * tmpSyn.sampleNumberReal;
        tmpSyn.realInd = find(tmpSyn.partIsReal);
        
        dataSyn{caseH} = tmpSyn;
        clear tmpSyn
        
        %Holo Data input neu
        tmpHolo = load(fullfile(anParameter.ParInfoFolder, anParameter.ParInfoFile{caseH}));
        tmpHolo = tmpHolo.outFile;
        
        dataAll{caseH} = tmpHolo;
        clear tmpHolo
        
        %Predict Class of Particles
        dataClass.tree = load('ClassificatonTree-Calibration.mat');
        dataClass.tree = dataClass.tree.treeFile;
        
        dataClass.treeX{caseH} = [dataAll{caseH}.pStats.minPh; dataAll{caseH}.pStats.maxPh; ...
            dataAll{caseH}.pStats.minAmp; dataAll{caseH}.pStats.maxAmp; ...
            dataAll{caseH}.pStats.pDiamMean; dataAll{caseH}.pStats.imStdAngles;...
            dataAll{caseH}.pStats.imPerimRatio; dataAll{caseH}.pStats.imEccentricity;...
            dataAll{caseH}.pStats.imSolidity; dataAll{caseH}.pStats.imMeanRadii;...
            dataAll{caseH}.pStats.imStdRadii; dataAll{caseH}.pStats.imEquivDiaOldSizes;...
            dataAll{caseH}.pStats.pDiamOldThresh]';
        dataAll{caseH}.pStats.predictedClass = predict(dataClass.tree.classificationTree, dataClass.treeX{caseH});
        if isfield(dataClass.tree,'classificationTreeShort')
            dataAll{caseH}.pStats.predictedClass = predict(dataClass.tree.classificationTreeShort, dataClass.treeX{caseH});
        end
        
        %dataAll{caseH}.pStats.predictedClass= nominal(dataAll{caseH}.pStats.minAmp,{'Water' 'Artefact'},[],[-inf .75 inf])';
        %summary(dataAll{caseH}.pStats.predictedClass)
                
        dataAll{caseH}.pStats.partIsRealAll = dataAll{caseH}.pStats.isInVolume & ...
            ~dataAll{caseH}.pStats.isBorder & ...
            ~ismember(dataAll{caseH}.pStats.predictedClass,'Artefact')';
        dataAll{caseH}.pStats.partIsReal = dataAll{caseH}.pStats.partIsRealAll & ...
            ~dataAll{caseH}.pStats.partIsOnBlackList;
    end
end

if true
    for cnt = 1:3 
        dataAll{cnt}.pStats.pDiamNew = nanmean([dataAll{cnt}.pStats.pDiamOldSizesOldThresh; dataAll{cnt}.pStats.imEquivDiaOldSizes]);
        %Calculation of Histograms
        [anDataAll{cnt}.histReal, ~, ~, anDataAll{cnt}.limit, anDataAll{cnt}.histRealError] = ...
            histogram(dataAll{cnt}.pStats.pDiamNew(dataAll{cnt}.pStats.partIsReal)*1e6, dataAll{cnt}.sample.VolumeAll, anParameter.histBinBorder);
        anDataAll{cnt}.histRealOldThresh = ...
            histogram(dataAll{cnt}.pStats.pDiamOldSizesOldThresh(dataAll{cnt}.pStats.partIsReal)*1e6, dataAll{cnt}.sample.VolumeAll, anParameter.histBinBorder);
        anDataAll{cnt}.histImReal = ...
            histogram(dataAll{cnt}.pStats.imEquivDiaOldSizes(dataAll{cnt}.pStats.partIsReal)*1e6, dataAll{cnt}.sample.VolumeAll, anParameter.histBinBorder);
        [anDataAll{cnt}.SynhistReal, ~, ~, anDataAll{cnt}.Synlimit, anDataAll{cnt}.SynhistRealError] = ...
            histogram(dataSyn{cnt}.pDiam(dataSyn{cnt}.partIsReal)*1e6, dataSyn{cnt}.sampleVolumeAll, anParameter.histBinBorder);
        anDataAll{cnt}.binMiddle = anParameter.histBinMiddle;
         anDataAll{cnt}.histImMeanRadii = ...
            histogram(2*dataAll{cnt}.pStats.imMeanRadii(dataAll{cnt}.pStats.partIsReal)*1e6, dataAll{cnt}.sample.VolumeAll, anParameter.histBinBorder);
       anDataAll{cnt}.histRtDp = ...
            histogram(dataAll{cnt}.pStats.rtDp(dataAll{cnt}.pStats.partIsReal)*1e6, dataAll{cnt}.sample.VolumeAll, anParameter.histBinBorder);
    end
end
dataOut06umHistReal = [anDataAll{1}.binMiddle; anDataAll{1}.histReal; anDataAll{1}.histReal/max(anDataAll{1}.histReal)]'; 
save('dataOut06umHistReal','dataOut06umHistReal');
dataOut06umHistOldThresh = [anDataAll{1}.binMiddle; anDataAll{1}.histRealOldThresh; anDataAll{1}.histRealOldThresh/max(anDataAll{1}.histRealOldThresh)]';
save('dataOut06umHistOldThresh','dataOut06umHistOldThresh')
dataOut06umHistImReal = [anDataAll{1}.binMiddle; anDataAll{1}.histImReal; anDataAll{1}.histImReal/max(anDataAll{1}.histImReal)]';
save('dataOut06umHistImReal','dataOut06umHistImReal')
dataOut06umHistSyn  = [anDataAll{1}.binMiddle; anDataAll{1}.SynhistReal; anDataAll{1}.SynhistReal/max(anDataAll{1}.SynhistReal)]';
save('dataOut06umHistSyn','dataOut06umHistSyn')
dataOut06umHistImMeanRadii = [anDataAll{1}.binMiddle; anDataAll{1}.histImMeanRadii; anDataAll{1}.histImMeanRadii/max(anDataAll{1}.histImMeanRadii)]';
save('dataOut06umHistImMeanRadii','dataOut06umHistImMeanRadii')
dataOut06umHistRtDp = [anDataAll{1}.binMiddle; anDataAll{1}.histRtDp; anDataAll{1}.histRtDp/max(anDataAll{1}.histRtDp)]';
save('dataOut06umHistRtDp','dataOut06umHistRtDp')

dataOut10umHistReal = [anDataAll{2}.binMiddle; anDataAll{2}.histReal; anDataAll{2}.histReal/max(anDataAll{2}.histReal)]'; 
save('dataOut10umHistReal','dataOut10umHistReal');
dataOut10umHistOldThresh = [anDataAll{2}.binMiddle; anDataAll{2}.histRealOldThresh; anDataAll{2}.histRealOldThresh/max(anDataAll{2}.histRealOldThresh)]';
save('dataOut10umHistOldThresh','dataOut10umHistOldThresh');
dataOut10umHistImReal = [anDataAll{2}.binMiddle; anDataAll{2}.histImReal; anDataAll{2}.histImReal/max(anDataAll{2}.histImReal)]';
save('dataOut10umHistImReal','dataOut10umHistImReal')
dataOut10umHistSyn  = [anDataAll{2}.binMiddle; anDataAll{2}.SynhistReal; anDataAll{2}.SynhistReal/max(anDataAll{2}.SynhistReal)]';
save('dataOut10umHistSyn','dataOut10umHistSyn')
dataOut10umHistImMeanRadii = [anDataAll{2}.binMiddle; anDataAll{2}.histImMeanRadii; anDataAll{2}.histImMeanRadii/max(anDataAll{2}.histImMeanRadii)]';
save('dataOut10umHistImMeanRadii','dataOut10umHistImMeanRadii')
dataOut10umHistRtDp = [anDataAll{2}.binMiddle; anDataAll{2}.histRtDp; anDataAll{2}.histRtDp/max(anDataAll{2}.histRtDp)]';
save('dataOut10umHistRtDp','dataOut10umHistRtDp')

dataOut18umHistReal = [anDataAll{3}.binMiddle; anDataAll{3}.histReal; anDataAll{3}.histReal/max(anDataAll{3}.histReal)]'; 
save('dataOut18umHistReal','dataOut18umHistReal');
dataOut18umHistOldThresh = [anDataAll{3}.binMiddle; anDataAll{3}.histRealOldThresh; anDataAll{3}.histRealOldThresh/max(anDataAll{3}.histRealOldThresh)]';
save('dataOut18umHistOldThresh','dataOut18umHistOldThresh')
dataOut18umHistImReal = [anDataAll{3}.binMiddle; anDataAll{3}.histImReal; anDataAll{3}.histImReal/max(anDataAll{3}.histImReal)]';
save('dataOut18umHistImReal','dataOut18umHistImReal')
dataOut18umHistSyn  = [anDataAll{3}.binMiddle; anDataAll{3}.SynhistReal; anDataAll{3}.SynhistReal/max(anDataAll{3}.SynhistReal)]';
save('dataOut18umHistSyn','dataOut18umHistSyn')
dataOut18umHistImMeanRadii = [anDataAll{3}.binMiddle; anDataAll{3}.histImMeanRadii; anDataAll{3}.histImMeanRadii/max(anDataAll{3}.histImMeanRadii)]';
save('dataOut18umHistImMeanRadii','dataOut18umHistImMeanRadii')
dataOut18umHistRtDp = [anDataAll{3}.binMiddle; anDataAll{3}.histRtDp; anDataAll{3}.histRtDp/max(anDataAll{3}.histRtDp)]';
save('dataOut18umHistRtDp','dataOut18umHistRtDp')


%% Number Size Spectra Comparision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 01
if anParameter.plotShowNumbSpectrum
    figure(1)
    clf    
    
    for cnt = 1:numel(anDataAll)
        plot(anParameter.histBinMiddle, anDataAll{cnt}.histReal/max(anDataAll{cnt}.histReal), ...
            ['-'...
            anParameter.plotColors{cnt}],...
            'LineWidth',2);
        hold on
        plot(anParameter.histBinMiddle, anDataAll{cnt}.histRealOldThresh/max(anDataAll{cnt}.histRealOldThresh), ...
            ['-.'...
            anParameter.plotColors{cnt}],...
            'LineWidth',2);
%         anParameter.histBinMiddleOldSizes, anDataAll{cnt}.histRealCorOldSizes, ...
%         ['--' anParameter.plotColors(rem(cnt,numel(anParameter.plotColors)))],...
%         hold on
%         plot(anParameter.histBinMiddle, anDataAll{cnt}.SynhistReal/max(anDataAll{cnt}.SynhistReal), ...
%             ['--'...
%             anParameter.plotColors{cnt}],...
%             'LineWidth',2);
%         hold on
        plot(anParameter.histBinMiddle, anDataAll{cnt}.histImReal/max(anDataAll{cnt}.histImReal), ...
            [':'...
            anParameter.plotColors{cnt}],...
            'LineWidth',2);
        plot(anParameter.histBinMiddle, anDataAll{cnt}.histRtDp/max(anDataAll{cnt}.histRtDp), ...
            [':'...
            anParameter.plotColors{cnt}],...
            'LineWidth',2);
    end
    
        %Beads
        line([6.4 6.4],[0.001 1],'LineStyle','-','LineWidth',2,'Color','k');
        line([10.25 10.25],[0.001 1],'LineStyle','-','LineWidth',2,'Color','b');
        line([18.23 18.23],[0.001 1],'LineStyle','-','LineWidth',2,'Color','r');

    
    
    h_legend = legend({'Mean','OldTh','Image','rtDp'});
    %set(h_legend,'FontSize',9);
    ylabel('number density d(N)/d(log d) [cm^{-3}\mum^{-1}]');
    xlabel('diameter [\mum]')
    xlim([3 30]);
    %ylim([3e-7 1e2]);
    %set(gca,'YScale','log');
    set(gca,'XScale','log');
    
    set(gcf, 'Units', 'normalized');
    set(gcf, 'OuterPosition', [0 0.3 1.15 0.7])
end
%
% %% Volume Size Spectra Comparision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 02
% if anParameter.plotShowVolSpectrum
% figure(2)
% clf;
%
% legendString = ['legend('];
% for cnt = 1:numel(anDataAll)
%     plot(anParameter.histBinMiddle, anDataAll{cnt}.histRealCor.*(1/6*pi.*anParameter.histBinMiddle.^3), ...
%         [anParameter.plotLineStyle{ceil(cnt/numel(anParameter.plotColors))}...
%         anParameter.plotColors{rem(cnt,numel(anParameter.plotColors))+1}],...
%         'LineWidth',2);
%     %anParameter.histBinMiddleOldSizes, anDataAll{cnt}.histRealCorOldSizes, ...
%     %['--' anParameter.plotColors(rem(cnt,numel(anParameter.plotColors)))],...
%     hold on
%     legendString = [legendString '''' ...
%         num2str(cnt,'%02u')...
%         ': ' anDataAll{cnt}.timeString ''','];
% end
% legendString = ['h_legend=' legendString(1:end-1) ', ''Location'', ''EastOutside'');'];
% eval(legendString);
% set(h_legend,'FontSize',9);
%
% ylabel('volume density d(V)/d(log d) [cm^{-3}\mum^{-1}\mum^{3}]');
% xlabel('diameter [\mum]')
% xlim([6 anParameter.maxSize]);
% ylim([1e-2 1e6]);
% set(gca,'YScale','log');
% set(gca,'XScale','log');
%
% set(gcf, 'Units', 'normalized');
% set(gcf, 'OuterPosition', [0 0 0.7 0.7])
% end
%
% %% Spatial Distribution Check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 03
% if anParameter.plotShowSpatDist
% figure(3);
% clf;
%
% cnt = anParameter.spatialDisCase;
% subplot(3,2,1);
% hold on;
% [a b] = hist(dataAll{cnt}.xPos(dataAll{cnt}.partIsReal).*1e3,30);
% a = a./(sum(a)/numel(a))-1;
% bar(b,a)
%
% xlim([-2.2 2.2]);
% ylim([-.2 .2]);
% title('Y position frequency');
% xlabel('Y Position (mm)');
% ylabel('Relative Count');
%
% subplot(3,2,3);
% hold on;
% [a b] = hist(dataAll{cnt}.yPos(dataAll{cnt}.partIsReal).*1e3,30);
% a = a./(sum(a)/numel(a))-1;
% bar(b,a)
% xlim([-1.8 1.8]);
% ylim([-.2 .2]);
% title('X position frequency');
% xlabel('X Position (mm)');
% ylabel('Relative Count');
%
% subplot(3,2,5);
% hold on;
% [a b] = hist(dataAll{cnt}.zPos(dataAll{cnt}.partIsReal).*1e3,30);
% a = a./(sum(a)/numel(a))-1;
% bar(b,a)
% ylim([-.6 .6]);
% title('Z position frequency');
% xlabel('Z Position (mm)');
% ylabel('Relative Count');
%
% subplot(3,2,[2 4 6]);
% bln = .1e-3;
% x = dataAll{cnt}.xPos(dataAll{cnt}.partIsReal);
% y = dataAll{cnt}.yPos(dataAll{cnt}.partIsReal);
% xrange = min(x):bln:max(x);
% yrange = min(y):bln:max(y);
% count = hist2([x;y]',xrange,yrange);
% count = count./(sum(count(:))/numel(count)) - 1;
% count = interp2(count,4);
% [nx ny] = size(count);
% xrange = linspace(min(x),max(x),nx).*1e3;
% yrange = linspace(min(y),max(y),ny).*1e3;
% %xrange = (xrange(2:end) - bln/2).*1e3;
% %yrange = (yrange(2:end) - bln/2).*1e3;
% contourf(yrange,xrange,count);
%
% title('Relative Frequency of Occurance');
% xlabel('X position (mm)');
% ylabel('Y position (mm)');
% caxis([-.5 .5]);
%
% mtit([num2str(cnt,'%02u')  ': ' anDataAll{cnt}.timeString ''','], 'xoff' , -.2, 'yoff' , +.02);
% set(gcf, 'Units', 'normalized');
% set(gcf, 'OuterPosition', [.6 .3 0.7 0.7])
% end
%
% %% Number Size Spectra Comparision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 01
% if anParameter.plotCorrectionCheck
% figure(4)
% clf
%
% plot(anParameter.histBinMiddleOldSizes, anDataAll{anParameter.correctionCheckCase}.histRealCorOldSizes, ...
%         anParameter.histBinMiddle, anDataAll{anParameter.correctionCheckCase}.histReal, ...
%         anParameter.histBinMiddle, anDataAll{anParameter.correctionCheckCase}.histRealCor, ...
%         'LineWidth',2);
%
% legend('Sizes uncorrected', 'Efficiency uncorrected', 'Corrected');
% title([num2str(cnt,'%02u')  ': ' anDataAll{anParameter.correctionCheckCase}.timeString ''',']);
% ylabel('number density d(N)/d(log d) [cm^{-3}\mum^{-1}]');
% xlabel('diameter [\mum]')
% xlim([6 anParameter.maxSize]);
% ylim([3e-7 1e2]);
% set(gca,'YScale','log');
% set(gca,'XScale','log');
%
% set(gcf, 'Units', 'normalized');
% set(gcf, 'OuterPosition', [.9 0 .5 0.5])
% end
