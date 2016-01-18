figure(1)
gcf
x=1:1648;
y=1:1236;
[X,Y]=meshgrid(x,y);
Z=78+67.*exp(-0.5.*((X-876)./661).^2-0.5.*((Y-624)./727).^2);

mesh(X,Y,Z/mean(mean(Z))*100)
axis tight

xlabel('X position [Pixel]');
ylabel('Y position [Pixel]');
zlabel('Relative intensity [%]');
%zlim([0 255]);
% gcf
% b=a.raw_image;
%  contourf(b/mean(mean(b)));
% %     bln = .5e-3;
% %     x = anDataAll.xPos{cnt}(choosenParticle);
% %     y = anDataAll.yPos{cnt}(choosenParticle);
% %     x(isnan(x))=0;
% %     y(isnan(y))=0;
% %     xrange = min(x):bln:max(x);
% %     yrange = min(y):bln:max(y);
% %     z = [x; y]';
% %     count = hist2([x;y]',xrange,yrange);
% %     count = count./(sum(count(:))/numel(count)) *100-100;
% %     count = interp2(count,4);
% %     [nx, ny] = size(count);
% %     xrange = linspace(min(x),max(x),nx).*1e3;
% %     yrange = linspace(min(y),max(y),ny).*1e3;
% %     %xrange = (xrange(2:end) - bln/2).*1e3;
% %     %yrange = (yrange(2:end) - bln/2).*1e3;
% %     contourf(yrange,xrange,count);
%     
%     title('Relative Counts [%]');
%     xlabel('X position (mm)');
%     ylabel('Y position (mm)');
%     caxis([-5 5]);
%     colorbar
%     box on