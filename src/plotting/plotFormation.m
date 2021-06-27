function plotFormation(trajectory,adjacency,T)
%PLOTFORMATION Plot formation evolution over time
%   INPUT:
%       trajectory  -- 2xNxNsim, N number of agents, Nsim simulation time
%       adjacency   -- adjacency matrix
%       T           -- n formations to plot
cmap = flipud(jet);

% plot agent trajectory
z = (1:size(trajectory,3)).';
for i=1:size(trajectory,2)
    x=squeeze(trajectory(1,i,:));
    y=squeeze(trajectory(2,i,:));
    hp = patch([x.' NaN], [y.' NaN], 0);
    set(hp,'cdata', [z.' NaN], 'edgecolor','interp','facecolor','none');
    hold on;
    scatter(x,y,1,z,'filled');
end

if numel(T) == 1
    step = ceil(size(trajectory,3) / T);
    steps = 1:step:size(trajectory,3)-step;
else
    steps = T;
end
    
for t = steps
    formation(trajectory, adjacency, t, cmap(ceil(size(cmap,1) * t / size(trajectory,3)),:)); % final formation
end
formation(trajectory, adjacency, size(trajectory,3), cmap(end,:)); % final formation

colormap(cmap)
c = colorbar('southoutside', 'Ticks', []);
c.Label.String = 'Simulation time';
c.Label.Interpreter = 'latex';

xlabel('a', 'interpreter', 'latex');
ylabel('b', 'interpreter', 'latex');

end

function formation(trajectory, adjacency, t, color)
    markersize=14;
    textsize=10;

    for i=1:size(trajectory,2)
        for j=i+1:size(trajectory,2)
            if adjacency(i,j)==1
                pi=trajectory(:,i,t);
                pj=trajectory(:,j,t);
                line([pi(1),pj(1)], [pi(2),pj(2)], 'linewidth', 2, 'color', color);
            end
        end
    end

    for i=1:size(trajectory,2)
        x=trajectory(1,i,t);
        y=trajectory(2,i,t);
        plot(x, y, 'o', 'MarkerEdgeColor', color, 'MarkerFaceColor', color, 'markersize', 7)
        plot(x, y, 'o', ...
            'MarkerSize', markersize,...
            'linewidth', 2,...
            'MarkerEdgeColor', color,...
            'markerFaceColor', [1 1 1]);
        text(x, y, num2str(i),...
            'color', color, 'FontSize', textsize, 'horizontalAlignment', 'center', 'FontName', 'times');
    end
end
