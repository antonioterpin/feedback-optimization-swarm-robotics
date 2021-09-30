function compareTuning(formationCosts,targetCosts,trajectories,target,optRadius,optTargetCost,N_agents,labels)
% Formation
figure('Position', [10 10 900 450]);
for i = 1:size(formationCosts,2)
    semilogy(formationCosts(:,i));
    hold on;
end
xlabel('Simulation time', 'interpreter', 'latex');
ylabel('$$\log(\Phi_d(t) / \gamma_2)$$', 'interpreter', 'latex');
title('Formation cost over simulation time', 'interpreter', 'latex');
legend(labels, 'interpreter', 'latex')
set(gca,'FontSize',28);
xlim([0,5*1e4]);
yticks([1e-3, 1e-2, 1e-1, 1, 1e1]);
ylim([5*1e-3, 1e1]);
% Target
figure('Position', [10 10 900 450]);
for i = 1:size(targetCosts,2)
    semilogy(targetCosts(:,i));
    hold on;
end
xlabel('Simulation time', 'interpreter', 'latex');
ylabel('$$\log(\Phi_{\tau}(t) / \gamma_2)$$', 'interpreter', 'latex');
yline(optTargetCost, '--');
labels{end+1} = 'Desired';
title('Target cost over simulation time', 'interpreter', 'latex');
legend(labels, 'interpreter', 'latex')
set(gca,'FontSize',28);
xlim([0,1e5]);
yticks([1e-3, 1e-2, 1e-1, 1, 1e1]);
ylim([1, 1e2]);
% Radius
figure('Position', [10 10 900 450]);
for i = 1:size(trajectories, 4)
    trajectory = trajectories(:,:,:,i);
    radius = max(reshape(vecnorm(reshape(trajectory,2,[]) - target),N_agents,[]));
    plot(radius);
    hold on;
end
yline(optRadius, '--');
xlabel('Simulation time', 'interpreter', 'latex');
ylabel('Distance from target', 'interpreter', 'latex');
title('Distance from target over simulation time', 'interpreter', 'latex');
legend(labels, 'interpreter', 'latex')
set(gca,'FontSize',28);
xlim([0,1e5]);
end

