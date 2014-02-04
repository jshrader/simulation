clear all;
% T is the number of time periods observed
T = 100;

e = randn(T,1);
rho0 = 0.5;
a = 1;
rho = 0.7;

%% AR(p)
nsims = 1000;
lags = 2;
b = zeros(nsims,lags+1);
b_smooth = zeros(nsims,2);

for n = 1:nsims;
    % Data generation
    x = zeros(T+1,1);
    x(1,:) = rho0 + a;
    for t = 1:T;
        x((t+1),:) = rho*x(t,:) + a + e(t,:);
    end
    
    % Estimation
    ytrunc = x((lags+1):(T+1));
    X = ones(length(ytrunc), lags+1);
    
    for t = 1:lags;
        X(:,t+1) = x((lags-t+1):(T-t+1),:);
    end
    Xs = [X(:,1), sum(X(:,2:lags+1),2)];
    
    b(n,:) = ols(ytrunc, X, 0, false);
    b_smooth(n,:) = ols(ytrunc, Xs, 0, false);
end

% Postestimation
fprintf('Estimate averages\n')
mean(b)
mean((b(:,2) + b(:,3))/2)
mean(b_smooth)


%% Auto-correlated Regressors
nsims = 3000;
lags = 2;
b = zeros(nsims,lags+1);
b_smooth = zeros(nsims,2);


for n = 1:nsims;
    % Data generation
    x = zeros(T+1,1);
    x(1,:) = rho0 + a;
    for t = 1:T;
        x((t+1),:) = rho*x(t,:) + a + e(t,:);
    end
    
    % Estimation
    L = length((lags+1):(T+1));
    ytrunc = 2*x((lags+1):(T+1),:) + randn(L,1);
    X = ones(L, lags+1);
    
    for t = 1:lags;
        X(:,t+1) = x((lags-t+1):(T-t+1),:);
    end
    Xs = [X(:,1), sum(X(:,2:lags+1),2)];
    
    b(n,:) = ols(ytrunc, X, 0, false);
    b_smooth(n,:) = ols(ytrunc, Xs, 0, false);
end

% Postestimation
fprintf('Estimate averages\n')
mean(b)
mean((b(:,2) + b(:,3))/2)
mean(b_smooth)