% clear all
% cd('Z:\1_Raw_Images\2014_CLACE2014')
% tmp = dir('*2014*');
% folder_dates = {tmp.name};
% mi_cnt = 1;
% for cnt = 1:numel(folder_dates)
%     disp(folder_dates{cnt});
%     cd(folder_dates{cnt});
%     tmp = dir('*');
%     folder_times = {tmp.name};
%     
%     for cnt2 = 3:numel(folder_times)
%         disp(folder_times{cnt2});
%         cd(folder_times{cnt2});
%         tmp = dir('*');
%         folder_number = {tmp.name};
%         
%         
%         cd(folder_number{3})
%         tmp = dir('*.png');
%         file_first = tmp(1).name;
%         [time_first_num, time_first_vec] = getTimeFromFileName(file_first);
%         
%         mi.size_first_mean(mi_cnt) = nanmean([tmp.bytes]);
%         mi.size_first_std(mi_cnt) = nanstd([tmp.bytes]);
%         for cnt3 = 1:numel({tmp.name});
%             img = imread(tmp(cnt3).name);
%             img_mean(cnt3) = nanmean(img(:));
%             img_std(cnt3) = nanstd(double(img(:)));
%         end
%         mi.img_first_mean_mean(mi_cnt) = nanmean(img_mean);
%         mi.img_first_mean_std(mi_cnt) = nanstd(img_mean);
%         mi.img_first_std_mean(mi_cnt) = nanmean(img_std);
%         mi.img_first_std_std(mi_cnt) = nanstd(img_std);
%         cd ..
%         
%         cd(folder_number{end})
%         tmp = dir('*.png');
%         file_last = tmp(end).name;
%         [time_last_num, time_last_vec] = getTimeFromFileName(file_last);
%         
%         mi.size_last_mean(mi_cnt) = nanmean([tmp.bytes]);
%         mi.size_last_std(mi_cnt) = nanstd([tmp.bytes]);
%         for cnt3 = 1:numel({tmp.name});
%             try
%                 img = imread(tmp(cnt3).name);
%             catch
%                 
%             end
%             img_mean(cnt3) = nanmean(img(:));
%             img_std(cnt3) = nanstd(double(img(:)));
%         end
%         mi.img_last_mean_mean(mi_cnt) = nanmean(img_mean);
%         mi.img_last_mean_std(mi_cnt) = nanstd(img_mean);
%         mi.img_last_std_mean(mi_cnt) = nanmean(img_std);
%         mi.img_last_std_std(mi_cnt) = nanstd(img_std);
%         
%         mi.timeStart(mi_cnt,:) = time_first_vec;
%         mi.timeEnd(mi_cnt,:) = time_last_vec;
%         mi.duration(mi_cnt) = etime(time_last_vec,time_first_vec);
%         mi.fileNumber(mi_cnt) = 1000*(numel(folder_number)-2);
%         mi.frameSpeed(mi_cnt) = mi.fileNumber(mi_cnt)/mi.duration(mi_cnt);
%         
%         cd ..
%         cd ..
%         
%         mi_cnt = mi_cnt+1;
%     end
%     cd ..
% end
% 
% 
% mi_Table = table(mat2cell(datestr(mi.timeStart),ones(1,64)), ...
%     mat2cell(datestr(mi.timeEnd),ones(1,64)), ...
%     mi.duration', mi.fileNumber', mi.frameSpeed',...
%     'VariableNames',{'StartDate' 'EndDate' 'Duration' ...
%     'FileNumbere' 'FramesSpeed'});
% 
mi_both = [mi.size_first_mean mi.size_last_mean; ...
    mi.size_first_std mi.size_last_std; ...
    mi.img_first_mean_mean mi.img_last_mean_mean; ...
    mi.img_first_mean_std mi.img_last_mean_std; ...
    mi.img_first_std_mean mi.img_last_std_mean; ...
    mi.img_first_std_std mi.img_last_std_std];

figure(1)
clf
plotmatrix(mi_both')

figure(2)
clf
scatter(datenum(mi.timeStart), mi.size_first_mean)
hold on
scatter(datenum(mi.timeEnd), mi.size_last_mean,'g')

figure(3)
clf
scatter(datenum(mi.timeStart), mi.img_first_std_mean)
hold on
scatter(datenum(mi.timeEnd), mi.img_last_std_mean,'g')