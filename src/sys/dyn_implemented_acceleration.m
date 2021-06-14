function dxdt = dyn_implemented_acceleration(x, u)
%DYN Implements the plant dynamics
%   INPUT:
%       x -- 5Nx1 agents state (position; angle; speed; angular speed)
%       u -- 2Nx1 agents input (desired position)
%   TODO: we can use the input to steer agents away from the obstacles
dim = 5;
p = 2;
N = numel(x) / dim;
k = [.1, .3];
kp = 2*eye(2);
accSat = [-Inf, Inf];

% llc
vbar = zeros(2,N);
states = reshape(x,dim,N);
delta = states(1:2,:) - reshape(u,p,N);
theta = pi + states(3,:) - atan2(delta(2,:), delta(1,:));
vbar(1,:) = k(1) * vecnorm(delta,2,1) .* cos(theta);
vbar(2,:) = -k(1)*cos(theta).*sin(theta)-k(2) * theta;
ubar = kp * (vbar - states(4:5, :));

% input saturation
av = max(accSat(1), min(accSat(2), ubar(1,:)));
aw = ubar(2,:);

% dxdt
dir = [cos(states(3,:)); sin(states(3,:))];
dxdt = reshape([repmat(states(4,:),2,1) .* dir; states(5,:); av; aw], [], 1);
end

