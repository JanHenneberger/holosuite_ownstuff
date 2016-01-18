function [holofilenamesGood BlackList] = findBadHolograms(holofilenamesAll,  numberThreshold)
%reads in as image all files in HOLOFILENAMESALL.
%check in which hologramsmore than NUMBERTHRESHOLD pixels are below the
%BLACKTHRESHOLD or above the WHITETHRESHOLD.
%This indicates ice on windows or double exposure
%returns HOLOFILEMAMESGOOD which are only the good hologams

%holofilenamesAll = dir('*.png');
%holofilenamesAll = {holofilenamesAll.name};
blackThreshold = 0.02;
whiteThreshold = 0.98;


isUnreadable = zeros(numel(holofilenamesAll),1);
numberBlack = zeros(numel(holofilenamesAll),1);
numberWhite = zeros(numel(holofilenamesAll),1);
for cnt = 1:numel(holofilenamesAll)
    try
        holoData = imread(holofilenamesAll{cnt});
        %convert to single if needed
        if strcmp(class(holoData),'uint8'),
            holoData = im2single(holoData);
        end
        numberBlack(cnt) = sum(holoData(:)<=blackThreshold);
        numberWhite(cnt) = sum(holoData(:)>=whiteThreshold);
        isUnreadable(cnt) = 0;
    catch exception, warning('Can''t read %s\n%s', holofilenamesAll{cnt}, exception.message);
        isUnreadable(cnt) = 1;
        numberBlack(cnt) = 0;
        numberWhite(cnt) = 0;
    end
end
isBlack = numberBlack>numberThreshold;
isWhite = numberWhite>numberThreshold;
isBad = isBlack | isWhite | isUnreadable;

holofilenamesGood = holofilenamesAll(~isBad);
holofilenamesBad = holofilenamesAll(isBad);

BlackList.holofilenamesAll = holofilenamesAll;
BlackList.blackThreshold = blackThreshold;
BlackList.whiteThreshold = whiteThreshold;
BlackList.numberThreshold = numberThreshold;
BlackList.numberBlack = numberBlack;
BlackList.numberWhite = numberWhite;
BlackList.isBad = isBad;
BlackList.holofilenamesBad = holofilenamesBad;
BlackList.holofilenamesGood = holofilenamesGood;
save('BlackList.mat', 'BlackList')
% isBlackHand=[0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0];
% isWhiteHand=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
% isBadHand=isBlackHand | isWhiteHand;
% errorBlack = isBlack - isBlackHand;
% errorWhite = isWhite - isWhiteHand;
% errorBad = isBad - isBadHand;
%
% effBlack = sum(abs(errorBlack))
% effWhite = sum(abs(errorWhite))
% effBad = sum(abs(errorBad))
