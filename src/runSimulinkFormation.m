%%%% run main %%%%
clear all;
close all;
clc;

rng(0);

addpath(genpath('.'));
run('task1'); % Load task

%% Run simulink
out = sim('formationSim', simTime);
trajectory = reshape(out.y.Data.', 2, numel(x0) / dim, []); % 2xNxT

%% Plots
figure('Position', [10 10 900 900]);
plotFormation(trajectory,A,formationIdx);
title(taskTitle,'interpreter','latex');
figure('Position', [10 10 900 900]);
plotCosts([out.costformation.Data(:), out.costtarget.Data(:)], lambda2, ...
    {'$$\Phi_1$$ -- Formation cost', '$$\Phi_2$$ -- Target cost','$$e^{-\frac{t}{\lambda_2}}$$'});
xlim([0,1e4]);
%% 
rmpath(genpath('.'));