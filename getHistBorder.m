function [partBorder edgesSize middle]= getHistBorder(divideSize, maxSize, cfg, sizeCorrection)

maxBin = pi/4*(maxSize./1e6)^2./cfg.dx./cfg.dy;
cnt = 1;
while floor(exp(cnt*0.25)) <= maxBin
    numberBin(cnt) = floor(exp(cnt*0.25));
    cnt = cnt+1;
end
numberBin = [5 numberBin];
partBorder = 0.5;
for i = 1:numel(numberBin)
    partBorder(i+1) = partBorder(i)+ numberBin(i);
end
partBorder = (partBorder*cfg.dx*cfg.dy*4/pi).^(1/2)*1000000;
%second change
smallBorder = partBorder(1: find(partBorder>divideSize,1));
bigBorder = logspace(log10(smallBorder(end)),log10(1000),10);
partBorder = [smallBorder bigBorder(2:end)];

%size correction of partBorder
if sizeCorrection
partBorder = correction_diameter(partBorder*1e-6)*1e6;
end

tmp = partBorder;
tmp(1) = [];
%partBorder(end) = [];
edgesSize = tmp - partBorder(1:end-1);
middle = (tmp + partBorder(1:end-1))/2;