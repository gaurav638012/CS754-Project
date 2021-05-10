addpath(genpath(pwd))
clear;
clc;
close all;

filter = fspecial('gaussian',[25 25],1.6);
%filter = fspecial('average',[9 9]);
%filter = custom TODO;
peak = 1;
img = im2double(rgb2gray(imread('images/ridges.png')));
figure('Name','Original');
imshow(img);

blurred_img = imfilter(img,filter);
y = poissrnd(blurred_img*peak);
y = y / max(max(y));

figure('Name','Noisy');
imshow(y);

H = @(x) FilterFunc(x,filter,size(img));
lambda_step = 1.065;
max_iter = 75;
epsilon = 1e-7;
verbose = 0;

beta = peak^-0.75;

y_vals = zeros(9,1);
x_vals = linspace(290,450,10); %% Or logspace for rough tuning
i = 1;
for lambda = x_vals
    fprintf("Lambda = %f\n",lambda);
    rec = P4IP(y,beta,lambda,lambda_step,size(img),H,max_iter,epsilon,verbose);
    rec = rec / max(max(rec));
    figure('Name',sprintf('Reconstruction at lambda = %f',lambda));
    imshow(rec);

    fprintf("Noisy image PSNR: %f\n",getPSNR(y,img));
    fprintf("Reconstructed image PSNR: %f\n",getPSNR(rec,img));
    y_vals(i) = getPSNR(rec,img);
    fprintf("====================================\n");
    i = i + 1;
end

figure('Name','Lambda Tuning');
plot(x_vals,y_vals);
%set(gca,'XScale','log'); %If logspace is used uncomment this
