function [x_res] = ADMM(y,lambda,v,u,x_0,H,verbose)
%ADMM Summary of this function goes here
%   Detailed explanation goes here
options = [];
options.display = 'none';
options.Method = 'lbfgs';

func = @(x) OptimFunc(x,y,v,u,H,lambda);

[x_res,~,~,output] = minFunc(func,x_0,options);
if verbose == 1
    disp(output)
end
end

