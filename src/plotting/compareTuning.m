function compareTuning(costs,trajectories,target,N_agents,names)
figure('Position', [10 10 900 900]);
labels = {};
for i = 1:size(costs,2)
    trajectory = trajectories(:,:,:,i);
    radius = max(reshape(vecnorm(reshape(trajectory,2,[]) - target),N_agents,[]));
    semilogx((costs(:,i) - min(costs(:,i))) / (max(costs(:,i))- min(costs(:,i))));
    hold on;
    semilogx((radius - min(radius)) / (max(radius) - min(radius)));
    labels{end+1} = sprintf('Formation cost -- %s', names{i});
    labels{end+1} = sprintf('Distance from target -- %s', names{i});
end
xlabel('Simulation time', 'interpreter', 'latex');
ylabel('$$(J(t) - \min_tJ(t))/(\max_tJ(t)-\min_tJ(t))$$', 'interpreter', 'latex');
title('Normalised formation cost over simulation time', 'interpreter', 'latex');
legend(labels, 'interpreter', 'latex')
set(gca,'FontSize',28);
xlim([0,1e4]);
end

