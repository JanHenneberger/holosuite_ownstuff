function plot_ScatterCDPGrouped(anData2013All)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    
    clf
    
    y=anData2013All.ManchCDPConcArrayMean(:,anData2013All.goodInt)';
    y=y(:,4:end);
    y=sum(y,2);
    y=y';
    
    
    x=anData2013All.TWConcentraction2(anData2013All.goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    
    y=x./y;
    plotLimit = 1.05*max(max(x),max(y));
    %plotLimitYMax = 1.05*max(y);
    plotLimitYMin=1/20;
    plotLimitYMax=20;
    xfit = linspace(0,plotLimit);
    
    
    subplot(2,4,1)
    hold on
    edges = [0 12 15 20 30 50];
    labels={'0-12 \mum';'12-15 \mum';'15-20 \mum';'20-30 \mum';'30-50 \mum'};
    Y = anData2013All.ManchCDPMVDMean;
    anData2013All.oCDPDia=ordinal(Y,labels,[],edges);
    anData2013All.oCDPDia = droplevels(anData2013All.oCDPDia);
    group = anData2013All.oCDPDia(anData2013All.goodInt);
    group(nanValues)=[];       
    
    gscatter(x,y,group)
    plot(xfit,xfit,'k--');   
    
    xlim([0, plotLimit]);
    ylim([plotLimitYMin, plotLimitYMax]);
    ylabel('HOLIMO II / CDP (6-50 um)');
    xlabel('HOLIMO II (6-50 um)');
    title('CDP Diameter [\mum]')
    set(gca,'YScale','log');
    box on
    
    subplot(2,4,2)
    hold on
    edges = [0 12 15 20 30 50 250];
    labels={'0-12 \mum';'12-15 \mum';'15-20 \mum';'20-30 \mum';'30-50 \mum'; '50-250 \mum'};
   
    Y = anData2013All.TWMeanD*1e6;
    anData2013All.oHOLIMODia=ordinal(Y,labels,[],edges);
    anData2013All.oHOLIMODia = droplevels(anData2013All.oHOLIMODia);
    group = anData2013All.oHOLIMODia(anData2013All.goodInt);
    group(nanValues)=[];       
    gscatter(x,y,group)
    plot(xfit,xfit,'k--');   
    
    xlim([0, plotLimit]);
    ylim([plotLimitYMin, plotLimitYMax]);
    ylabel('HOLIMO II / CDP (6-50 um)');
    xlabel('HOLIMO II (6-50 um)');
    title('HOLIMO diameter [\mum]')
    set(gca,'YScale','log');
    box on
    
    
    subplot(2,4,3)
    hold on
    edges = [0 1 2 3 6 10 20];
    labels={ '0-1 m/s';'1-2 m/s';'2-4 m/s';'4-6 m/s';'6-10 m/s';'10-20 m/s'};
    Y = anData2013All.measMeanV;
    anData2013All.oWindV=ordinal(Y,labels,[],edges);
    anData2013All.oWindV = droplevels(anData2013All.oWindV);
    group = anData2013All.oWindV(anData2013All.goodInt);
    group(nanValues)=[];       
    gscatter(x,y,group)
    plot(xfit,xfit,'k--');   
    
    xlim([0, plotLimit]);
    ylim([plotLimitYMin, plotLimitYMax]);
    ylabel('HOLIMO II / CDP (6-50 um)');
    xlabel('HOLIMO II (6-50 um)');
    title('Wind speed [ms^{-1}]')
    set(gca,'YScale','log');
    box on
    
    subplot(2,4,4)
    hold on
    edges = [0 1 2 3 6 10 20 40];
    labels={ '0-1°';'1-2°';'2-4°';'4-6°';'6-10°';'10-20°' ;'20-40°'};
    Y = abs(anData2013All.AzimutDiff);
    anData2013All.oDiffAzimut = ordinal(Y,labels,[],edges);
    anData2013All.oDiffAzimut= droplevels(anData2013All.oDiffAzimut);
    group = anData2013All.oDiffAzimut(anData2013All.goodInt);
    group(nanValues)=[];       
    gscatter(x,y,group)
    plot(xfit,xfit,'k--');   
    
    xlim([0, plotLimit]);
    ylim([plotLimitYMin, plotLimitYMax]);
    ylabel('HOLIMO II / CDP (6-50 um)');
    xlabel('HOLIMO II (6-50 um)');
    title('Diff Azimut [°]')
    set(gca,'YScale','log');
    box on
    
    
     subplot(2,4,5)
    hold on
    edges = [-35 -30 -25 -20 -15 -10 -5 0];
    labels={ '-35 to -30°C'; '-30 to -25°C'; '-25 to -20°C'; '-20 to -15°C'; ...
        '-15 to -10°C'; '-10 to -5°C'; '-5 to -0°C'};
    Y = anData2013All.measMeanT;
    anData2013All.oTemperature=ordinal(Y,labels,[],edges);
    anData2013All.oTemperature = droplevels(anData2013All.oTemperature);
    group = anData2013All.oTemperature(anData2013All.goodInt);
    group(nanValues)=[];       
    gscatter(x,y,group)
    plot(xfit,xfit,'k--');   
    
    xlim([0, plotLimit]);
    ylim([plotLimitYMin, plotLimitYMax]);
    ylabel('HOLIMO II / CDP (6-50 um)');
    xlabel('HOLIMO II (6-50 um)');
    title('Temperature [°C]')
    set(gca,'YScale','log');
    box on
    
    subplot(2,4,6)
    hold on
    Y =anData2013All.IWConcentraction./anData2013All.TWConcentraction;
    labels={'<.1 %','0.1 - 1 %','1 - 10 %','10-100 %'};
    edges=([0.00000001 0.001 0.01 0.1 1.00]);
    anData2013All.oIceFractionNumber=ordinal(abs(Y),labels,[],edges);
    anData2013All.oIceFractionNumber = droplevels(anData2013All.oIceFractionNumber);
    group = anData2013All.oIceFractionNumber(anData2013All.goodInt);
    group(nanValues)=[];       
    gscatter(x,y,group)
    plot(xfit,xfit,'k--');   
    
    xlim([0, plotLimit]);
    ylim([plotLimitYMin, plotLimitYMax]);
   ylabel('HOLIMO II / CDP (6-50 um)');
    xlabel('HOLIMO II (6-50 um)');
    title('Ice/Total Conc')
    set(gca,'YScale','log');
    box on
    
    
    subplot(2,4,7)
    hold on
    Y = anData2013All.IWContent./anData2013All.TWContent;
    labels={'0-10 %','10-20 %','20-30 %','30-40 %','40-50 %',...
    '50-60 %','60-70 %','70-80 %','80-90 %','90-100 %'};
    edges=0:0.1:1;
    anData2013All.oIceFraction=ordinal(abs(Y),labels,[],edges);
    anData2013All.oIceFraction = droplevels(anData2013All.oIceFraction);
    group = anData2013All.oIceFraction(anData2013All.goodInt);
    group(nanValues)=[];       
    gscatter(x,y,group)
    plot(xfit,xfit,'k--');   
    
    xlim([0, plotLimit]);
    ylim([plotLimitYMin, plotLimitYMax]);
   ylabel('HOLIMO II / CDP (6-50 um)');
    xlabel('HOLIMO II (6-50 um)');
    title('Ice/Total Content')
    set(gca,'YScale','log');
    box on
    
    subplot(2,4,8)
    hold on
    Y = anData2013All.IWContent;
    labels={'0-0.1','0.1-0.2','0.2-0.4','0.4-0.6','0.6-1.0',...
    '>1.0'};
    edges= [0 0.1 0.2 0.4 0.6 1 10];
    anData2013All.oIWConent=ordinal(abs(Y),labels,[],edges);
    anData2013All.oIWConent = droplevels(anData2013All.oIWConent);
    group = anData2013All.oIWConent(anData2013All.goodInt);
    group(nanValues)=[];       
    plotLimit = 1.05*max(max(x),max(y));
    gscatter(x,y,group)
    plot(xfit,xfit,'k--');   
    
    xlim([0, plotLimit]);
    ylim([plotLimitYMin, plotLimitYMax]);
   ylabel('HOLIMO II / CDP (6-50 um)');
    xlabel('HOLIMO II (6-50 um)');
    title('Ice Content [g m^{-3}]')
    set(gca,'YScale','log');
    box on   

    if anData2013All.savePlots
        fileName = ['Comparision_Scatter_CDP_Grouped' num2str(date,'%02u')];        
        print(gcf,'-dpdf','-r600', fullfile(anData2013All.saveDir,fileName));
    end
end

