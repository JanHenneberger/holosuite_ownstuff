clear all
clc
folders = dir('All*')
folders = {folders.name}

for cnt2 = 1:numel(folders)
    cnt2
    cd(folders{cnt2});
    psfilenames = dir('*_ps.mat');
    psfilenames = {psfilenames.name};
    vars = {'xyExtend';'zExtend';'partIsBorder';'partIsSatelite';'pDiam'};
    clear lostVol
    for cnt = 1:numel(psfilenames)
        load(psfilenames{cnt}, vars{:});
        if  isnan(pDiam)
            lostVol(cnt) = nan;
        else
            choose = ~partIsBorder & ~partIsSatelite & pDiam >6e-6 & pDiam <250e-6;
            lostVol(cnt)=sum(pi*(1.2*xyExtend(choose)).^2.*4.*zExtend(choose))./0.25e-6;
        end
        lostVolMean{cnt2}=nanmean(lostVol)*100;
    end
    cd ..
end
