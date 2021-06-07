function [Delta,W] = obst(y,O,R)
%OBST Implements the obstacles indicator matrix
%   INPUT:
%       y       -- 2Nx1 agents positions
%       O       -- 2xO obstacle positions
%       R       -- sensing radius
%   OUTPUT:
%       Delta   -- 2NOx1 obstacle indicator matrix 
%       W       -- Nx1 number of obstacles for each agent
Delta = (vecnorm(reshape(y - repmat(O, numel(y) / 2, 1), 2, []), 2, 1) < R).';
W = sum(reshape(Delta, size(O,1), []), 2);
end

