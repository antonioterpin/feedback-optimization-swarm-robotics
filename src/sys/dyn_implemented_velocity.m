function dxdt = dyn_implemented_velocity(x, u, na, nw)
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
delta = reshape(u,2,N) - states(1:2,:);
e = vecnorm(delta,2,1);
theta = atan2(delta(2,:), delta(1,:)) - states(3,:);
% theta(e < 1e-5) = 0;
ubar(1,:) = k(1) * e .* cos(theta);
% ubar(2,:) = -k(1)*cos(theta).*sin(theta) - k(2) * theta;

thetag = theta(theta >= 1e-3);
eg = e(theta >= 1e-3);
ubar(2,:) = (ubar(1,:) ./ e + e.^2).* sin(theta);
ubar(2,theta >= 1e-3) = (ubar(1,theta >= 1e-3) ./ eg + eg.^2 .* sin(thetag) ./ thetag) .* sin(thetag);


% input saturation
vel = max(velSat(1), min(velSat(2), ubar(1,:)));
angVel = ubar(2,:);

% dxdt
dir = [cos(states(3,:)); sin(states(3,:))];
dxdt = reshape([repmat(vel,2,1) .* dir; angVel], [], 1);
end

