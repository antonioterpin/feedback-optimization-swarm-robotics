%%%% run main %%%%
clear all;
close all;
clc;

rng(0);

addpath(genpath('.'));
task = @task1; % task specification
simTime = 1000; % simulation time
gamma = [1, 1, 10]; % cost function gains

% Load task
[x0, B, d, t, u0, epsilon, O, R, limits, dynamics_type, barrier] = task();

if dynamics_type == 0 % thrust control
    dim = 5;
elseif dynamics_type == 1 % velocity control
    dim = 3;
else
    error('Unknown dynamics type');
end

% Obstacle avoidance on / off
params = true;

%% Run simulink
out = sim('modelMain', simTime);
trajectory = reshape(out.y.Data.', 2, numel(x0) / dim, []); % 2xNxT

%% Plot results
figure;
for k = 1:size(trajectory,3)
    plot(t(1), t(2), 's'); hold on;
    if params(1) % obstacle avoidance on
        plot(O(1,:), O(2,:), 'o');
    end
    plot([trajectory(1,:,k), trajectory(1,1,k)], [trajectory(2,:,k), trajectory(2,1,k)]);
    plot(trajectory(1,:,k), trajectory(2,:,k), '*');
    xlim(limits(1:2));
    ylim(limits(3:4));
    hold off;
    drawnow;
%     pause(.25);
end

%% 
rmpath(genpath('.'));