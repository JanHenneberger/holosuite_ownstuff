function timeVektor = conTime2Vec(time)
time = time/3600/24;
%Tage
timeVektor(1,:) = floor(time);
time = time-timeVektor(1,:);
%Stunden
time = time*24;
timeVektor(2,:) = floor(time);
time = time-timeVektor(2,:);
%Minuten
time = time*60;
timeVektor(3,:) = floor(time);
time = time-timeVektor(3,:);
%Sekunden
time = time*60;
timeVektor(4,:) = floor(time);
time = time-timeVektor(4,:);
%Millisekunden
time = time*1000;
timeVektor(5,:) = floor(time);
time = time-timeVektor(5,:);
end