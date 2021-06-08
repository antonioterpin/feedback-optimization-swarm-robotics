clear all;
close all;
clc;

addpath(genpath('.'));

Ts = .4;
Nsim = 4*1e2;
gamma = [20, 20, 1]; % cost function weights
continuousTime = false;
% %% Single agent (LLC test)
% a = Agent([0;0], 5, 0, continuousTime);
% x = zeros(2,Nsim);
% for k = 2:Nsim
%     a.tick([5;1],Ts);
%     x(:,k) = a.position;
% end
% 
% figure;
% plot(x(1,:), x(2,:), '*');

%

rng(0);
%
[obstacles, target, limits] = SimulationConst();
[swarm, formation, sensingRadius] = FormationSpecification();

% Simulation
trajectory = zeros(2,size(swarm,2),Nsim);
trajectory(:,:,1) = swarm(1:2,:);
agents = cell(size(swarm,2),1);

H = squeeze((~isnan(formation(1,:,:)) | ~isnan(formation(2,:,:))));
H = -(H + H.') + diag(sum((H + H.'),2));
Ht = eye(size(swarm,2));
ft = -repmat(target.', size(swarm,2), 1);
f = zeros(size(swarm,2), 2);
for i = 1:size(swarm,2)
    for k = 1:size(swarm,2)
        for j = 1:2
            if isnan(formation(j,i,k))
                continue;
            end
            f(i,j) = f(i,j) - formation(j,i,k);
            f(k,j) = f(k,j) + formation(j,i,k);
        end
    end
    agents{i} = Agent(swarm(1:2,i), swarm(3,i), 0, continuousTime);
end

% Centralized
for k = 2:Nsim
    % time varying cost function
    Ho = zeros(size(swarm,2));
    fo = zeros(size(swarm,2),2);
    for i = 1:size(swarm,2)
        repulsion_from_obstacles = agents{i}.position - obstacles;
        repulsion = sum(repulsion_from_obstacles.^2);
        repulsion(repulsion > sensingRadius / 2) = Inf;
        Ho(i,i) = sum(1./repulsion);
        fo(i, :) = transpose(sum(obstacles ./ repmat(repulsion, 2, 1), 2));
    end
    
    
    % solve optimization problem (currently centralized!)
    u = zeros(size(swarm,2),2);
    opts = optimoptions('quadprog','display','off');
    u(:,1) = quadprog(gamma(1) * H + gamma(2) * Ht + Ho, ...
        gamma(1) * f(:,1) + gamma(2) * ft(:,1) + fo(:,1),...
        [],[],[],[],[],[],[],opts);
    u(:,2) = quadprog(gamma(1) * H + gamma(2) * Ht + Ho,...
        gamma(1) * f(:,2) + gamma(2) * ft(:,2) + fo(:,2),...
        [],[],[],[],[],[],[],opts);
    
    for i = 1:size(swarm,2)
        agents{i}.tick(u(i,:).',Ts);
        trajectory(:,i,k) = agents{i}.position;
    end
end

%% Plots
figure;
for k = 1:size(trajectory,3)
    plot(obstacles(1,:), obstacles(2,:), 'o'); hold on;
    plot(target(1), target(2), 's');
    plot([trajectory(1,:,k), trajectory(1,1,k)], [trajectory(2,:,k), trajectory(2,1,k)]);
    plot(trajectory(1,:,k), trajectory(2,:,k), '*');
    xlim(limits(1:2));
    ylim(limits(3:4));
    hold off;
    drawnow;
%     pause;
end
%%
rmpath(genpath('.'));
%%
%% Ancillary functions
% Constant specifying the problem
function [obstacles, target, limits] = SimulationConst
    N_dimensions = 2; % 2D for now

    % obstacle region
    N_obstacles = 7;
    % obstacles region uniform in a rectangle
    obstacles_boundaries = [2, 6;  % X
                            2, 6]; % Y
    obstacles = rand(N_dimensions, N_obstacles) ...
        .* repmat(diff(obstacles_boundaries, [], 2), 1, N_obstacles)...
        + repmat(min(obstacles_boundaries, [], 2), 1, N_obstacles);
    
    % target
    target_boundaries = [8, 9; % X
                        8, 9]; % Y
    target = rand(N_dimensions, 1) ...
        .* diff(target_boundaries, [], 2) ...
        + min(target_boundaries, [], 2);
    
    % World boundaries (only for visualization)
    limits = [-1, 10, -1, 10];
end

function [swarm, formation, sensingRadius] = FormationSpecification
    N_dimensions = 2+1; % 2D for now 

    % swarm
    N_agents = 5;
    initial_position_boundaries = [-.5, .5;     % X
                                   -.5, .5;     % Y
                                   -pi, pi];    % phi
    swarm = rand(N_dimensions, N_agents) ...
        .* repmat(diff(initial_position_boundaries, [], 2), 1, N_agents) ...
        + repmat(min(initial_position_boundaries, [], 2), 1, N_agents);
    
    % desired formation in terms of inter agents distances
    formation(1,:,:) = ...
        [NaN, NaN, NaN, NaN, .3; 
        1, NaN, NaN, NaN, NaN;
        NaN, .3, NaN, NaN, NaN;
        NaN, NaN, -.8, NaN, NaN;
        NaN, NaN, NaN, -.8, NaN];
    formation(2,:,:) = ...
        [NaN, NaN, NaN, NaN, -.5; 
        0, NaN, NaN, NaN, NaN;
        NaN, .5, NaN, NaN, NaN;
        NaN, NaN, .3, NaN, NaN;
        NaN, NaN, NaN, -.3, NaN];
    
    % sensing radius
    sensingRadius = 1;
end