function inletEff = Paik_inert(dPar, varargin)
%PAIK_INERT calculates the inlet efficiency accourding to Paik 2002.
%Assuming intert from the inlet entry to the detection volume
% dPar = diameter of particle
% vWind = wind speed of the sourounding
% const = constants need for the calculation
if nargin == 2
    const = varargin{1};
else
    const.vWind         = 5;       %[m/s]
    const.pressure      = 656;    %[hPa]
    const.temperature   = 257.28; %[K]
    const.massflow      = 59.09;  %[l/min]
    const.dPipe         = 0.05;    %[m]
end
if ~isfield(const,'ice')
    const.ice = 0;
end


vWind = const.windSpeed;
vInlet = const.massflow / 60 / 1000 * const.temperature / 273.15 * ...
    1013.15 / const.pressure / pi / const.dPipe^2 * 4;
const.slipCorrection = 1;

const.etaAir = 17.08e-6 * ((const.temperature/273.15)^(1.5)) * ...
    (393.396 / (const.temperature + 120.246));
inletEff = aspEffPaik(vWind, dPar, vInlet, const) .* inertLosses(vWind, dPar, vInlet, const);

function rhoParticle = density(dpar,const)
if const.ice == 1;
    %Parmeterisierung from Cotton 2013
    d_big = dpar > 70e-6;    
    rhoParticle = 700.*ones(1,numel(dpar));
    rhoParticle(d_big) = 0.049./dpar(d_big);    
else
    rhoParticle = 1000; %[kg/m3]
end
function etaPaik = aspEffPaik(vWind, dPar, vInlet, const)
%ASPEFFPAIK calculates the inlet efficiency accourding to Paik 2002.
% dPar = diameter of particle
% vWind = air speed of the sourounding wind
% vInlet = air speed inside the inlet
% const = constants need for the calculation
etaPaik = 1 + (vWind./vInlet - 1) .* (1 - 1./(1+ k2(vWind, vInlet) .* stokesNumber(vWind, dPar, const)));

function factorPaik = k2(vWind, vInlet)
%K2 calculates a factor needed for aspEffPaik by correcting the k factor used
%for the calculation of the aspiration efficiency Belyaev and Levin
%1972,1974
% vWind = air speed of the sourounding wind
% vInlet = air speed inside the inlet
factorPaik = k(vWind, vInlet) - 0.9*(vWind./vInlet).^(0.1);

function factorBW = k(vWind, vInlet)
%K calculates a factor needed for he calculation of the aspiration efficiency Belyaev and Levin
%1972,1974
% vWind = air speed of the sourounding wind
% vInlet = air speed inside the inlet
factorBW = 2 + 0.617*(vInlet./vWind);

function factorStokes = stokesNumber(vWind, dPar, const)
%factorStokes calculates the stokes number.
% dPar = diameter of particle
% vWind = wind speed of the sourounding
% const = constants need for the calculation
factorStokes = (dPar.^2) .* vWind .* density(dPar, const) .* const.slipCorrection ./ ...
    18 ./ const.etaAir ./ const.dPipe;

function etaInert = inertLosses(vWind, dPar, vInlet, const)
%INERTLOSSES calculates the inlet efficiency accourding to Paik 2002.
% dPar = diameter of particle
% vWind = wind speed of the sourounding
% vInlet = air speed inside the inlet
% const = constants need for the calculation
numerator   = 1 + ((vWind./vInlet) - 1) ./ (1 + (2.66./(stokesNumber(vWind, dPar, const).^(2/3))));
denominator = 1 + ((vWind./vInlet) - 1) ./ (1 + (0.418./stokesNumber(vWind, dPar, const)));

etaInert = numerator ./ denominator;


