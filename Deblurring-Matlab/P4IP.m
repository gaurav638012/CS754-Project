function [x] = P4IP(y,beta,lambda,lambda_step,shape,H,max_iter,epsilon) 
%P4IP Summary of this function goes here
%   Detailed explanation goes here
u = zeros(shape);
v = y;
x = y;

for k= 1:max_iter
    x_prev = x;
    u_prev = u;
    v_prev = v;
    temp_x = ADMM(y(:),lambda,v_prev(:),u_prev(:),x_prev(:),H);
    x = reshape(temp_x,shape);
    v = BM3D(x + u_prev,sqrt(beta/lambda));
    u = u_prev + x - v;
    
    lambda = lambda*lambda_step;
    
    fprintf("Iteration %d : RRMSE %f\n",k,rrmse(x_prev,x,1));
    if rrmse(x_prev,x,1) < epsilon
        fprintf("Breaking due to epsilon\n");
        break
    end
end
 
end

