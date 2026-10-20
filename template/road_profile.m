% inputs
vel = 1.32;                     % velocity [m/s]
H_hav = 0.025;                  % height of haversine
L_hav = 0.215*2;                % length of haversine (full period)
x_profile = 0.546;              % total profile length [m]
t_profile = x_profile / vel;    % total time to cover profile [s]
n_timesteps = 1000;             % number of timesteps

t_offset = 0.1;                 % time offset from experimental data (time to reach start of hav up) [s]
t_total = t_offset + t_profile; % total time (should match experimental) [s]

roadprofile.t = linspace(0,t_total,n_timesteps);    % discretize time into 1000 steps
roadprofile.x = vel*roadprofile.t;                  % discretize x position accordingly

x_piecewise_starts = [0,0.215,0.331];                      % x posn of start of section 1 (hav up), 2 (flat), 3 (hav down)
t_piecewise_starts = x_piecewise_starts / vel + t_offset;  % t      of start of section 1 (hav up), 2 (flat), 3 (hav down)

% calculate y value of each timestep based on piecewise function

for i = 1:length(roadprofile.t)
    
    if roadprofile.t(i) < t_piecewise_starts(1)
        % flat before start of profile
        roadprofile.y(i) = 0;
        
    elseif (t_piecewise_starts(1) <= roadprofile.t(i)) && (roadprofile.t(i) < t_piecewise_starts(2))
        % hav up
        roadprofile.y(i) = H_hav/2 * (1 - cos(2*pi()/L_hav * (roadprofile.x(i) - t_offset*vel)));
        
    elseif (t_piecewise_starts(2) <= roadprofile.t(i)) && (roadprofile.t(i) < t_piecewise_starts(3))
        % flat
        roadprofile.y(i) = H_hav;
        
    elseif t_piecewise_starts(3) <= roadprofile.t(i)
        % hav down
        roadprofile.y(i) = H_hav/2 * (1 - cos(2*pi()/L_hav * (roadprofile.x(i) - t_offset*vel - 0.116)));
        
    end
end

plot(roadprofile.x,roadprofile.y)
