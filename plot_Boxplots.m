function cntFig = plot_Boxplots(anData, cntFig)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

%%Boxplot all
    cntFig = cntFig+1;

    figure(cntFig)
    clf
    plotGroupBoxplots(anData, anData.oAll);
    if anData.plotTitle
        mtit([anData.campaignName])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = 'All_Boxplot_All';
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end


%%Boxplot wind speed
cntFig = cntFig+1;

    figure(cntFig)
    gcf
    plotGroupBoxplotsWindV(anData, anData.oWindVMeteo, anData.chosenData);
    if anData.plotTitle
        mtit([anData.campaignName ' - all directtions'])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_WindV'];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end


%%Boxplot wind speed only north
cntFig = cntFig+1;
if anData.plotNorthSouth
    figure(cntFig)
    gcf
    anData.chosenWindDirection = 'North wind';
    anData.chosenDataWind = anData.oWindDirection == anData.chosenWindDirection & anData.chosenData;
    
    plotGroupBoxplotsWindV(anData, anData.oWindVMeteo, anData.chosenDataWind);
    if anData.plotTitle
        mtit([anData.campaignName ' - ' anData.chosenWindDirection])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_WindV_' anData.chosenWindDirection];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
end


%%Boxplot wind speed only south
cntFig = cntFig+1;
if anData.plotNorthSouth
    figure(cntFig)
    gcf
    anData.chosenWindDirection = 'South wind';
    anData.chosenDataWind = anData.oWindDirection == anData.chosenWindDirection & anData.chosenData;
    
    plotGroupBoxplotsWindV(anData, anData.oWindVMeteo, anData.chosenDataWind);
    if anData.plotTitle
        mtit([anData.campaignName ' - ' anData.chosenWindDirection])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_WindV_' anData.chosenWindDirection];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
end

%%Boxplot cloud/clear sky
cntFig = cntFig+1;

    figure(cntFig)
    gcf
    chosenData = anData.oIsValid == 'Valid';
    plotGroupBoxplotsWindV(anData, anData.oIsCloud, chosenData);
    if anData.plotTitle
        mtit([anData.campaignName ' - all directions'])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_Cloud'];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
    


%%Boxplot cloud/clear sky only south
cntFig = cntFig+1;
if anData.plotNorthSouth
    figure(cntFig)
    gcf
    anData.chosenWindDirection = 'South wind';
    anData.chosenDataWind = anData.oWindDirection == anData.chosenWindDirection & anData.chosenData;
    
    chosenData = anData.oWindDirection == anData.chosenWindDirection;
    plotGroupBoxplotsWindV(anData, anData.oIsCloud, chosenData);
    if anData.plotTitle
        mtit([anData.campaignName ' - ' anData.chosenWindDirection])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_Cloud_' anData.chosenWindDirection];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
    
end

%%Boxplot cloud/clear sky only north
cntFig = cntFig+1;
if anData.plotNorthSouth
    figure(cntFig)
    gcf
    anData.chosenWindDirection = 'North wind';
    anData.chosenDataWind = anData.oWindDirection == anData.chosenWindDirection & anData.chosenData;
    
    chosenData = anData.oWindDirection == anData.chosenWindDirection;
    plotGroupBoxplotsWindV(anData, anData.oIsCloud, chosenData);
    if anData.plotTitle
        mtit([anData.campaignName ' - ' anData.chosenWindDirection])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_Cloud_' anData.chosenWindDirection];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
    
end

%%Boxplot ice fraction
cntFig = cntFig+1;

    figure(cntFig)
    gcf
    
    chosenData = anData.oIsValid == 'Valid';
    plotGroupBoxplotsChosenD(anData, anData.oIceFraction, chosenData);
    if anData.plotTitle
        mtit([anData.campaignName ' - all directions'])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_IceFraction'];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
    



%%Boxplot ice fraction + north wind
cntFig = cntFig+1;
if  anData.plotNorthSouth
    figure(cntFig)
    gcf
    
    anData.chosenWindDirection = 'North wind';
    anData.chosenDataWind = anData.oWindDirection == anData.chosenWindDirection & anData.chosenData;
    
    chosenData = anData.oWindDirection == anData.chosenWindDirection;
    plotGroupBoxplotsChosenD(anData, anData.oIceFraction, chosenData);
    if anData.plotTitle
        mtit([anData.campaignName ' - ' anData.chosenWindDirection])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_IceFraction_' anData.chosenWindDirection];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
    
end

%%Boxplot ice fraction + South wind
cntFig = cntFig+1;
if anData.plotNorthSouth
    figure(cntFig)
    gcf
    
    anData.chosenWindDirection = 'South wind';
    anData.chosenDataWind = anData.oWindDirection == anData.chosenWindDirection & anData.chosenData;
    
    chosenData = anData.oWindDirection == anData.chosenWindDirection;
    plotGroupBoxplotsChosenD(anData, anData.oIceFraction, chosenData);
    if anData.plotTitle
        mtit([anData.campaignName ' - ' anData.chosenWindDirection])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_IceFraction_' anData.chosenWindDirection];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
    
end

%%Boxplot temperature
cntFig = cntFig+1;

    figure(cntFig)
    gcf
    plotGroupBoxplotsChosenTemp(anData, anData.oTemperature, anData.chosenData);
    if anData.plotTitle
        mtit([anData.campaignName ' - all directions'])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_Temperature'];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end


%%Boxplot temperature + south wind
cntFig = cntFig+1;
if anData.plotNorthSouth
    figure(cntFig)
    gcf
    anData.chosenWindDirection = 'South wind';
    anData.chosenDataWind = anData.oWindDirection == anData.chosenWindDirection & anData.chosenData;
    
    plotGroupBoxplotsChosenTemp(anData, anData.oTemperature, anData.chosenDataWind);
    if anData.plotTitle
        mtit([anData.campaignName ' - ' anData.chosenWindDirection])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_Temperature_' anData.chosenWindDirection];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
end

%%Boxplot temperature + north wind
cntFig = cntFig+1;
if anData.plotNorthSouth
    figure(cntFig)
    gcf
    anData.chosenWindDirection = 'North wind';
    anData.chosenDataWind = anData.oWindDirection == anData.chosenWindDirection & anData.chosenData;
    
    plotGroupBoxplotsChosenTemp(anData, anData.oTemperature, anData.chosenDataWind);
    if anData.plotTitle
        mtit([anData.campaignName ' - ' anData.chosenWindDirection])
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_Temperature_' anData.chosenWindDirection];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
end

%%Boxplot wind direction
cntFig = cntFig+1;

    figure(cntFig)
    gcf
    plotGroupBoxplotsWindD(anData, anData.oWindDirection);
    if anData.plotTitle
        artefact
    end
    set(gcf, 'PaperOrientation','landscape');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-1 -1 31 23]);
    set(gcf, 'PaperSize', [29 21]);
    
    if anData.savePlots
        fileName = ['All_Boxplot_WindDirection'];
        print(gcf,'-dpng','-r600', fullfile(anData.saveDir,fileName));
    end
    


end

