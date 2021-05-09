function [f,g] = OptimFunc(x,y,v,u,H,lamda)
%OPTIMFUNC Summary of this function goes here
%   Detailed explanation goes here
Hx = H(x);
f = -(y')*NNlog(Hx) + sum(Hx,'all') + lamda*(norm(x-v+u)^2)/2;
g = -H((y./Hx) -1) + lamda*(x -v +u);
end

