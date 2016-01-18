% scatter(pStats.imEquivDia, pStats.rtDp)
% hold on
% parD = (1:250)*1e-6;
% plot(parD, parD)
% set(gca,'YScale','log')
% 
% ;
% ylim([2 250]*1e-6);

%scatterY = [pStats.imEquivDia./pStats.pDiam; pStats.rtDp./pStats.pDiam]';
scatterY = [pStats.rtBSlope; pStats.rtSignal; pStats.rtGoodFit]';
scatterX = [pStats.pDiam]';
grouping = pStats.partIsReal;
[SC, AX, BigAX] = gplotmatrix(scatterX, scatterY, pStats.partIsReal,'gb','o',4);
for cnt = 1:numel(AX)
    xlim(AX(cnt),[5e-06 30e-06]);
    %ylim(AX(cnt),[0 5]);
    set(AX(cnt),'XScale','log');
end
