function [meanData] = meanAzimuth(data, indices)
%MEANAZIMUTH = calculates the mean value of wind direction
% meanData = mean wind direction from the indices values
% data = wind direction [°]
% indices = indices which are used for the mean

        meanroty = nanmean(-cosd(data(indices)));
        meanrotx = nanmean(-sind(data(indices)));
        meanData = conWindXY2Deg(meanrotx, meanroty);
        
end

