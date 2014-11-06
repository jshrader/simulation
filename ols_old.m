function [beta_hat, se, t_stat, w_stat, vcov, sigma2, u_hat] = ols_old(y, X, const, robust)
% OLS function
% const = 1 or 0. If const = 1, then intercept is included
%{
rng(1);   
X = randn(100, 5);
beta = zeros(5,1);
y = X*beta+randn(100,1);
const = 1;
%}

y = y(:);

[n, m] = size(X);

R = eye(m,m);

if const == 1
    X = [ones(n,1), X];
    m = m + 1;
    temp = eye(m);
    R = temp(2:end,:);
end

beta_hat = X\y;
u_hat =y - X*beta_hat;
XXi = (X'*X)\eye(m,m);
sigma2 = u_hat'*u_hat/(n-m);

if robust == false
    vcov = sigma2*XXi;
else
    vcov = XXi*(X'*diag(u_hat.^2)*X)/(X'*X);    
end

se = sqrt(diag(vcov));
t_stat = beta_hat./se;
w_stat = (R*beta_hat)'*((R*vcov*R')\(R*beta_hat));

