% for cnt=1:numel(test.psFilenames)
%     cnt
%     psTime = test.psFilenames{cnt}(1:end-7);
%     timeStamp = textscan(psTime, '%u','delimiter','-');
%     timeStamp = double(timeStamp{1}(1:4));
%     timeStamp = timeStamp';
%     dateHoloNum(cnt) = datenum([0 0 0 timeStamp(1:3)]);
%     dateHoloNum(cnt) = dateHoloNum(cnt)+timeStamp(4)/24/60/60/1000;
%     dateHoloVec(:,cnt) = datevec(dateHoloNum(cnt));
%     
%     [dateHoloNum2(cnt), dateHoloVec2(:,cnt)] = getTimeFromFileName(test.psFilenames{cnt});
% end

dateHoloDiff = dateHoloVec2(:,2:end) - dateHoloVec2(:,1:end-1)
dateHoloDiff = datenum(dateHoloDiff')
