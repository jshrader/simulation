%% Step 5: How deep can we go?
clear;
tic;
nsims = 500;

N = 200;

beta = 1;
gamma = 1;

b = zeros(nsims,1); se = b; bu=b; seu=se; bl=b; sel=se;
g = b; seg = b;
for i = 1:nsims;
    x = rand(N,1);
    e = randn(N,1);
    v = e + randn(N,1);
    %e = rand(N,1)*3;
    y = beta.*x + v;
    z = gamma.*y + e;
    
    [b1, se1] = ols(y,x,0,1);
    yh = b1.*x;
    [b(i), se(i)] = ols(z,yh,0,1);
    [bu(i), seu(i)] = ols(z,yhu,0,1);
    [bl(i), sel(i)] = ols(z,yhl,0,1);
    [g(i), seg(i)] = iv(z,y,x);
end

fprintf('"Bootstrap" 95pct\n')
quantile(b(:,1),.975)
quantile(b(:,1),.025)
fprintf('Analytical 95pct\n')
mean(g + 1.96*seg)
mean(g - 1.96*seg)


toc;



%% Step 4: if you bootstrap the first stage, do you get correct inference 
% on the second stage?
clear;
tic;
nsims = 5000;

N = 200;

beta = -1;
gamma = 10;

b = zeros(nsims,1); se = b; bu=b; seu=se; bl=b; sel=se;
g = b; seg = b;
for i = 1:nsims;
    x = rand(N,1);
    e = randn(N,1);
    v = e + randn(N,1);
    %e = rand(N,1)*3;
    y = beta.*x + v;
    z = gamma.*y + e;
    
    [b1, se1] = ols(y,x,0,1);
    yh = b1.*x;
    yhu = (b1+.1*se1).*x;
    yhl = (b1-.1*se1).*x;
    [b(i), se(i)] = ols(z,yh,0,1);
    [bu(i), seu(i)] = ols(z,yhu,0,1);
    [bl(i), sel(i)] = ols(z,yhl,0,1);
    [g(i), seg(i)] = iv(z,y,x);
end

fprintf('"Bootstrap" 95pct\n')
quantile(b(:,1),.975)
quantile(b(:,1),.025)
fprintf('Analytical 95pct\n')
mean(g + 1.96*seg)
mean(g - 1.96*seg)
fprintf('Feeding SEs\n')
median(bu)
median(bl)


toc;


%% Step 3: Does it matter if we create choice set using SEs or simulation
clear;
tic;
nsims = 1;
% Number of times to draw the choice set
nu = 1000;

N = 1000;
beta = 1;

b = zeros(nsims,2); se = b;
avg_exit = zeros(nu,1); u_exit=avg_exit; l_exit=avg_exit;
for i = 1:nsims;
    x = rand(N,1);
    %e = randn(N,1);
    e = zeros(N,1);
    %e = rand(N,1)*3;
    y = beta.*x + e;
    
    [b(i,:), se(i,:)] = ols(y,x,1,1);
    yhat = b(i,1) + b(i,2).*x;
    
    % SE method
    % From step 1, SE should be 0.1094 in this case
    yhu = b(i,1) + (b(i,2) + 1.96*0.1094).*x;
    yhl = b(i,1) + (b(i,2) - 1.96*0.1094).*x;
    mean_exit = logical(yhat>.5);
    u2_exit = logical(yhu>.5);
    l2_exit = logical(yhl>.5);
    
    % Determine if the vessel will exit
    % Simulation method
    for j = 1:nu;
        u = rand(N,1);
        
        exit = logical(yhat>u);
        avg_exit(j,:) = mean(exit);
        exit = logical(yhu>u);
        u_exit(j,:) = mean(exit);
        exit = logical(yhl>u);
        l_exit(j,:) = mean(exit);
    end;
    

    
end

mean(avg_exit)
std(avg_exit)
mean(u_exit)
mean(l_exit)
mean(mean_exit)
mean(u2_exit)
mean(l2_exit)





toc;





%% Step 2: Can we feed the SEs from equation 1 into equation 2





%% Step 1: Does the simulation contain the same information as the SEs?
clear;
tic;
nsims = 2000;

N = 1000;

beta = 1;

b = zeros(nsims,2); se = b;
for i = 1:nsims;
    x = rand(N,1);
    e = randn(N,1);
    %e = rand(N,1)*3;
    y = beta.*x + e;
    
    [b(i,:), se(i,:)] = ols(y,x,1,1);
end

quantile(abs(b(:,2)-beta),.95)
temp = mean(se(:,2));
2.*temp %#ok
%So, the distribution of coefficients contains the same
% information as the standard errors. 

toc;