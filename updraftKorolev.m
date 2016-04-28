function [uz, Niri, tauG, tauG2]=updraftKorolev(p,T,Ni,ri,LWC,IWC)
%% calculates necassry updraft velocities in MPCs (Paper Korolev, 2008) 
% output
% uz  = updraft velocity [m s-1]
% Niri = Produkt of ice particle number concentration and radius ice
%                   crystal [um cm-3]

% p = pressure [Pa]
% T = temperature [K]
% Ni = Number concentration ice crystals [m-3]
% ri = mean maximum radius ice [m]
% LWC = Liquid water content [kg/m3]   
% IWC = Ice water content [kg/m3] 

L_w = (2500.8 - 2.36.*(T-273) + 0.0016.*(T-273).*(T-273) - 0.00006.*(T-273).*(T-273).*(T-273))*1000;   %J/kg
L_i = (2834.1 - 0.29.*(T-273) - 0.004.*(T-273).*(T-273))*1000;                    %J/kg

rho_i = 700;            %kg/m3 / density ice
rho_a = p./(287.058.*T);  %kg/m3 / density air

R_v = 461.5;            %J/kgK / specific gas constant of water vapor

E_w = 611.7*exp(-(L_w./R_v).*(1./T - 1./273)); %Pa / saturation pressure over water
E_i = 611.7*exp(-(L_i./R_v).*(1./T - 1./273)); %Pa / saturation pressure over ice

q_v = 0.622*E_w./(p-E_w);

c_p = (1 + 0.87*q_v)*1003;     %J/kgK   
                           
R_a = (1 + 0.61*q_v)*287.058;   %J/kgK             

%Thermal conductivity of water vapor in air
k = 4.1868e-3*(5.69+0.017*(T-273.15));  %W/(m*K)

%ice crystal capacity
c = 0.9;      %0<c<1

%Coefficient of water vapor diffusion in the air
D = 2.11e-5*(T/273.15).^1.94.*(p/101325); %m2/s

g = 9.81;


b_i = (1./q_v + L_i.*L_w./(c_p.*R_v.*T.*T)).*((4*pi*rho_i.*c./rho_a).*...
    (E_w./E_i-1).*(1./(rho_i.*L_i.*L_i./(k.*R_v.*T.*T)+rho_i.*R_v.*T./(E_i.*D))));

a_0 = g./(R_a.*T).*(L_w.*R_a./(c_p.*R_v.*T)-1);

u_z = (b_i./a_0).*Ni.*ri;

uz = u_z;
Niri = Ni.*ri;

%calculation of glaciation time (Phase transformation of mixed-phase clouds, ...
%Korolev 2003, Equation 5)
%Assuming zero updraft velocity

%ice capacity

%supersaturation over and ice surface
Si = (E_w - E_i)./E_i;

Ai = (L_i.^2./(k.*R_v.*T.^2)+R_v.*T./(E_i.*D)).^(-1); %ms/kg

tauG = (4*pi*c.*Ai.*Si).^(-1).*(9*pi*rho_i/2)^(1/3).*...
    ( ((LWC+IWC)./Ni).^(2/3) - (IWC./Ni).^(2/3) );
end

