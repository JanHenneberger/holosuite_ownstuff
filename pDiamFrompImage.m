function pDiam = pDiamFrompImage(pImage, ...
    ampLow, ampHigh, phaseLow, phaseHigh, threshOp, ampMean, ampSTD, dx, dy)

ampLowNew = ampLow*ampSTD+ampMean;
ampHighNew = ampHigh*ampSTD+ampMean;

pDiam = nan(1,numel(pImage));
if ~(numel(pImage) == 1 && iscell(pImage{1}))
    for cnt = 1:numel(pImage)
        % if ~cellfun(@isempty,pImage{cnt})
        mask = img.thresholdImage(pImage{cnt}, ampLowNew, ampHighNew, phaseLow, phaseHigh, threshOp, 1);
        if sum(sum(mask))~=0
            temp    = regionprops(mask,'EquivDiameter');
            pDiam(cnt)   = max([temp.EquivDiameter]) * sqrt(dx*dy)';
        end
        %end
    end
end
