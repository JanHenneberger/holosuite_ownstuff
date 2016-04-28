r_end = (10:10:80)*1e-6;
p = 65600;
T = 240:1:272;
clear t
for cnt = 1:numel(T)
    for cnt2 = 1:numel(r_end)
        display(cnt)
        t(cnt,cnt2) = iceGrowToRadius(r_end(cnt2),p,T(cnt));
    end
end

figure
hold on
for cnt = 1:numel(r_end)
    plot(T,t(:,cnt))
end
legend({'10\mum','20\mum','30\mum','40\mum','50\mum','60\mum','70\mum','80\mum','90\mum','100\mum'},...
    'Location','northeast','FontSize',8)
xlabel('Temperature [K]')
xlim([240 285])
ylabel('growing time [s]')
set(gca,'YScale','log')

text(241,2000,'-25°C: 900s')
text(254,800,'-13°C: 600s')
text(263,2000,'-5°C: 900s')

box on
set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperPosition',[0 0.1 13 9.8]);
set(gcf, 'PaperSize', [13 9.8]);
print(gcf,'-dpdf','-r600', fullfile('IceCrystalGrowTime'));