%%%% run main %%%%
clear all;
close all;
clc;

addpath(genpath('.'));
task = @task1; % task specification
simTime = 100; % simulation time
gamma = [1, 1, 1]; % cost function gains

% Load task
[x0, B, d, t, u0, epsilon, O, R, limits] = task();

%% Run simulink
out = sim('modelMain', simTime);
trajectory = reshape(out.y.Data.', 2, numel(x0) / 3, []); % 2xNxT

%% Plot results
figure;
for k = 1:size(trajectory,3)
    plot(O(1,:), O(2,:), 'o'); hold on;
    plot(t(1), t(2), 's');
    plot([trajectory(1,:,k), trajectory(1,1,k)], [trajectory(2,:,k), trajectory(2,1,k)]);
    plot(trajectory(1,:,k), trajectory(2,:,k), '*');
%     xlim(limits(1:2));
%     ylim(limits(3:4));
    hold off;
    drawnow;
%     pause;
end

%% 
rmpath(genpath('.'));