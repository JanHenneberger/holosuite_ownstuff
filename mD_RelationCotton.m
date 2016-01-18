function [ mass ] = mD_RelationCotton(diameter)
%mD_RelationCotton Calculates the mass of ice particle based on 
% Cotton at al.,2013

d_big = diameter > 70e-6;
mass = 700*pi/6*diameter.^3;
mass(d_big) = 0.026*diameter(d_big).^2;
end

