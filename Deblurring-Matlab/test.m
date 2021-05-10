addpath(genpath(pwd))
clear;
clc;
close all;

filter = fspecial('gaussian',[25 25],1.6);
%filter = fspecial('average',[9 9]);
%%%%Custom filter%%%%%%%
%filter = zeros(15);
%for i=-7:7
%    for j=-7:7
%        filter(i+8,j+8) = 1/(i*i + j*j + 1);
%    end
%end
%filter = filter/sum(filter,'all');
%%%%%%%%%%%%%%%%%%%%%%%%
peak = 1;
img = im2double(rgb2gray(imread('images/ridges.png')));
figure('Name','Original');
imshow(img);

blurred_img = imfilter(img,filter);
y = poissrnd(blurred_img*peak);

figure('Name','Noisy');
imshow(y/max(max(y)));

H = @(x) FilterFunc(x,filter,size(img));
beta = 0.6;
lambda = 440;
lambda_step = 1.065;
max_iter = 70;
epsilon = 1e-5;
verbose = 1;

rec = P4IP(y,beta,lambda,lambda_step,size(img),H,max_iter,epsilon,verbose);

figure('Name','Reconstruction');
imshow(rec/max(max(rec)));

fprintf("Noisy image PSNR: %f\n",getPSNR(y,img));
fprintf("Reconstructed image PSNR: %f\n",getPSNR(rec,img));
