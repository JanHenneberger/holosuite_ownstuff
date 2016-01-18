function  plotSizeSpectraStat( x, data, dataLimit )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    dataLimit(~isfinite(dataLimit)) = nan;
    dataLimit = nanmedian(dataLimit,2)';
    data(~isfinite(data)) = nan;
    quantileData(1:7,:) = quantile(data',[0.02 0.05 0.25 0.5 0.75 0.95 0.98]);    
    quantileData(8,:) = nanmean(data,2);
    quantileData = abs(quantileData);
    quantileData(quantileData == 0) = 1e-4; 
    
    upper = quantileData(7,:);
    lower = quantileData(1,:);
    fill([x fliplr(x)],[upper fliplr(lower)],[0.65 1 0.65],'LineWidth',.1,'EdgeColor','none','FaceAlpha',0.5)
    hold on
    upper = quantileData(6,:);
    lower = quantileData(2,:);
    fill([x fliplr(x)],[upper fliplr(lower)],[.2 1 .2],'LineWidth',.1,'EdgeColor','none')
    upper = quantileData(5,:);
    lower = quantileData(3,:);
    fill([x fliplr(x)],[upper fliplr(lower)],[0 .8 0],'LineWidth',.1,'EdgeColor','none')
    plot(x,quantileData(4,:),'k','LineWidth',1.65);
    plot(x,quantileData(8,:),'k--','LineWidth',1.65);
     upper = dataLimit;
     lower = ones(1,numel(x))*1e-6;
   fill([x fliplr(x)],[upper fliplr(lower)],[.85 .85 .85],'LineWidth',.1,'EdgeColor','none','FaceAlpha',0)
    %plot(x, dataLimit, '-','Color' ,[.85 .85 .85] , 'LineWidth',1.2);
    box on
    xlabel('mean diameter total [\mum]')
    set(gca,'XTick',[10 20 50 100 200])
    set(gca,'XLim',[6 250])
    
    set(gca,'YScale','log')
    set(gca,'XScale','log')
    set(gca, 'Layer','top')
    set(gca,'TickLength',[0.02 0.04],'TickDir','out');
    box on

end

