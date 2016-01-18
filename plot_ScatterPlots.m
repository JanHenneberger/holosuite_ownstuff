function plot_ScatterPlots(anData2013All)

   clf
    
    set(gcf,'DefaultLineLineWidth',1.4)
    plotColor = flipud(lbmap(2,'RedBlue'));
    %color1 = anData2013All.ManchCDPMVDMean;
    color1 = anData2013All.meteoWindVel;
    color2 = anData2013All.TWMeanD*1e6;
    
    subplot(2,4,1)
    hold on
    
    xmax = 750;
    ymax = 750;
    xPoints = linspace(1,xmax,100);
    x=anData2013All.ManchCDPConcArrayMean(:,anData2013All.goodInt)';
    x=x(:,4:end);
    x=sum(x,2);
    x=x';
    y=anData2013All.TWConcentraction2(anData2013All.goodInt);
    color = color1(anData2013All.goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    plotLimit = 1.05*max(max(x),max(y));
    
    
    m = y/x;
        xfit = linspace(0,plotLimit);
       
    foo = LinearModel.fit(x',y','y~-1+x1');
    yhat = predict(foo,x');
    
    scatter(x,y,6,color,'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP (6-50 um)');
    ylabel('HOLIMO II (6-50 um)');
    title('Number Concentration [cm^{-3}]')
    box on
    
     subplot(2,4,2)
    hold on
    
    xmax = 750;
    ymax = 750;
    xPoints = linspace(1,xmax,100);
    x=anData2013All.ManchCDPConcArrayMean(:,anData2013All.goodInt)';
    x=x(:,4:end);
    x=sum(x,2);
    x=x';
    y=anData2013All.TWConcentraction2(anData2013All.goodInt);
    color = color2(anData2013All.goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    plotLimit = 1.05*max(max(x),max(y));
    
    
    m = y/x;
        xfit = linspace(0,plotLimit);
       
    foo = LinearModel.fit(x',y','y~-1+x1');
    yhat = predict(foo,x');
    
    scatter(x,y,6,color,'x')
    colorbar('Location','North')
    caxis([5 25])
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP (6-50 um)');
    ylabel('HOLIMO II (6-50 um)');
    title('Number Concentration [cm^{-3}]')
    box on
 
    
    subplot(2,4,3)
    hold on
    
    xmax = 1.2;
    ymax = 1.2;
    xPoints = linspace(1,xmax,100);
    x=anData2013All.cdpMean(anData2013All.goodInt);
    y=anData2013All.TWContent(anData2013All.goodInt);
    color = color1(anData2013All.goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    
    plotLimit = 1.05*max(max(x),max(y));
   
    xfit = linspace(0,plotLimit);
           
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,6,color,'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');  
    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP');
    ylabel('HOLIMO II');
    title('Total Water Content [g m^{-3}]')
    box on
    
    
    subplot(2,4,4)
    hold on
    
    xmax = 1.2;
    ymax = 1.2;
    xPoints = linspace(1,xmax,100);
   
    tmp = repmat(1/6*pi.*(anData2013All.Parameter.ManchCDPBinSizes*1e-3).^3',...
        1,size(anData2013All.ManchCDPConcArrayMean,2));    
    tmp2 = tmp.*anData2013All.ManchCDPConcArrayMean*1e3;
    
    x=nansum(tmp2(4:end,:),1);
    x = x(anData2013All.goodInt);
    y= anData2013All.TWContent2(anData2013All.goodInt);
    color = color1(anData2013All.goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    
    plotLimit = 1.05*max(max(x),max(y));
   
    xfit = linspace(0,plotLimit);
           
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,6,color,'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');  
    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP (6 - 50 \mum)');
    ylabel('HOLIMO II (6 - 50 \mum)');
    title('Total Water Content [g m^{-3}]')
    box on
        
    subplot(2,4,5)
    hold on
    
    xmax = .6;
    ymax = .6;
    xPoints = linspace(1,xmax,100);
    x=anData2013All.pvmMean(anData2013All.goodInt);
    y=anData2013All.TWContent(anData2013All.goodInt);
    color = color1(anData2013All.goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
        xfit = linspace(0,plotLimit);
       
    foo = LinearModel.fit(x',y','y~-1+x1');
   
    scatter(x,y,6,color,'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');      
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('PVM');
    ylabel('HOLIMO II');
    title('Total Water Content [g m^{-3}]')
    box on
    
    
    subplot(2,4,6)
    hold on
    
      xmax = .6;
      ymax = .6;
    x=anData2013All.pvmMean(anData2013All.goodInt)-0.0919;
    y=anData2013All.TWContent(anData2013All.goodInt);
    color = color1(anData2013All.goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    plotLimit = 1.05*max(max(x),max(y));
    
    
   
    xfit = linspace(0,plotLimit);
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,6,color,'x')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');   
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('PVM - Base Line Subtraction');
    ylabel('HOLIMO II');
    title('Total Water Content [g m^{-3}]')
    box on
    
    

    subplot(2,4,7)
    hold on
    
    xmax = 1.2;
    ymax = 1.2;
    xPoints = linspace(1,xmax,100);
    x=anData2013All.cdpMean(anData2013All.goodInt);
    y=anData2013All.pvmMean(anData2013All.goodInt)-0.0919;
    color = color1(anData2013All.goodInt);
    nanValues = isnan(x)|isnan(y)|isinf(x)|isinf(y);
    x(nanValues)=[];
    y(nanValues)=[];
    color(nanValues)=[];
    
    
    plotLimit = 1.05*max(max(x),max(y));
   
    xfit = linspace(0,plotLimit);
           
    foo = LinearModel.fit(x',y','y~-1+x1');
    
    scatter(x,y,6,color,'x')
    colorbar('Location','North')
    plot(xfit, xfit*foo.Coefficients{1,1},'Color',plotColor(2,:))
    plot(xfit,xfit,'k--');  
    
    str1(1) = {'100 s-intervalls'};
    str1(2) = {['fit: ' num2str(foo.Coefficients.Estimate(1),'%4.2g') ...
        '*x (R^2: ' num2str(foo.Rsquared.Adjusted(1),'%4.2g') ')']};
    
    h=legend(str1,'Location','NorthWest');
    set(h,'FontSize',12);
    xlim([0, xmax]);
    ylim([0, ymax]);
    xlabel('CDP');
    ylabel('PVM - Base Line Subtraction');
    title('Total Water Content [g m^{-3}]')
    box on


    
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperPosition',[-.7 -.7 39 20]);
    set(gcf, 'PaperSize', [37 18.7]);
    
    if anData2013All.savePlots
        fileName = ['Comparision_Scatter_Origin_All_New_' num2str(date,'%02u')];        
        print(gcf,'-dpdf','-r600', fullfile(anData2013All.saveDir,fileName));
    end

end

