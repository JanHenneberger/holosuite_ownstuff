function [ newholofilenames ] = reduceHololist( holofilenames, framerate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
            holotime.lastFrame = 0;
            newholofilenames = {};
            for cnt = 1:numel(holofilenames)
                holotime.actFrame = getTimeFromFileName(holofilenames{cnt});
                if (holotime.actFrame- holotime.lastFrame)*60*60*24 >= 1/framerate;                    
                    newholofilenames = [newholofilenames holofilenames{cnt}];
                    holotime.lastFrame = holotime.actFrame;
                end
            end

end

