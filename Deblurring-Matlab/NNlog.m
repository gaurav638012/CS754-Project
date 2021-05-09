function [z] = NNlog(x)
%NNLOG Summary of this function goes here
%   Detailed explanation goes here
z = x;
e = 1e-10;
a = -0.5 / (e^2);
b = 2 / e;
c = log(e) - 1.5;

z(x>=e) = log(x(x>=e));
z(x<e) = a*(x(x<e).^2) + b*x(x<e) + c;
end

