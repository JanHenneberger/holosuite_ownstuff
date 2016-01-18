clc
clf
clear s;


n=10;
xlimit_all=[length(Mean_Vx)-25000,length(Mean_Vx)-5000];

%Reduce Sonic Data to CCD_Duration and only use every n data point
n = 1;
xlimit_all=[];
for CCD_n=1:length(CCD_Folders(1))
    xlimit_indice = [find(Sonic_Date_Num>CCD_duration_datenum(CCD_n,1),1,'first') find(Sonic_Date_Num>CCD_duration_datenum(CCD_n,2),1,'first')];
    xlimit_all = [xlimit_all; xlimit_indice];
end
data2=thin_data2(Sonic_Date_Num,xlimit_all,n);


set(gcf,'DefaultLineLineWidth',2);

s(1)=subplot(4,2,1);
set(gcf,'position',[0 0 1280 1024])
p=plot(thin_data2(WD_azimut,xlimit_all,n));
ylabel('WD Azimut');
hold on;
plot(thin_data2(WD_rotor_azimut_sonic,xlimit_all,n),'Color','red');
hold off;
legend('Sonic','Rotor');


s(2) = subplot(4,2,2);
plot(thin_data2(Sigma_WD_azimut,xlimit_all,n));
ylabel({'WD Azimut'});
ylim([0 50]);
hold on;
plot(abs(thin_data2(WD_azimut,xlimit_all,n)-thin_data2(WD_rotor_azimut_sonic,xlimit_all,n)),'Color','red');
hold off;
legend('Sonic Sigma','Difference Sonic Rotor');


s(3)=subplot(4,2,3);
plot(thin_data2(WD_elevation,xlimit_all,n));
ylabel('WD Elevation');
hold on;
plot(thin_data2(WD_rotor_elevation,xlimit_all,n),'Color','red');
hold off;
legend('Sonic','Rotor');

s(4) = subplot(4,2,4);
plot(thin_data2(Sigma_WD_elevation,xlimit_all,n));
ylim([0 50]);
ylabel({'WD Elevation'});
hold on;
plot(abs(thin_data2(WD_elevation,xlimit_all,n)-thin_data2(WD_rotor_elevation,xlimit_all,n)),'Color','red');
hold off;
legend('Sonic Sigma','Difference Sonic Rotor');

s(5) = subplot(4,2,5);
plot(thin_data2(V_total,xlimit_all,n));
ylabel('V_ges'); 
hold on;
plot(thin_data2(Sigma_Vges,xlimit_all,n),'Color','red');
hold off;
legend('V_ges','Sigma');

s(6) = subplot(4,2,6);
% plot(thin_data2(Turbulence_x,xlimit_all,n));
% hold on;
% plot(thin_data2(Turbulence_y,xlimit_all,n),'Color','red');
% hold on;
% plot(thin_data2(Turbulence_z,xlimit_all,n),'Color','green');
% hold off;
plot(1./thin_data2(Sigma_Vges,xlimit_all,n).*(1/3.*(thin_data2(Sigma_Vx,xlimit_all,n)+thin_data2(Sigma_Vy,xlimit_all,n)+thin_data2(Sigma_Vz,xlimit_all,n))).^(1/2))
ylabel('Turbulence');
legend('Turbulence');

s(7)=subplot(4,2,7);
plot(thin_data2(T_acoustic,xlimit_all,n));
ylabel('Temperature');
legend('Sonic');


x_counter=1:length(thin_data2(U_blower,xlimit_all,n));
s(8)=subplot(4,2,8);
ss=plotyy(x_counter, thin_data2(U_blower,xlimit_all,n),x_counter, thin_data2(Flowmeter_massflow,xlimit_all,n),'plot','plot');
s=[s ss];
ylabel('U Blower');
ylabel(ss(2),{'Flowmeter';'MassFlow'})

for i = 1:length(s)
    set(s(i),'XLim',[1 length(x_counter)]);
    set(s(i),'XGrid', 'on','YGrid', 'on');
    %datetick(s(i),'x',15,'keeplimits');
end

% set(gcf,'NextPlot','add');
% axes;
% for i = 1:CCD_Folders_size;
%     tmp22(i)={strcat('Start Time: ',datestr(CCD_duration_datenum(i,1)),'; Stop Time: ', datestr(CCD_duration_datenum(i,2)),'; Duration: ',num2str(CCD_duration_num(i)),' s')};
% end
% text(0.1,-0.07,tmp22);
% h = title(tmp2);
% set(gca,'Visible','off');
% set(h,'Visible','on');
