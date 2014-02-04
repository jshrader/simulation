% Computation problem set 2
%
% Jeff Shrader
%
%% 1.a. Mock data testing of F-statistic
clear
clc
n = 1000;
m = 50;
nreplic = 1000;

% 1.a.i
y = randn(n, 1);
X = [ones(n,1), randn(n, m)];

% 1.a.ii
[tt, F] = ols(y, X, 0);

% 1.a.iii
sig1 = (F > icdf('F', 0.95, m, n-m-1));

% 1.a.iv
sigmat = zeros(nreplic,1);
for i = 1:1:nreplic 
    y = randn(n, 1);
    X = [ones(n,1), randn(n, m)];
    [tt2, F] = ols(y, X, 0);
    sigmat(i) = (F > icdf('F', 0.95, m, n-m-1));
end

% 1.a.iv
mean(sigmat)
% This value (around 0.05) is expected, because the F-test so composed is
% the appropriate test for this hypothesis, and the data is normally
% distributed.

%% 1.b Alternative procedure
% 1.b.i
y = randn(n, 1);
X = [ones(n,1), randn(n, m)];

% 1.b.ii
K = 10;

[t, F] = ols(y, X, 0);
[s, I] = sort(abs(t), 'descend');
Xk = X(:,I(1:K));

% 1.b.iii
[tk, Fk] = ols(y, Xk, 0);

% 1.b.iv
sig = (Fk > icdf('F', 0.95, K, n-K-1));

% 1.b.v
sigmat = zeros(nreplic,1);
for i = 1:1:nreplic 
    y = randn(n, 1);
    X = [ones(n,1), randn(n, m)];
    [t, F] = ols(y, X, 0);
    [s, I] = sort(abs(t), 'descend');
    Xk = X(:, I(1:K));
    [ttk, Fk] = ols(y, Xk, 0);
    sigmat(i) = (Fk > icdf('F', 0.95, K, n-K-1));
end

% 1.b.vi
mean(sigmat)
% It makes intuitive sense that if we keep the most significant regressors,
% then the F-test will rejected more often. It is somewhat surprising that
% random vectors can cause these results, but there is selection bias in
% the second regression.

%% 1.b.vi.b Building data for graph of rejection rate as function of K
K = 1:2:51;
msig = ones(length(K), 1);
for j = 1:1:length(K)
    sigmat = zeros(nreplic,1);
    for i = 1:1:nreplic 
        y = randn(n, 1);
        X = [ones(n,1), randn(n, m)];
        [t, F] = ols(y, X, 0);
        [s, I] = sort(abs(t), 'descend');
        Xk = X(:, I(1:K(j)));
        [ttk, Fk] = ols(y, Xk, 0);
        sigmat(i) = (Fk > icdf('F', 0.95, K(j), n-K(j)-1));
    end
    msig(j) = mean(sigmat);
end


plot(K, msig);
% The graph shows an interesting non-linearity where for very low levels of
% K, the rejection rate is slightly lower than at higher levels of K.
% Perhaps this is due to the high level of noise in such a small
% regression?

%% 2. Stock simulation 
clear;
clc;
P0 = 500;
T = 100;
u = 1.01;
d = 1/u;
p = (1 - d)/(u - d);
K = 550;


%% 2.i 1000 replications of stock price
nreplic = 1000;
VT = zeros(nreplic, 1);
VT1 = VT;

% I calculate two different series using related methods. I just wanted to
% make sure I understood the mechanics.
for i = 1:1:nreplic
    P = [P0; zeros(T, 1)];
    H = binornd(T, p);
    PT1 = P0*exp(H*log(u) + (T - H)*log(d));
    for t = 2:1:T+1
        if binornd(1, p) == 1
            P(t) = u*P(t - 1);
        else
            P(t) = d*P(t - 1);
        end
    end
    PT = P(end);
    VT1(i) = max(PT1 - K, 0);
    VT(i) = max(PT - K, 0);
end

%% 2.ii Percentage of time VT is positive
sum(VT > 0)/nreplic
sum(VT1 > 0)/nreplic

%% 2.iii Average value of VT
mean(VT)
mean(VT1)

%% 2.iv Effect of increase in u
% Lets just find out!
clear;
clc;
P0 = 500;
T = 100;
u = 1.02;
d = 1/u;
p = (1 - d)/(u - d);
K = 550;

nreplic = 1000;
VT = zeros(nreplic, 1);

for i = 1:1:nreplic
    H = binornd(T, p);
    PT = P0*exp(H*log(u) + (T - H)*log(d));
    VT(i) = max(PT - K, 0);
end

sum(VT>0)/nreplic
mean(VT)
% The price goes up! We might have expected this, except that an increase
% in u also decreases the probability of the good state.