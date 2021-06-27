%%%% Pentagon formation %%%%

simTime = 1000; % simulation time
gamma = [1, 1, 10, 10]; % cost function gains
params(1) = 0; % Obstacle avoidance on / off
params(2) = 0; % Safety distance from agents on
params(3) = 0; % R / params(3) Safety distance from agents on
params(4) = 0; % Visibility constraints between agents on
params(5) = 0; % Connectivity radius R * params(5)
N_agents = 5; % Number of agents
N_obstacles = 10; % Number of obstacles
R = .2; % Sensing radius
dim = 3; % size of the state
barrier = .1; % barrier limit
formationIdx = [1, 250, 750, 1500, 2500];

%% Formation
B = [1, 0, 0, 0, -1, 1, 0;
    -1, 1, 0, 0, 0, 0, -1;
    0, -1, 1, 0, 0, 0, 0;
    0, 0, -1, 1, 0, -1, 1;
    0, 0, 0, -1, 1, 0, 0];
d = -reshape(...
    [1, .3, -.8, -.8, .3, .5, .5;    % X
     0, 1, .3, -.3, -1, 1.3, -1.3],...% Y
    [],1); 
A = [0, 1, 0, 1, 1;
     1, 0, 1, 1, 0;
     0, 1, 0, 1, 0;
     1, 1, 1, 0, 1;
     1, 0, 0, 1, 0];
lambdas = eig(B*B.');
lambda2 = min(lambdas(lambdas > 1e-5));
taskTitle = 'Convergence with pentagon formation';

%% Obstacles generation
obstacles_boundaries = [2, 5;  % X
                        2, 5]; % Y
O = rand(2, N_obstacles) ...
    .* repmat(diff(obstacles_boundaries, [], 2), 1, N_obstacles)...
    + repmat(min(obstacles_boundaries, [], 2), 1, N_obstacles);

%% Target generation
target_boundaries = [5, 6; % X
                    5, 6]; % Y
t = rand(2, 1) ...
    .* diff(target_boundaries, [], 2) ...
    + min(target_boundaries, [], 2);

%% Initial conditions
% Swarm
initial_position_boundaries = ...
    [-.1, .1;     % a
	 -.1, .1;     % b
     -pi/2, pi/2];    % phi
x0 = rand(3, N_agents) ...
    .* repmat(diff(initial_position_boundaries, [], 2), 1, N_agents) ...
    + repmat(min(initial_position_boundaries, [], 2), 1, N_agents);
% Controller
u0 = reshape(x0(1:2,:) + 1e-2*ones(2,N_agents),[],1);%1e-1*repmat(t, N_agents, 1);
x0 = x0(:); % vectorized
epsilon = .005;
