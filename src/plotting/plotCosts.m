function plotCosts(costs,lambda2,labels)
% PLOTCOSTS Plot cost evolution over time
%   INPUT:
%       costs: MxN N cost terms to plot, M samples
%       lambda2: algebraic connectivity of the formation
%       labels: labels of the cost terms

for i = 1:size(costs,2)
    semilogy((costs(:,i) - min(costs(:,i))) / (max(costs(:,i))- min(costs(:,i))));
    hold on;
end
time = 0:0.01:size(costs,1);
labels{end+1} = '$$e^{-\frac{t}{\lambda_2}}$$';
e = exp(-time/lambda2);
semilogy((e - min(e)) / (max(e) - min(e)));
xlabel('Simulation time', 'interpreter', 'latex');
% ylabel('$$\log((\Phi_i(t) - \min_t\Phi_i(t))/(\max_t\Phi_i(t)-\min_t\Phi_i(t)))$$', 'interpreter', 'latex');
ylabel('$$\log(\text{Normalised cost})$$', 'interpreter', 'latex');
title('Normalised cost over simulation time', 'interpreter', 'latex');
legend(labels, 'interpreter', 'latex', 'Location','southwest')
set(gca,'FontSize',28);
end

