function [denoised_img] = P4IP(y,beta,lambda,u_0,v_0,epsilon,siz)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
addpath(genpath('./bm3d'));
u=u_0;v=v_0;
temp=zeros(size(u_0));
k=0;
while 1
    
    x_temp=denoise(y,u,v,lambda);
    v= BM3D(reshape(x_temp+u,siz),sqrt(beta/lambda));
    v=reshape(v,size(u_0));
    u=u+x_temp-v;
    
    if ((rrmse(temp,x_temp,1) < epsilon) && k>=1) || (k>=50)
        fprintf("Printing the rrmse while breaking the algo");
        disp(rrmse(temp,x_temp,1));
        break;
    end
    
    temp=x_temp;
    k=k+1;
    
end
denoised_img=temp;
end

