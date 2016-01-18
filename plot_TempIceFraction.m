function plot_TempIceFraction(anData,cntFig)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    figure(cntFig)
    gcf
    
    plotColor = lbmap(7,'RedBlue');
    plotColor = colormap(lines(7))
    stat=tabulate(anData.oTemperature(anData.chosenData));
    boxplot(anData.IWContent(anData.chosenData)./anData.TWContent(anData.chosenData)...
        ,anData.oTemperature(anData.chosenData),'labelorientation','inline','outliersize',0.1);
    hold on
    
    meanHOLIMO = grpstats(anData.IWContent(anData.chosenData)./anData.TWContent(anData.chosenData),...
        anData.oTemperature(anData.chosenData),'mean');
    plot([1 2 3 4],meanHOLIMO,'Color',plotColor(1,:),'LineWidth',1.3)
    plot([0 1 2 3 4 5],[0.028 0.026 0.035 0.046 0.04 0.042]./[0.04 0.047 0.065 0.102 0.12 0.142],'Color',plotColor(2,:),'LineWidth',1.3)
    plot([0 1 2 3 4 5],[0.7 0.73 0.63 0.43 0.22 0.27],'Color',plotColor(3,:),'LineWidth',1.3)
    %Vidaurre large T plot([0 1 2 3 4 5],[0.71 0.62 0.68 0.33 0.22 0.20],'Color',plotColor(4,:),'LineWidth',1.3)
    %Bühl plot([0 1 2 3 4 5 ],[1 1 0.93 0.88 0.41 0.25],'Color',plotColor(4,:),'LineWidth',1.3)
    legend({'HOLIMO II';'Korolev et al. (2003)';'Vidaurre and Hallett (2009)'},'Location','NorthEastOutside','FontSize',11)
    
    % xlabel('Temperature')
    ylabel('IWC/TWC')
    if anData.plotTitle
        title([anData.campaignName ' - all directions' ])
    end
    %ylim([-5,105])
    box on
    
    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-.4 -.3 20 12]);
    set(gcf, 'PaperSize', [18.5 11]);
    if anData.savePlots
        fileName = ['All_Temp_IceFraction'];
        print(gcf,'-dpdf','-r600', fullfile(anData.saveDir,fileName));
    end

end

