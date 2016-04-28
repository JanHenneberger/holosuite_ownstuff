function [anData]=includeUpdraftKorolev(anData)
%% calculates necassry updraft velocities in MPCs (Paper Korolev, 2008) 
% output
% uz  = updraft velocity [m s-1]
% Niri = Produkt of ice particle number concentration and radius ice
%                   crystal [um cm-3]
% iceSupersaturation = supersaturation in respect to ice in water saturated
%                       air
% glaciationTime = glaciation time [s] bases in Korolev, 2003

% pressure [Pa]
% T = temperature [K]
% Ni = Number concentration ice crystals [m-3]
% ri = mean maximum radius ice [m]
% LWC = Liquid water content [kg/m3]   
% IWC = Ice water content [kg/m3] 

p = anData.meteoPressure*1e2;
T = anData.meteoTemperature +273.14;
Ni = anData.IWConcentraction*1e6;
ri = anData.IWMeanMaxD/2;

    
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

c = 0.9;      %0<c<1    

%Coefficient of water vapor diffusion in the air
D = 2.11e-5*(T/273.15).^1.94.*(p/101325); %m2/s

g = 9.81;


b_i = (1./q_v + L_i.*L_w./(c_p.*R_v.*T.*T)).*((4*pi*rho_i.*c./rho_a).*...
    (E_w./E_i-1).*(1./(rho_i.*L_i.*L_i./(k.*R_v.*T.*T)+rho_i.*R_v.*T./(E_i.*D))));

a_0 = g./(R_a.*T).*(L_w.*R_a./(c_p.*R_v.*T)-1);

u_z = (b_i./a_0).*Ni.*ri;

anData.uz = u_z;
anData.Niri = Ni.*ri;

tmp = anData.Parameter.histBinBorder;
edges = tmp;
tmp(1) = [];
edges(end) = [];
edgesSize = log(tmp) - log(edges);

a1 = anData.ice.histRealCor*1e6;
a2 = edgesSize;
a3 = anData.IWMeanD/2;
b = a1.*repmat(a2',1,size(a1,2));
d = abs(b.*repmat(a3,size(b,1),1));

anData.Niri2 = sum(d);
anData.uz2 = (b_i./a_0).*anData.Niri2;

%calculation of glaciation time (Phase transformation of mixed-phase clouds, ...
%Korolev 2003, Equation 5)
%Assuming zero updraft velocity

%supersaturation over and ice surface
Si = (E_w - E_i)./E_i;
anData.iceSupersaturation = Si;

LWC = abs(anData.LWContent)/1000;
IWC = abs(anData.IWContent)/1000;

Ai = (L_i.^2./(k.*R_v.*T.^2)+R_v.*T./(E_i.*D)).^(-1);

%water content per volume
LWC_V = LWC.*rho_a;
IWC_V = IWC.*rho_a;

tauG = (4*pi*c.*Ai.*Si).^(-1).*(9*pi*rho_i/2)^(1/3).*...
    ( ((LWC_V +IWC_V)./Ni).^(2/3) - (IWC_V./Ni).^(2/3) );

anData.glaciationTime = abs(tauG);

end

