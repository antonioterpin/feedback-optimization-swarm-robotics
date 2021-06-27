function plotCosts(costs,lambda2,labels)
% PLOTCOSTS Plot cost evolution over time
%   INPUT:
%       costs: MxN N cost terms to plot, M samples
%       lambda2: algebraic connectivity of the formation
%       labels: labels of the cost terms

for i = 1:size(costs,2)
    plot((costs(:,i) - min(costs(:,i))) / (max(costs(:,i))- min(costs(:,i))));
    hold on;
end
time = 0:0.01:size(costs,1);
labels{end+1} = '$$e^{-\frac{t}{\lambda_2}}$$';
plot(exp(-time/lambda2));
xlabel('Simulation time', 'interpreter', 'latex');
ylabel('$$(\Phi_i(t) - \min_t\Phi_i(t))/(\max_t\Phi_i(t)-\min_t\Phi_i(t))$$', 'interpreter', 'latex');
title('Normalised cost over simulation time', 'interpreter', 'latex');
legend(labels, 'interpreter', 'latex')
set(gca,'FontSize',28);
end

