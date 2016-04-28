function t = iceGrowToRadius(r_end,p,T)
r_start = 1e-6;
t_step = 0.1;

t = 0;
r = r_start;

while r <= r_end
    r = iceMassGrow(r,t_step,p,T);
    t = t+t_step;
end