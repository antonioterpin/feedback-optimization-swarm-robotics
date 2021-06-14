function dxdt = dyn_implemented_velocity(x, u)
%DYN Implements the plant dynamics
%   INPUT:
%       x -- 3Nx1 agents state
%       u -- 2Nx1 agents input

N = numel(x) / 3;
k = [.1, .1];
velSat = [-Inf, Inf];

% llc
ubar = zeros(2,N);
states = reshape(x,3,N);
delta = states(1:2,:) - reshape(u,2,N);
theta = pi + states(3,:) - atan2(delta(2,:), delta(1,:));
ubar(1,:) = k(1) * vecnorm(delta,2,1) .* cos(theta);
ubar(2,:) = -k(1)*cos(theta).*sin(theta) - k(2) * theta;

% input saturation
vel = max(velSat(1), min(velSat(2), ubar(1,:)));
angVel = ubar(2,:);

% dxdt
dir = [cos(states(3,:)); sin(states(3,:))];
dxdt = reshape([repmat(vel,2,1) .* dir; angVel], [], 1);
end

