clear;
tic;
nsims = 500;

N = 2000;

beta = 1;
gamma = 1;

b = zeros(nsims,2); se = b; t = b;
for i = 1:nsims;
    %w = abs(randn(N,1));
    w = randn(N,1);
    e = randn(N,1);
    %e = zeros(N,1);
    
    % h is hours of work
    %h = randn(N,1);
    h = 1.*ones(N,1);
    y = w.*h + e;
    g = logical(w(1:(N-1),:) < 0);
    g = +g;
    
    [b(i,:), se(i,:), t(i,:)] = ols(y(2:N,:), g, 1, 1);
    
end;

fprintf('Results\n')
mean(b)
mean(se)
fprintf('"Bootstrap" 95pct\n')
quantile(abs(t(:,1)),.95)
