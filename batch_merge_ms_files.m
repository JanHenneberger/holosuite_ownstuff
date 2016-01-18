base_path = 'Z:\5_ParticleStats\CLACE2013-1\';
date = '02-12';
time = '15-56';
sec = '56';
file_start = '301';
file_end = '419';

mergeMsFiles2014([base_path date '-' time],...
    [date],...
    ['H-2013-' date '-' time '-' sec '-HS2-' file_start '-' file_end],...
    [base_path date '-' time])