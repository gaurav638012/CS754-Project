clear;
close all;
clc;

str = "kernel,image,peak,PSNR\n";

for kernel_type = ["gaussian","average","custom"]
    for image = ["pepper","sat","cameraman","ridges","house","curve"]
        for peak = [1]
            [rec, PSNR] = deblur(sprintf("images/%s.png",image),peak,kernel_type,0);
            str = str + sprintf("%s,%s,%d,%f\n",kernel_type,image,peak,PSNR);
        end
    end
end

fprintf(str);