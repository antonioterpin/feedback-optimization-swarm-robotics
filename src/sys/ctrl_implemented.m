function dudt = ctrl_implemented(gamma, R, B, d, t, W, ODelta, y, u, params)
%CTRL Implements the feedback optimization controller
%   INPUT:
%       gamma   -- Gains of the cost function
%       R       -- Sensing radius
%       B       -- Incidence matrix, the direction is specified implicitly
%                  through the cost function
%       d       -- 2size(B,2)x1 formation specification [.., dijx, dijy, ..].', 
%                  where the order of the edges is coherent with B
%       t       -- 2x1 target position
%       W       -- Number of obstacles detected by each agent
%       ODelta  -- Obstacle positions * Indicator matrix
%       y       -- 2Nx1 positions of the agents [.., yix, yiy, ..].'
%       u       -- 2Nx1 Inputs
%       params  -- (1) obstacle avoidance on/off
%                  (2) agent avoidance on/off (on => params(2) > 0)
%                  (3) R / params(3) Safety distance from agents on
%                  (4) Visibility constraints between agents on
%                  (5) Connectivity radius R * params(5)
%   OUTPUT:
%       dudt -- 2Nx1 gradient flow [.., duixdt, duiydt, ..].'

% Rc = params(5) * R;
% z = kron(B.', eye(2)) * y - d;
% dist = vecnorm(reshape(z,2,[]));
% A = diag(kron((dist < Rc) .* (Rc^2 - dist.^2 + params(4)).^-1, [1,1]));

dudt = ...
	...gamma(1) * kron(B, eye(2)) * A * z ... % formation control with sensing radius
    -gamma(1) * (kron(B*B.',eye(2)) * y - kron(B.',eye(2)).' * d) ... % formation control, no sensing radius
    -gamma(2) * (y - repmat(t, numel(y) / 2, 1)); % Target tracking

if params(1) > 0 % Obstacle avoidance on/off
    dudt = dudt + gamma(3) * (diag(kron(W, [1,1])) * y - ODelta);
end

if params(2) > 0 % Safety distance from agents
    N = numel(y) / 2;
    diff = repmat(y, 1, N) - repmat(reshape(y,2,[]), N, 1);
    diff = [...
        reshape(diff(1:2:size(diff,1), :).', [], 1).';  % X
        reshape(diff(2:2:size(diff,1), :).', [], 1).']; % Y
    distances = vecnorm(diff);
    inverse = 1./(distances.^2 + params(2));
    Delta = reshape((distances < (R/params(3)) & distances > 0) .* inverse, [], 1);
    yDelta = kron(eye(N),reshape(y,2,[]).').'*Delta;
    Wy = sum(reshape(Delta, [], N));
    dudt = dudt + gamma(4) * (diag(kron(Wy, [1,1])) * y - yDelta);
end
end