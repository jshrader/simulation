% Comparing binary variables that don't overlap with a variable created by
% incrementing up 1 each time you start a new binary variable. I have
% worked out the analytics of this in my lab notebook pg. FICL 11-12 on
% 2013-07-02. 

clear all
nobs = 100;
nsims = 1000;
fb = 0.2;
gap = 0.2;

t = 1:nobs;

x1 = zeros(nobs,1);
x1(t > floor(fb*nobs) & t < floor((fb+gap)*nobs)) = 1;
x2 = zeros(nobs,1);
x2(t >= floor((fb+gap)*nobs)) = 1;
X = [x1 x2];
tau = zeros(nobs,1);
tau(x1 == 1) = 1;
tau(x2 == 1) = 2;

bh = zeros(nsims,4);
for i = 1:nsims
    e = random('Normal',0,1,nobs,1);
    y = 2*x1 + 3*x2 + e;

    bh(i,1:2) = ols(y, X, 0);
    bh(i,3:4) = [ols(y, tau, 0) 0];
end

mean(bh)
