function x = denoise(y,u,v,lambda)

% In case of denoising the matrix H=I hence the closed form expression is obtained
dim = size(u,1);
one = ones(dim,1);
b_term= lambda*(v-u)-one;

x=b_term+abs((b_term.^2+4*lambda*y)).^0.5;
x=x/(2*lambda);


end