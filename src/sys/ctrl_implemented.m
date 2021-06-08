function dudt = ctrl_implemented(gamma, B, d, t, W, ODelta, y, u, params)
%CTRL Implements the feedback optimization controller
%   INPUT:
%       gamma   -- Gains of the cost function
%       B       -- Incidence matrix, the direction is specified implicitly
%                  through the cost function
%       d       -- 2size(B,2)x1 formation specification [.., dijx, dijy, ..].', 
%                  where the order of the edges is coherent with B
%       t       -- 2x1 target position
%       W       -- Number of obstacles detected by each agent
%       ODelta  -- Obstacle positions * Indicator matrix
%       y       -- 2Nx1 positions of the agents [.., yix, yiy, ..].'
%       u       -- 2Nx1 Inputs
%   OUTPUT:
%       dudt -- 2Nx1 gradient flow [.., duixdt, duiydt, ..].'

dudt = ...
    -gamma(1) * (kron(B*B.',eye(2)) * y - kron(B.',eye(2)).' * d) ...
    -gamma(2) * (y - repmat(t, numel(y) / 2, 1));

if params(1) % obstacle_avoidance on/off
    dudt = dudt + +gamma(3) * (diag(kron(W, [1,1])) * y - ODelta);
end
end