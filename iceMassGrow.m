function d_new = iceMassGrow(d_old, t, p, T)
% calculates ice particle grow at water saturation

% d_old = diameter of of ice particle old [kg]
% t = timestep
% p = pressure [Pa]
% T = temperature [K]

% d_new = diameter of ice particle after timestep [kg]

L_w = (2500.8 - 2.36.*(T-273) + 0.0016.*(T-273).*(T-273) - 0.00006.*(T-273).*(T-273).*(T-273))*1000;   %J/kg
L_i = (2834.1 - 0.29.*(T-273) - 0.004.*(T-273).*(T-273))*1000;  %J/kg
R_v = 461.5;            %J/kgK / specific gas constant of water vapor
%Thermal conductivity of water vapor in air
k = 4.1868e-3*(5.69+0.017*(T-273.15));  %W/(m*K)
%Coefficient of water vapor diffusion in the air
D = 2.11e-5*(T/273.15).^1.94.*(p/101325); %m2/s

c = 0.9;      %0<c<1    

E_w = 611.7*exp(-(L_w./R_v).*(1./T - 1./273)); %Pa / saturation pressure over water
E_i = 611.7*exp(-(L_i./R_v).*(1./T - 1./273)); %Pa / saturation pressure over ice
%supersaturation over and ice surface
Si = (E_w - E_i)./E_i;

Fk = (L_i./R_v./T - 1).*L_i./k./T;

Fd = R_v.*T./D./E_i;

rho_i = 700;            %kg/m3 / density ice
alpha_m = 0.5;

m_old = pi/6*d_old.^3*rho_i;

delta_m = alpha_m*4*pi*c*d_old/2*Si./(Fk+Fd)*t;

m_new = m_old + delta_m;

d_new = (6/pi*m_new./rho_i)^(1/3);
