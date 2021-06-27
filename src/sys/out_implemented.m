function y = out_implemented(x)
% Output of the system
%   INPUT:
%       x   -- 3Nx1 state of the agents
%   OUTPUT:
%       y   -- 2Nx1 positions of the agents

dim = 3;
state = reshape(x,dim,[]);
y = reshape(state(1:2,:), [], 1);
end
