
binImages=dataAll.pStats.pImage(find(dataAll.pStats.imPerimRatio <0.95 & dataAll.pStats.pDiam >25e-6))
cnt=3
            imageAmp = abs(binImages{cnt});
            imageAmp = imageAmp - min(min(imageAmp));
            imageAmp = imageAmp / max(max(imageAmp));
            
            imagePh = angle(binImages{cnt});
            colormap('bone')
            subplot(1,2,1)
            imagesc(imageAmp)
            subplot(1,2,2)
            imagesc(imagePh)
