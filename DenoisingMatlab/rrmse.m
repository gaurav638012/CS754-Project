function [val] = rrmse(im1,im2,flag)

%im2 is the img compared and im1 is the reference img

% flag=1 means the denominator is wrt to the new image which is compared to
% the original image note that in actual formula it must be wrt to img1 but
% for the stopping condition having this way removes dividing by zero
if flag==1
    val = sum((im1-im2).^2)/sum(im2.^2);
    val = sqrt(val);
    
% this is the original form of rrmse 
    
else
    val = sum((im1-im2).^2)/sum(im1.^2);
    val = sqrt(val);
   
end

