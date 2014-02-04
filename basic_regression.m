clear
X = random(makedist('Normal',0,1),[100,1]);
Z = random(makedist('Normal',0,2),[100,1]);
e = random(makedist('Normal',0,1),[100,1]);

yx = X + e;
yz = Z + e;

%% Regressions
[bx, tx, wx, vcvx, sigmax, uhx] = ols(yx, X, 0);
[bz, tz, wz, vcvz, sigmaz, uhz] = ols(yz, Z, 0);

u = yx - bx*X;
t_check = bx/sqrt((X'*X)\(99\u'*u));
