if ~exist('anData','var');
    %Auswertung für HOLOLAB
    anData = load('F:\HOLOLAB\10_28_ms2\HOLOLAB_60secStat.mat');
    anData = anData.anDataAll;
    
end
anData.Temperature = [-36.8 -36.5 -36.2 -35.8 -35.5 -35.2 -34.9 -34.6 -34.3 ...
    -34.3 -32.3 -32.3 -30.4 -30.4 -28.5 -28.5 -26.3 -26.3 -24.3 -24.3 -22.3 ...
    -22.3 -20.4 -20.4 -18.4 -18.4 -18.4];

anData.isAgI = logical([0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 1 0 1 0 1 1 1 0 1 0 1 1]);

if 1
    folderParImage = 'F:\HOLOLAB\ParticleImagesHand';
    cd(folderParImage);
    folderInt = dir('*.*');
    folderInt = {folderInt.name};
    folderInt(1:2)=[];
    
    categories = {'Aggregation'; 'Ice'; 'Small Ice'; 'Small Water'; 'Water'};
    mat.Cat = repmat(1:numel(categories),numel(folderInt),1);
    mat.Cat = nominal(mat.Cat, categories);
    mat.Cat = mat.Cat(:);
    mat.Temp = repmat(anData.Temperature', 1, numel(categories));
    mat.Temp = mat.Temp(:);
    mat.IsAgI = repmat(anData.isAgI', 1, numel(categories));
    mat.IsAgI = mat.IsAgI(:);
    
    cntFiles = zeros(numel(folderInt), numel(categories));
    
    for cntInt = 1:numel(folderInt)
        cd(folderInt{cntInt});
        for cntCat = 1:numel(categories)
            cd(categories{cntCat})
            cntFiles(cntInt, cntCat) = numel(dir('*.png'));
            cd ..
        end
        cd ..
    end
    anData.cntAggregation = cntFiles(:,1);
    anData.cntIce = cntFiles(:,2);
    anData.cntSmallIce = cntFiles(:,3);
    anData.cntSmallWater = cntFiles(:,4);
    anData.cntWater = cntFiles(:,5);
    anData.cntAllBig = anData.cntAggregation + anData.cntIce + anData.cntWater;
    anData.frozenFraction = anData.cntIce.*100./anData.cntAllBig;
    anData.errorCntIce = sqrt(anData.cntIce);
    anData.errorCntWater = sqrt(anData.cntWater);
    anData.errorCntAllBig = sqrt(anData.cntAllBig);
    anData.errorFrozenFraction = (anData.errorCntIce./anData.cntIce + ...
        anData.errorCntAllBig./anData.cntAllBig) .* anData.frozenFraction;
    mat.counts = cntFiles(:);
end

if 1
    figure(4)
    subplot(2,2,2)   
    
    chosenData = ~anData.isAgI;
    chosenData2 = ~mat.IsAgI;
    
    subplot(2,2,1)
    plot(anData.Temperature(chosenData), anData.cntAllBig(chosenData));
    legend({'Total'});
    xlabel('T [°C]')
    ylabel('n')
    xlim([-38 -18])
    %ylim([0 100])
    box on
    
    subplot(2,2,2)
    chosenDataPlot = chosenData2 & ismember(mat.Cat, {'Water'; 'Ice'; 'Aggregation'});
    gscatter(mat.Temp(chosenDataPlot), mat.counts(chosenDataPlot), mat.Cat(chosenDataPlot));
    xlabel('T [°C]')
    ylabel('n')
    xlim([-38 -18])
    ylim([0 130])
    box on
    
    
    subplot(2,2,3)
    chosenDataPlot = chosenData2 & ismember(mat.Cat, {'Small Ice'; 'Small Water'});
    gscatter(mat.Temp(chosenDataPlot), mat.counts(chosenDataPlot), mat.Cat(chosenDataPlot));
    xlabel('T [°C]')
    ylabel('n')
    xlim([-38 -18])
    ylim([0 70])
    box on
    
    subplot(2,2,4)
    errorbar(anData.Temperature(chosenData), anData.frozenFraction(chosenData), anData.errorFrozenFraction(chosenData),'rx');
    xlabel('T [°C]')
    ylabel('Frozen Fraction [%]')
    xlim([-38 -18])
    ylim([0 100])
    box on
end
if 1
    figure(3)
    chosenData = anData.isAgI | ~anData.isAgI;
    chosenData2 = mat.IsAgI | ~mat.IsAgI;
    
    
    subplot(2,2,1)
    plot(anData.Temperature(chosenData), anData.cntAllBig(chosenData));
    legend({'Total'});
    xlabel('T [°C]')
    ylabel('n')
    xlim([-38 -18])
    %ylim([0 100])
    box on
    

    subplot(2,2,2)
    chosenDataPlot = chosenData2 & ismember(mat.Cat, {'Water'; 'Ice'; 'Aggregation'});
    gscatter(mat.Temp(chosenDataPlot), mat.counts(chosenDataPlot), mat.Cat(chosenDataPlot));
    xlabel('T [°C]')
    ylabel('n')
    xlim([-38 -18])
    ylim([0 130])
    box on
    
    subplot(2,2,3)
    chosenDataPlot = chosenData2 & ismember(mat.Cat, {'Small Ice'; 'Small Water'});
    gscatter(mat.Temp(chosenDataPlot), mat.counts(chosenDataPlot), mat.Cat(chosenDataPlot));
    xlabel('T [°C]')
    ylabel('n')
    xlim([-38 -18])
    ylim([0 70])
    box on
    
    subplot(2,2,4)
    errorbar(anData.Temperature(chosenData), anData.frozenFraction(chosenData), anData.errorFrozenFraction(chosenData),'rx');
    xlabel('T [°C]')
    ylabel('Frozen Fraction [%]')
    xlim([-38 -18])
    ylim([0 100])
    box on
end

if 1
    figure(1)
    scatter(anData.Temperature, anData.LWMeanD*1e6,'rx')
    hold on
    scatter(anData.Temperature, anData.IWMeanD*1e6,'bx')
    legend({'Water'; 'Ice'});
    xlabel('T [°C]')
    ylabel('Diameter [um]')
    xlim([-38 -18])
    ylim([0 200])
    box on
end

