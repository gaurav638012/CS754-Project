function [rec,PSNR] = deblur(im_path,peak,kernel_type,verbose)
%DEBLUR Summary of this function goes here
%   Detailed explanation goes here
addpath(genpath(pwd));

if kernel_type == "gaussian"
    filter = fspecial('gaussian',[25 25],1.6);
elseif kernel_type == "average"
    filter = fspecial('average',[9 9]);
else
    filter = zeros(15);
    for i=-7:7
        for j=-7:7
           filter(i+8,j+8) = 1/(i*i + j*j + 1);
        end
    end
   filter = filter/sum(filter,'all');
end

img = im2double(rgb2gray(imread(im_path)));
figure('Name','Original');
imshow(img);

img = img*peak;
blurred_img = imfilter(img,filter);
y = poissrnd(blurred_img);

figure('Name','Noisy');
imshow(y/max(max(y)));

H = @(x) FilterFunc(x,filter,size(img));
beta = 0.6;
lambda = 440;
lambda_step = 1.065;
max_iter = 70;
epsilon = 1e-5;

rec = P4IP(y,beta,lambda,lambda_step,size(img),H,max_iter,epsilon,verbose);

figure('Name','Reconstruction');
imshow(rec / max(max(rec)));

fprintf("Noisy image PSNR: %f\n",getPSNR(y,img));
fprintf("Reconstructed image PSNR : %f\n",getPSNR(rec,img));

PSNR = getPSNR(rec,img);

end

