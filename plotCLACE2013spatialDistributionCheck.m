%% Spatial Analysis
figure(1);
clf;

subplot(3,2,1);
hold on;
[a b] = hist(data.xPos(data.partIsReal).*1e3,20);
[c d] = hist(data.xPos(data.partIsRealCor).*1e3,b);
a = a./(sum(a)/numel(a))*100-100;
c = c./(sum(c)/numel(c))*100-100;
e = [a;c]';
 bar(b,c)
% hold on
% bar(b,e)
xlim([-2.18 2.18]);
ylim([-6 6]);
xlabel('X position (mm)');
ylabel('Relative Counts [%]');

subplot(3,2,3);
hold on;
[a b] = hist(data.yPos(data.partIsReal).*1e3,20);
[c d] = hist(data.yPos(data.partIsRealCor).*1e3,b);
a = a./(sum(a)/numel(a))*100-100;
c = c./(sum(c)/numel(c))*100-100;
e = [a;c]';
bar(b,c)
%  hold on
% bar(b,e)
xlim([-1.57 1.57]);
ylim([-6 6]);
xlabel('Y position (mm)');
ylabel('Relative Counts [%]');

subplot(3,2,5);
hold on;
%[a b] = histc(data.zPos(data.partIsReal).*1e3,1:20);
c = histc(data.zPos(data.partIsRealCor).*1e3,1:21);
%a = a./(sum(a)/numel(a))*100-100;
c = c./(sum(c)/(numel(c)-2))*100-100;
%e = [a;c]';
bar(1:19,c(1:19))
% hold on
% bar(b,e)
ylim([-30 30]);
xlabel('Z position (mm)');
ylabel('Relative Counts [%]');

subplot(3,2,[2 4 6]);
bln = .5e-3;
x = data.xPos(data.partIsRealCor);
y = data.yPos(data.partIsRealCor);
xrange = min(x):bln:max(x);
yrange = min(y):bln:max(y);
count = hist2([x;y]',xrange,yrange);
count = count./(sum(count(:))/numel(count)) *100-100;
count = interp2(count,4);
[nx ny] = size(count);
xrange = linspace(min(x),max(x),nx).*1e3;
yrange = linspace(min(y),max(y),ny).*1e3;
%xrange = (xrange(2:end) - bln/2).*1e3; 
%yrange = (yrange(2:end) - bln/2).*1e3;
contourf(yrange,xrange,count);

title('Relative Counts [%]');
xlabel('X position (mm)');
ylabel('Y position (mm)');
caxis([-5 5]);
colorbar
