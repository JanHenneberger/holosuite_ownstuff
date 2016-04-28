function plot_boxplotCloudPhase(cntFig, anData, cloudPhase)
    figure(cntFig)
    clf
    chosenData = anData.oCloudPhase == cloudPhase  & anData.chosenData;
    plotGroupBoxplotsWindV(anData, anData.oWindDirection, chosenData);
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    nNorth = sum(chosenData & anData.oWindDirection == 'North wind');
    nSouth = sum(chosenData & anData.oWindDirection == 'South wind');
    mtit([cloudPhase ' / South cases: n= ' num2str(nSouth) ' North cases: n= ' num2str(nNorth)]);
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_' cloudPhase];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end


end

