function y = out_implemented(x)
dim = 5;
state = reshape(x,dim,[]);
y = reshape(state(1:2,:), [], 1);
end
