function [t_stat, F_stat] = t_f_stat(y, X, const)
% OLS function
% const = 1 or 0. If const = 1, then intercept is included


y = y(:);

[n, m] = size(X);

R = eye(m,m);

if const == 1
    X = [ones(n,1), X];
    m = m + 1;
    temp = eye(m);
    R = temp(2:end,:);
end

b = X\y;
u_hat = y - X*b;
XXi = (X'*X)\eye(m,m);
sigma2 = u_hat'*u_hat/(n-m);
vcov = sigma2*XXi;
r = zeros(m,1);

t_stat = b./sqrt(diag(vcov));
F_stat = ((R*b - r)'*((R*XXi*R')\(R*b - r))/m)/sigma2;



