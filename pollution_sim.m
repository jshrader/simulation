function [] = pollution_sim(N,Y)
clear all;
% N is the number of individuals observed
N = 4;
% Y is the number of years observed
Y = 2;
% D is the number of days in the year
D = 10;
% T is the total time periods observed per person
T = Y*D;

% Preallocating output
id = sort(repmat((1:N)', 1, T));
date = repmat((1:T)', 1, N)';
year = repmat(sort(repmat((1:Y)', D, 1)), 1, N)';

eps_h = randn(N,T);
eps_w = randn(N,T);

%% Pollution model
% Everyone gets same pollution and it is exogenous
p = repmat(randn(T,1),1,N)';

%% Biological health model
% Infancy exposure matters and then recent exposure matter
h = zeros(N, T);
for i = 1:N;
    for t = 1:T;
        lags = min(4,t-1);
        h(i, t) = p(i, 1) + sum(p(i, (t-lags):t))  + eps_h(i, t);
    end
end


%% Labor market model
% Wage is a function of health and ability
a = randn(N, T);
w = h + a + eps_w;

%% Regressions
W = w(:);
A = a(:);
H = h(:);
X = [H A];
[b] = ols(W, X, 0, false);


for r = 1:lr;
    % Data generation
    y = zeros(T+1,N);
    a = randn(1,N);
    e = randn(1,N);
    u = randn(T+1,N);
    y(1,:) = rho0*a + e;
    for t = 2:T+1;
        y(t,:) = rho(r)*y(t-1,:) + a + u(t,:);
    end
    
    % Messing around with the data matrix
    x = y(1:(end-1),:);
    y = y(2:end,:);
    
    % Pooled OLS
    bpols(i,r) = x(:)\y(:);
    
    % Fixed Effects estimation
    yd = y - repmat(mean(y),T,1);
    xd = x - repmat(mean(x),T,1);
    bfe(i,r) = xd(:)\yd(:);
    
    % First Difference
    yfd = y(2:end,:) - y(1:(end-1),:);
    xfd = x(2:end,:) - x(1:(end-1),:);
    bfd(i,r) = xfd(:)\yfd(:);
    
    % Anderson-Hsiao (y(t-2) as instrument)
    z = reshape(x(1:end-1,:),[],1);
    bah(i,r) = (z'*yfd(:))/(z'*xfd(:));
    % Statistics about each estimator
    bias(r,1) = mean(bpols(:,r)) - rho(r);
    se(r,4) = sqrt(mean((bah(:,r) - mean(bah(:,r))).^2));
    rmse(r,1) = sqrt(bias(r,1)^2 + se(r,1)^2);
end;

end