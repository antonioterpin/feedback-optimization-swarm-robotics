%%%% E formation -- unproper gains %%%%

simTime = 20000; % simulation time
gamma = [1, 1, 10, 10]; % cost function gains
params(1) = 0; % Obstacle avoidance on / off
params(2) = 0; % Safety distance from agents on
params(3) = 0; % R / params(3) Safety distance from agents on
params(4) = 0; % Visibility constraints between agents on
params(5) = 0; % Connectivity radius R * params(5)
N_agents = 12; % Number of agents
N_obstacles = 10; % Number of obstacles
R = .2; % Sensing radius
barrier = .1; % barrier limit
dim = 3; % size of the state
formationIdx = [1, 250];

%% Formation
N_edges = 12;
B = zeros(N_agents, N_edges);
A = zeros(N_agents, N_agents); % adjacency matrix for plotting! i.e., remove edges if not desired :)
% E nodes & edges
B(1,1) = 1; B(1,12) = -1;
A(1,12) = 1; A(12,1) = 1;
for i = 2:12
    B(i,i) = 1;
    B(i,i-1) = -1;
    A(i,i-1) = 1;
    A(i-1,i) = 1;
end
% % T nodes & edges
% B(13,1) = 1; B(1,20) = -1;
% A(13,20) = 1; A(20,13) = 1;
% for i = 14:20
%     B(i,i) = 1;
%     B(i,i-1) = -1;
%     A(i,i-1) = 1;
%     A(i-1,i) = 1;
% end
% % H nodes & edges
% B(21,1) = 1; B(1,32) = -1;
% A(21,32) = 1; A(32,21) = 1;
% for i = 22:32
%     B(i,i) = 1;
%     B(i,i-1) = -1;
%     A(i,i-1) = 1;
%     A(i-1,i) = 1;
% end
% interconnections between letters
% B(2,33) = 1; B(13,33) = -1; % E -> T
% B(14,34) = 1; B(21,34) = -1; % T -> H

% distances
d = zeros(2,N_edges);
% E
d(:,1) = [1; 0];
d(:,2) = [0; -.5];
d(:,3) = [-.7; 0];
d(:,4) = [0; -.5];
d(:,5) = [.5; 0];
d(:,6) = [0; -.5];
d(:,7) = [-.5; 0];
d(:,8) = [0; -.5];
d(:,9) = [.7; 0];
d(:,10) = [0; -.5];
d(:,11) = [-1; 0];
d(:,12) = [0; 2.5];
% % T
% d(:,13) = [1; 0];
% d(:,14) = [0; -.5];
% d(:,15) = [-.3; 0];
% d(:,16) = [0; -2];
% d(:,17) = [-.4; 0];
% d(:,18) = [0; 2];
% d(:,19) = [-.3; 0];
% d(:,20) = [0; .5];
% % H
% d(:,21) = [.3; 0];
% d(:,22) = [0; -1];
% d(:,23) = [.4; 0];
% d(:,24) = [0; 1];
% d(:,25) = [.3; 0];
% d(:,26) = [0; -2.5];
% d(:,27) = [-.3; 0];
% d(:,28) = [0; 1];
% d(:,29) = [-.4; 0];
% d(:,30) = [0; -1];
% d(:,31) = [-.3; 0];
% d(:,32) = [0; 2.5];
% % Interconnections
% d(:,33) = [.2; 0]; % E -> T
% d(:,34) = [.2; 0]; % T -> H

d = -reshape(d(:,1:N_edges),[],1);
lambdas = eig(B*B.');
lambda2 = min(lambdas(lambdas > 1e-5));
taskTitle = sprintf('E shape, $$\\gamma_1 = %.2f, \\gamma_2 = %.2f, \\lambda_2 = %.2f$$', gamma(1), gamma(2), lambda2);

%% Obstacles generation
obstacles_boundaries = [1, 3;  % X
                        1, 3]; % Y
O = rand(2, N_obstacles) ...
    .* repmat(diff(obstacles_boundaries, [], 2), 1, N_obstacles)...
    + repmat(min(obstacles_boundaries, [], 2), 1, N_obstacles);

%% Target generation
target_boundaries = [2, 3; % X
                    2, 3]; % Y
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
epsilon = .01;
