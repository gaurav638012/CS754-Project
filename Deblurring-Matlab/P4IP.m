function [x] = P4IP(y,beta,lambda,lambda_step,shape,H,max_iter,epsilon,verbose) 
%P4IP Summary of this function goes here
%   Detailed explanation goes here
u = zeros(shape);
nnn = 0.002*randn(size(y));
x = reshape(H(reshape(H(y),shape) + nnn.*(nnn>=0)),shape);
x = x;

v = x;

figure("Name","Initial guess");
imshow(x/max(max(x)));

for k= 1:max_iter
    x_prev = x;
    u_prev = u;
    v_prev = v;
    temp_x = ADMM(y(:),lambda,v_prev(:),u_prev(:),x_prev(:),H,verbose);
    x = reshape(temp_x,shape);
    v = BM3D(x + u_prev,sqrt(beta/lambda),'np',BM3DProfile.ALL_STAGES);
    u = u_prev + x - v;
    
    lambda = lambda*lambda_step;
    
    if verbose == 1 || rem(k,10) == 0
        fprintf("Iteration %d : RRMSE %f\n",k,rrmse(x_prev,x,1));
    end

    if rrmse(x_prev,x,1) < epsilon
        fprintf("Breaking due to epsilon\n");
        break
    end
end
 
end

