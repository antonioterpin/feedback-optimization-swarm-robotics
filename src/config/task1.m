%%%% Task 1 %%%%
function [x0, B, d, t, u0, epsilon, O, R, limits] = task1
%TASK1 Defines the settings for a simulation
%
%   OUTPUT:
%       x0      -- 3Nx1 initial conditions for the swarm
%       B       -- incidence matrix for the formation specification
%       d       -- 2Ex1 edges weights
%       t       -- target position
%       u0      -- 3Nx1 initial conditions for the controller
%       epsilon -- control gain
%       O       -- 2xO obstacles positions column-wise
%       R       -- scalar obstacles sensing radius
%       limits  -- suggested visualizations limits [minX, maxX, minY, maxY]

N_agents = 5; % Number of agents
N_obstacles = 5; % Number of obstacles
R = 1; % Sensing radius

%% Initial conditions
% Swarm
initial_position_boundaries = ...
    [-.5, .5;     % a
	 -.5, .5;     % b
     -pi, pi];    % phi
x0 = reshape(rand(3, N_agents) ...
    .* repmat(diff(initial_position_boundaries, [], 2), 1, N_agents) ...
    + repmat(min(initial_position_boundaries, [], 2), 1, N_agents), [],1);
% Controller
u0 = zeros(2*N_agents, 1);
epsilon = .01;

%% Formation
B = [1, 0, 0, 0, -1, 1, 0;
    -1, 1, 0, 0, 0, 0, -1;
    0, -1, 1, 0, 0, 0, 0;
    0, 0, -1, 1, 0, -1, 1;
    0, 0, 0, -1, 1, 0, 0];
d = reshape(...
    [1, .3, .8, .8, .3, .5, .5;    % X
     0, 1, .3, .3, 1, 1.3, 1.3],...% Y
    [],1); 

%% Obstacles generation
obstacles_boundaries = [2, 6;  % X
                        2, 6]; % Y
O = rand(2, N_obstacles) ...
    .* repmat(diff(obstacles_boundaries, [], 2), 1, N_obstacles)...
    + repmat(min(obstacles_boundaries, [], 2), 1, N_obstacles);

%% Target generation
target_boundaries = [8, 9; % X
                    8, 9]; % Y
t = rand(2, 1) ...
    .* diff(target_boundaries, [], 2) ...
    + min(target_boundaries, [], 2);
    
%% World boundaries (only for visualization)
limits = [-1, 10, -1, 10];

end
