function diameterCorr = correction_diameter(diameterUnCor)
%diameterCorr = diameterUnCor-9.1*exp(-diameterUnCor*1e6/5.03)*1e-6;
tmp = diameterUnCor(diameterUnCor <12.11*1e-6);
diameterCorr = diameterUnCor;
diameterCorr(diameterUnCor <12.11*1e-6) = 01.54*tmp-6.54*1.e-6;