load('Z:\6_Auswertung\ALL\Neusten\HOLIMO_100sec.mat')

LWPSDflip = flipud(outFile.LWPSDnoNorm);
TWPSDflip = flipud(outFile.TWPSDnoNorm);
BinMiddleFlip = fliplr(outFile.BinMiddle);

LWcumsum = cumsum(LWPSDflip);
TWcumsum = cumsum(TWPSDflip);
clear sizeTH idx indexTh
for cnt = 1:size(LWcumsum,2)
    idx = find(LWcumsum(:,cnt)>=3,1,'first');
    if numel(idx)>0  
    indexTh(cnt) = idx;    
    sizeTh(cnt) = BinMiddleFlip(idx);
    else
        indexTh(cnt) = nan;    
        sizeTh(cnt) = nan;
    end
        
end
catIndex = categorical(indexTh);
catSize = categorical(sizeTh);
scatter(sizeTh, outFile.IWConcentration)
boxplot(outFile.IWConcentration,round(sizeTh),'datalim',[0,2])
 ylim([0 2])
 xlabel('Threshold Diamter [\mum] at Liquid Concentration = 3 cm^{-3}')
 ylabel('Ice Number Concentraction [cm^{-3}]')