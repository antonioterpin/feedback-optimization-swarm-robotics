function [W,ODelta] = obst_implemented(O,R,y,barrier)
%OBST Implements the obstacles indicator matrix
%   INPUT:
%       O       -- 2xO obstacle positions
%       R       -- sensing radius
%       y       -- 2Nx1 agents positions
%       epsilon -- barrier max
%   OUTPUT:
%       ODelta  -- 2Nx1 (obstacle indicator matrix)*obstacles 
%       W       -- Nx1 number of obstacles for each agent
N = numel(y) / 2;
diff = repmat(y, 1, size(O,2)) - repmat(O, N, 1);
diff = [...
    reshape(diff(1:2:size(diff,1), :).', [], 1).';  % X
    reshape(diff(2:2:size(diff,1), :).', [], 1).']; % Y
distances = vecnorm(diff);
inverse = 1./(distances.^2 + barrier);
Delta = reshape((distances < R) .* inverse, [], 1);
ODelta = kron(eye(N),O.').'*Delta;
W = sum(reshape(Delta, [], N));
end
