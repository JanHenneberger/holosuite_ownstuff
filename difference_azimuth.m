function diff_dir = difference_azimuth(dir1, dir2)

caseA = (dir1 - dir2)< -180;
caseB = (dir1 - dir2)> 180;
caseNormal = ~(caseA | caseB);

diff_dir_Normal = dir1 - dir2;
diff_dir_A = (dir1 - dir2 + 360);
diff_dir_B = (dir1 - dir2 - 360);

diff_dir = diff_dir_Normal.*caseNormal + diff_dir_A.*caseA + diff_dir_B.*caseB;
