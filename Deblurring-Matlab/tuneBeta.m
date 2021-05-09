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
lambda_vals = linspace(450,440,2);

x_vals = [0.5 0.6 0.7 0.9 1 1.2]; %% Or logspace for tuning
y_vals = zeros(length(x_vals),length(lambda_vals)   );
j = 1;
for lambda = lambda_vals
    i = 1;
    for beta = x_vals
        fprintf("Lambda = %f Beta = %f\n",lambda,beta);
        rec = P4IP(y,beta,lambda,lambda_step,size(img),H,max_iter,epsilon,verbose);
        rec = rec / max(max(rec));
        figure('Name',sprintf('Reconstruction at lambda = %f beta = %f',lambda,beta));
        imshow(rec);

        fprintf("Noisy image PSNR: %f\n",getPSNR(y,img));
        fprintf("Reconstructed image PSNR: %f\n",getPSNR(rec,img));
        y_vals(i,j) = getPSNR(rec,img);
        fprintf("====================================\n");
        i = i + 1;
    end
    j = j + 1;
end

for i = 1:length(lambda_vals)
    figure('Name',sprintf('Beta Tuning for lambda = %f',lambda_vals(i)));
    plot(x_vals,y_vals(:,i));
    %set(gca,'XScale','log'); %If logspace is used uncomment this
end
