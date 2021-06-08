function dxdt = dyn(x, u)
%DYN Implements the plant dynamics
%   INPUT:
%       x -- 3Nx1 agents state
%       u -- 2Nx1 agents input

N = numel(x) / 3;
k = [.1, -.1];
velSat = [-.1, .1];

% llc
ubar = zeros(2,N);
states = reshape(x,3,N);
delta = reshape(u,2,N) - states(1:2,:);
if any(delta ~= 0)
    theta = states(3,:) - atan2(delta(2,:), delta(1,:));
    ubar(1,:) = k(1) * vecnorm(delta,2,1) .* cos(theta);
    ubar(2,:) = -k(2) * theta;
end

% input saturation
vel = max(velSat(1), min(velSat(2), ubar(1,:)));
angVel = ubar(2,:);

% dxdt
dir = [cos(states(3,:)); sin(states(3,:))];
dxdt = reshape([repmat(vel,2,1) .* dir; angVel], [], 1);
end

