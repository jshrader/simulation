function [t] = t_test(X,Y,beta_0)
% Just a t-test 
% If your data is multidimensional (in X) it will return multiple values.

Y = Y(:);
beta_hat = X\Y;
u = Y - beta_hat*X;
vcv = u*u';
t = (beta_hat - beta_0)/sqrt(vcv);

