%% 2
clear
clc
nout = 10000;
stdo = zeros(nout, 3);
for j = 1:1:nout
    nsims = 10;
    output = zeros(nsims,3);
    for i = 1:1:nsims
        y = 2.*randn(100,1);
        S = 100\sum(y.^2);
        lnS = log(100\sum(y.^2));
        S2 = (100\sum(y.^2))^2;
        output(i,2) = lnS;
        output(i,1) = S;
        output(i,3) = S2;
    end
    mean(output(:,1) > 5);
    mean(output(:,2) > log(5));
    mean(output(:,3) > 25);
    stdo(j,1) = std(10*(output(:,1) - 4))^2;
    stdo(j,2) = std(10*(log(output(:,1)) - log(4)))^2;
    stdo(j,3) = std(100*(output(:,1) - 4).^2)^2;
end
mean(stdo(:,1))
mean(stdo(:,2))
mean(stdo(:,3))


%% 4
nsims = 1000000;
output = zeros(nsims,1);
for i = 1:1:nsims
    y = 2.*randn(100,1);
    
end
mean(output > log(5))


%% 6
nsims = 1000000;
output = zeros(nsims,1);
for i = 1:1:nsims
    y = 2.*randn(100,1);
    
    output(i) = S2;
end
mean(output > 25)