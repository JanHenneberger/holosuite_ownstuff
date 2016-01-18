
% figure(10)
% gcf
% plot(70:250, 0.049./(70:250)*1e6)
% hold on
% plot(6:0.1:70, 700)
% set(gca,'YScale','log');
% set(gca,'XScale','log');
% ylim([150 800])
% set(gca,'XTick',[2 5 10 20 50 100 200])
% set(gca,'yTick',[2 5 10 20 50 100 200 300 400 500 600 700 800 900 1000])

figure(13)
gcf
dia = (1:0.1:250)*1e-6;
scatter(dia, mD_RelationCotton(dia))
hold on
scatter(dia, 700*pi/6*dia.^3)
scatter(dia, 1000*pi/6*dia.^3)


figure(11)
gcf
ind = outFile.pStats.partIsReal;
scatter(outFile.pStats.imEquivDiaOldSizes(ind),...
    a(ind)./outFile.pStats.imEquivDiaOldSizes(ind))


