function [y] = FilterFunc(x,H,shape)
%FILTERFUNC Summary of this function goes here
%   Detailed explanation goes here
y = reshape(x,shape);
y = imfilter(y,H);
y = y(:);
end

