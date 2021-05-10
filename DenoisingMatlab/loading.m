function [org_img,noised_img] = loading(filename,peak)
org_img = im2double(imread(filename));
org_img = rgb2gray(org_img);
noised_img=poissrnd(org_img*peak);

end

