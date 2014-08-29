clc;
nsims = 1000;
b1h = zeros(nsims,1);
b1h2 = b1h;
for i = 1:nsims;
    nobs = 500;
    e = randn(nobs,1);
    v = randn(nobs,1);
    inst = randn(nobs,1);
    %z = randn(nobs,1);
    x = randn(nobs,1);
    z = x;
    a1 = 0.15;
    a2 = 1;
    b2 = 1;
    b1 = -1.3;
    w = (1/(1 - a1*b1)).*(a1*b2.*z + a1.*v + a1.*inst + a2.*x + e);
    %tst = (1/(1 - a1*b1)).*(a2*b1.*x + b1.*e + b2.*z + v + inst);
    ts = b1.*w + b2.*z + v + inst;
    bols = ols(w, [ts x], 1, 1);
    %iv(w,[tst x],z)
    biv = iv(w,[ones(nobs,1) ts x],[ones(nobs,1) inst x]);

    % Calculate b1
    eh = w - a1.*ts - a2.*x;
    wr = w - a2.*x;
    
    Eweh = ols(wr, eh, 0, 0);
    bs = ols(ts, x, 1, 0);
    rh = ts - bs(1) - bs(2).*x;
    varTs = var(rh);
    b1h(i) = (bols(2) - biv(2)).*(varTs/mean(Eweh));
    Eweh2 = ols(w, eh, 0, 0);
    b1h2(i) = (bols(2) - biv(2)).*(varTs/mean(Eweh2));
end;

mean(b1h)
mean(b1h2)
