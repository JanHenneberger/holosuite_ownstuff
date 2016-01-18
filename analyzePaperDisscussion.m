if ~exist('pStats3','var')

msfilenames = dir(['H-*' '*_ms.mat']);
msfilenames = {msfilenames.name};


    for cnt2 = 1:numel(msfilenames)
        cnt2
        
        load(msfilenames{cnt2}, 'outFile');
        if  isfield(outFile, 'pStats') && sum(~isnan(outFile.pStats.zPos))
            pStats = outFile.pStats;
            %Predict Class of Particles
            pStats = predictClass(pStats);
            
            
            %pDiam = nan(1,numel(pImage));
            if ~(numel(pStats.pImage) == 1 && iscell(pStats.pImage{1}))
                for cnt = 1:numel(pStats.pImage)
                    nHolo = pStats.nHolo(cnt);
                    
                    ampLowNew = -8*outFile.ampSTD(nHolo)+outFile.ampMean(nHolo);
                    ampHighNew = Inf*outFile.ampSTD(nHolo)+outFile.ampMean(nHolo);
                    
                    
                    % if ~cellfun(@isempty,pImage{cnt})
                    mask = img.thresholdImage(pStats.pImage{cnt}, ampLowNew, ampHighNew, -3.14, 3.14, @or, 1);
                    if sum(sum(mask))~=0
                        temp     = regionprops(mask,'EquivDiameter','Area','MajorAxisLength','Perimeter');
                        [~, ind] = max([temp.Area]);
                        temp = temp(ind);
                        
                        
                        pStats2.equivDiameter(cnt) = temp.EquivDiameter;
                        pStats2.area(cnt) = temp.Area;
                        pStats2.majorAxisLength(cnt) = temp.MajorAxisLength;
                        pStats2.perimeter(cnt) = temp.Perimeter;
                        
                        pStats2.ar(cnt) = 4*temp.Area/(pi^2*temp.MajorAxisLength^2);
                        pStats2.CStart(cnt) = temp.Area/pStats2.ar(cnt)^(1/2)/temp.Perimeter^2;
                        pStats2.C(cnt) = 10*(0.1-pStats2.CStart(cnt));
                        pStats2.pDiam(cnt)   = max([temp.EquivDiameter]) * sqrt(outFile.dx*outFile.dy)';
                        
                    end
                    %end
                end
            end
            pStats2.predictedHClass = pStats.predictedHClass;
            
            if ~exist('pStats3','var')
                pStats3 = pStats2;
                copyFields = fieldnames(pStats3);
            else
                for cnt3 = 1:numel(copyFields)
                    pStats3.(copyFields{cnt3}) = [pStats3.(copyFields{cnt3}) pStats2.(copyFields{cnt3})];
                end
            end
            clear pStats2
        end
    end
end
class=droplevels(pStats3.predictedHClass,'Artefact');



figure(2)
clf
chosenData = pStats3.C > 0;

data = [pStats3.area; pStats3.majorAxisLength; ...
    pStats3.perimeter; pStats3.ar; pStats3.CStart; pStats3.C];
gplotmatrix(pStats3.equivDiameter(chosenData)',data(:,chosenData)',class(chosenData),...
    'br','x',9,'on','hist','Particle Diameter [\mum]',...
    {'Area';'Major Axis Length'; 'Perimeter'; 'Ar'; 'C*';'C'});

figure(1)
clf



gscatter(pStats3.area,pStats3.C,class)
set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
set(gca, 'YLim', [0 1])
set(gca, 'XLim', [6 250])
xlabel('Particle Diameter [\mum]')
ylabel('Complexity')
box on


