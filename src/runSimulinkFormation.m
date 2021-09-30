%%%% run main %%%%
clear all;
close all;
clc;

rng(0);

addpath(genpath('.'));
run('task1'); % Load task

%% Run simulink
out = sim('formationSim', simTime);
trajectory = reshape(out.y.Data.', 2, N_agents, []); % 2xNxT

%% Plots
figure('Position', [10 10 900 900]);
plotFormation(trajectory,A,formationIdx);
title(taskTitle,'interpreter','latex');
set(gca,'FontSize',28);
% figure('Position', [10 10 900 400]);
% plotCosts([out.costformation.Data(:), out.costtarget.Data(:)], lambda2, ...
%     {'$$\Phi_d$$ -- Formation cost', '$$\Phi_{\tau}$$ -- Target cost'});
% xlim([0,1e3]);
%% Other metrics
% Radius of minimum circle centered at the target enclosing the swarm
% compareTuning(formationCost, targetCostNormalised, trajectory, t, ...
%     1.3724, referenceTargetCostNormalised, N_agents, ...
%     {'$$\gamma_1 = 1.00, \gamma_2 = 0.03$$', ...
%     '$$\gamma_1 = 1.00, \gamma_2 = 1.00$$'});

%% 
rmpath(genpath('.'));