function degWind = conWindXY2Deg(xWind, yWind)

degWind = atand(xWind./yWind)+180.*(yWind>=0);
degWind = mod(degWind+360,360);