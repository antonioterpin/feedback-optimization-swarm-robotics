function [W,ODelta] = obst(O,R,y)
%OBST Implements the obstacles indicator matrix
%   INPUT:
%       y       -- 2Nx1 agents positions
%       O       -- 2xO obstacle positions
%       R       -- sensing radius
%   OUTPUT:
%       ODelta  -- 2Nx1 (obstacle indicator matrix)*obstacles 
%       W       -- Nx1 number of obstacles for each agent
N = numel(y) / 2;
distances = vecnorm(reshape(...
    repmat(y, 1, size(O,2)) - repmat(O, N, 1), 2, []));
Delta = (distances < R).';
ODelta = kron(eye(N),O.').'*Delta;
W = reshape(sum(reshape(Delta.', [], N)), [], 1);
end
