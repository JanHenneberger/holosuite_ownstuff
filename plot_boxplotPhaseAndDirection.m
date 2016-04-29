function plot_boxplotPhaseAndDirection(cntFig, anData)
    figure(cntFig)
    clf
    chosenData = anData.chosenData;
    cat = anData.oCloudPhase.*anData.oWindDirection;
    plotGroupBoxplots15(anData, cat, chosenData);
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    [freq name] = summary(cat(chosenData));
    strTitel = [];
    for cnt = 1:numel(freq)
       strTitel = [strTitel name{cnt} ': ' num2str(freq(cnt)) '; '];        
    end
       strTitel(end-1:end) = [];
%     nNorth = sum(chosenData & anData.oWindDirection == 'North wind');
%     nSouth = sum(chosenData & anData.oWindDirection == 'South wind');
%     mtit([cloudPhase ' / South cases: n= ' num2str(nSouth) ' North cases: n= ' num2str(nNorth)]);
mtit(strTitel);
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-2 0 35.1 23]);
    set(gcf, 'PaperSize', [31 22]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_PhaseAndDirection'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end


end

