function plotDependencyOnIntervall2(data, allIntervall, dataLimit)
for cnt = 1:numel(data)
    
    quantileData(1:7,cnt) = quantile(data{cnt},[0.02 0.05 0.25 0.5 0.75 0.95 0.98]);
    quantileData(8,cnt) = nanmean(data{cnt});
end
quantileData(quantileData == 0) = 1e-6;
x = 1:numel(data);
upper = quantileData(7,:);
lower = quantileData(1,:);
fill([x fliplr(x)],[upper fliplr(lower)],[0.9 1 0.9],'LineWidth',.1,'EdgeColor','none')
hold on
upper = quantileData(6,:);
lower = quantileData(2,:);
fill([x fliplr(x)],[upper fliplr(lower)],[0.8 1 0.8],'LineWidth',.1,'EdgeColor','none')
upper = quantileData(5,:);
lower = quantileData(3,:);
fill([x fliplr(x)],[upper fliplr(lower)],[0.5 1 0.5],'LineWidth',.1,'EdgeColor','none')
plot(1:numel(data),quantileData(4,:),'k','LineWidth',2);
plot(1:numel(data),quantileData(8,:),'k--','LineWidth',2);
upper = dataLimit;
lower = ones(1,numel(upper))*1e-6;
fill([x fliplr(x)],[upper fliplr(lower)],[.7 .7 .7],'LineWidth',1,'EdgeColor','k')
set(gca,'XTick',1:numel(data))
for cnt = 1:numel(data)
    tickLabel{cnt} = num2str(allIntervall(cnt));
end

set(gca,'XLim',[1 numel(data)]);%,'YLim',[0 3],'YTick',[0 0.5 1 1.5 2 2.5]);
xlabel('Intervall Duration [s]');
set(gca,'XTickLabel',tickLabel)
box on
end