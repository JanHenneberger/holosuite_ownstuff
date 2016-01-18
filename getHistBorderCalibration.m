function [partBorder, edgesSize, middle]= getHistBorderCalibration(cfg)

partBorder = (( 0.5 : 99.5)*cfg.dx*cfg.dy*4/pi).^(1/2)*1000000;

tmp = partBorder;
tmp(1) = [];
%partBorder(end) = [];
edgesSize = tmp - partBorder(1:end-1);
middle = (tmp + partBorder(1:end-1))/2;