clear
clc
%% Inputs
Kt = 3000; % Tire spring rate
Ks = 635; % Suspension spring rate
Cs = 25; % Suspension Damping
Ct = 500; % Tire Damping
Ms = 0.435; % Sprung Mass
Mu = 0.119; % Unsprung Mass

ex_vel(:,1) = readmatrix('2.62 m per sec.xlsx','Range','A5:A34')/3;
ex_vel(:,2) = readmatrix('2.62 m per sec.xlsx','Range','F5:F34')*3;

ex_disp(:,1) = readmatrix('2.62 m per sec.xlsx','Range','A5:A34')/3;
ex_disp(:,2) = readmatrix('2.62 m per sec.xlsx','Range','E5:E34');

ex_acc(:,1) = readmatrix('2.62 m per sec.xlsx','Range','A5:A34')/3;
ex_acc(:,2) = readmatrix('2.62 m per sec.xlsx','Range','G5:G34')*3^2;

Vx = ex_vel(:,1);
Vy = ex_vel(:,2);
X = ex_disp(:,1);
Y = ex_disp(:,2);
f = polyfit(Vx,Vy,12);
fv = polyfit(X,Y,12);
Vy2= polyval(f,X);
Y2 = polyval(fv,Vx);
samp_vel(:,1) = Vx;
samp_vel(:,2) = Vy2;
samp_disp(:,1) = X;
samp_disp(:,2) = Y2;

%% Road Profile

vel = 2.62;                     % velocity [m/s]
H_hav = 0.025;                  % height of haversine
L_hav = 0.215*2;                % length of haversine (full period)
x_profile = 0.546;              % total profile length [m]
t_profile = x_profile / vel;    % total time to cover profile [s]
n_timesteps = 1000;             % number of timesteps

t_offset = 0.06;                 % time offset from experimental data (time to reach start of hav up) [s]
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

Yroad(:,1) = transpose(roadprofile.t);
Yroad(:,2) = transpose(roadprofile.y);

