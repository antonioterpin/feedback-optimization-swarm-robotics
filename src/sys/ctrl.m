function dudt = ctrl(gamma, B, d, t, W, ODelta, y, u)
%CTRL Implements the feedback optimization controller
%   INPUT:
%       y       -- 2Nx1 positions of the agents [.., yix, yiy, ..].'
%       u       -- 2Nx1 Inputs
%       gamma   -- Gains of the cost function
%       B       -- Incidence matrix, the direction is specified implicitly
%                  through the cost function
%       d       -- 2size(B,2)x1 formation specification [.., dijx, dijy, ..].', 
%                  where the order of the edges is coherent with B
%       t       -- 2x1 target position
%       W       -- Number of obstacles detected by each agent
%       ODelta  -- Obstacle positions * Indicator matrix
%   OUTPUT:
%       dudt -- 2Nx1 gradient flow [.., duixdt, duiydt, ..].'

dudt = ...
    -gamma(1) * (kron(B*B.',eye(2)) * y - kron(B,eye(2)) * d) ...
    -gamma(2) * (y - repmat(t, numel(y) / 2, 1)) ...
    -gamma(3) * (W * y - ODelta);
end

