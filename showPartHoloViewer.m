function showPartHoloViewer(data,rootpath, holopath, infopath)

mainTic = tic;
data = load(data);
data.cfg=config('holoviewer.cfg');

%call HoloViewer
cd(holopath)
tmp = data.cfg.current_holo;
data.cfg.path =holopath;
data.cfg.current_holo = tmp;
data.cfg.writefile(fullfile(pwd,'holoviewer2.cfg'));

handles = holoViewer('holoviewer2.cfg');

 for cpar = 1:numel(data.pStats.pDiam);
    temp(1) = data.pStats.xPos(cpar) - data.pStats.xyExtend(cpar)*data.pStats.parameter.factorDisXY/2;
    temp(2) = data.pStats.yPos(cpar) - data.pStats.xyExtend(cpar)*data.pStats.parameter.factorDisXY/2;
    temp(3) = data.pStats.xyExtend(cpar)*data.pStats.parameter.factorDisXY;
    temp(4) = data.pStats.xyExtend(cpar)*data.pStats.parameter.factorDisXY;
    
    if sum(isnan(temp)) == 0;
       temp = temp.*1000000;
       
       if ~data.partIsValid(cpar)
           rectangle('Parent', handles.imagePlot, 'Position', temp, ...
               'EdgeColor', 'w', 'Curvature', [1,1]);
           text(temp(1), temp(2), ...
               num2str(cpar), 'Parent', handles.imagePlot);
           text(temp(1), temp(2)+temp(4), ...
               num2str(data.pStats.zPos(cpar)*1000,'%04.2f'), 'Parent', handles.imagePlot);
           text(temp(1)+temp(3), temp(2), ...
               num2str(data.pStats.pDiam(cpar)*1000000,'%03.0f'), 'Parent', handles.imagePlot);
           text(temp(1)+temp(3), temp(2)+temp(4), ...
               num2str(data.pStats.pEssent(cpar),'%04.3f'), 'Parent', handles.imagePlot);
       elseif data.pStats.partIsBorder(cpar)
           rectangle('Parent', handles.imagePlot, 'Position', temp, ...
               'EdgeColor', 'y', 'Curvature', [1,1]);
           text(temp(1), temp(2), ...
               num2str(cpar), 'Parent', handles.imagePlot);
           text(temp(1), temp(2)+temp(4), ...
               num2str(data.pStats.zPos(cpar)*1000,'%04.2f'), 'Parent', handles.imagePlot);
           text(temp(1)+temp(3), temp(2), ...
               num2str(data.pStats.pDiam(cpar)*1000000,'%03.0f'), 'Parent', handles.imagePlot);
           text(temp(1)+temp(3), temp(2)+temp(4), ...
               num2str(data.pStats.pEssent(cpar),'%04.3f'), 'Parent', handles.imagePlot);
       elseif data.partIsSatelite(cpar)
           rectangle('Parent', handles.imagePlot, 'Position', temp, ...
              'EdgeColor', 'r', 'Curvature', [1,1]);
           text(temp(1), temp(2), ...
               num2str(cpar), 'Parent', handles.imagePlot);
           text(temp(1), temp(2)+temp(4), ...
               num2str(data.pStats.zPos(cpar)*1000,'%04.2f'), 'Parent', handles.imagePlot);
           text(temp(1)+temp(3), temp(2), ...
               num2str(data.pStats.pDiam(cpar)*1000000,'%03.0f'), 'Parent', handles.imagePlot);
           text(temp(1)+temp(3), temp(2)+temp(4), ...
               num2str(data.pStats.pEssent(cpar),'%04.3f'), 'Parent', handles.imagePlot);
       else
           rectangle('Parent', handles.imagePlot, 'Position', temp, ...
               'EdgeColor', 'g', 'Curvature', [1,1]);
           text(temp(1), temp(2), ...
               num2str(cpar), 'Parent', handles.imagePlot);
           text(temp(1), temp(2)+temp(4), ...
               num2str(data.pStats.zPos(cpar)*1000,'%04.2f'), 'Parent', handles.imagePlot);
           text(temp(1)+temp(3), temp(2), ...
               num2str(data.pStats.pDiam(cpar)*1000000,'%03.0f'), 'Parent', handles.imagePlot);
           text(temp(1)+temp(3), temp(2)+temp(4), ...
               num2str(data.pStats.pEssent(cpar),'%04.3f'), 'Parent', handles.imagePlot);
       end       
    end
end

temp(1) = (data.parameter.borderPixel-data.Nx/2)*data.cfg.dx;
temp(2) = (data.parameter.borderPixel-data.Ny/2)*data.cfg.dy;
temp(3) = abs(data.Nx-2*data.parameter.borderPixel)*data.cfg.dx;
temp(4) = abs(data.Ny-2*data.parameter.borderPixel)*data.cfg.dy;
temp = temp.*1000000;
rectangle('Parent', handles.imagePlot, 'Position', temp, ...
           'EdgeColor', 'y');

end