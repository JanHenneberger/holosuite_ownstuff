function cntFig = plot_IceWind(anData, cntFig)

[a, b] = summary(anData.oDay)
statarray = grpstats(anData.IWConcentraction(anData.chosenData),anData.oDay(anData.chosenData),'mean') ;
icethreshold = 0.05;

for cnt = 1:numel(a)
    if statarray(cnt) > icethreshold
        cntFig = cntFig+1;
        figure(cntFig)
        clf
        
        chosenInd = anData.oDay == b{cnt} & anData.chosenData;
        x = anData.meteoWindVel(chosenInd);
        y = anData.IWConcentraction(chosenInd);
        
        scatter(x, y)
        hold on
        p = polyfit(x,y,1);
        xfit = linspace(min(x), max(x),100);
        yfit =  p(1) * xfit + p(2);
        plot(xfit, yfit);
        
        box on
        
        xlabel('Wind speed [ms^{-1}]');
        ylabel('Ice particle concentration [cm^{-3}]')
        title(b{cnt})
        
        set(gcf, 'PaperUnits','centimeters');
        set(gcf, 'PaperPosition',[0 0.1 9.8 9.8]);
        set(gcf, 'PaperSize', [9.8 9.8]);
        
        if anData.savePlots
            fileName = ['Case_' b{cnt} 'WindIceConc'];
            print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
        end
        
    end
end
end

