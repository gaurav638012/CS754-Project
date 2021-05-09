addpath(genpath(pwd))
clear;
clc;
close all;

filter = fspecial('gaussian',[25 25],1.6);
%filter = fspecial('average',[9 9]);
%filter = custom TODO;
peak = 2;
img = im2double(rgb2gray(imread('images/pepper.png')));

blurred_img = imfilter(img,filter);

y = poissrnd(blurred_img*peak);
y = y / max(max(y));
imshow(y);

H = @(x) FilterFunc(x,filter,size(img));

beta = peak^-0.75;
lambda = peak^-1.5;
lambda_step = 1.065;
max_iter = 60;
epsilon = 1e-3;

rec = P4IP(y,beta,lambda,lambda_step,size(img),H,max_iter,epsilon);
rec = rec / max(max(rec));

imshow(rec)

fprintf("PSNR : %f\n",getPSNR(rec,img));
