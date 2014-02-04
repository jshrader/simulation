% Simulation exercise to understand the separating hyperplane theorem
% Jeff Shrader

%% Create points in two circles
clear
clc
Z = 2*rand(1000, 2) - 1;
Z = Z(Z(:,1).^2 + Z(:,2).^2 <= 1, 1:2);

K = 2*rand(1000, 2) + 2;
K = K((K(:,1) - 3).^2 + (K(:,2) - 3).^2 <= 1, 1:2);

scatter([Z(:,1); K(:,1)] , [Z(:,2); K(:,2)]);

%% Calculating dot products
for i = .3:.5:.8
    p = [-1 i];
    x = -1:1:3;
    y = -(p(1)/p(2))*x + ((p(1))^2)/p(2) + p(2);
    
    dotZ = Z*p';
    dotK = K*p';
    
    newplot
    hold on;
    scatter([Z(:,1); K(:,1)] , [Z(:,2); K(:,2)]);
    plot(x, y);
    scatter(p(1), p(2));
end
hold off;
mean(dotK)
    
%% Comparing dot products    
p = [-1 2];
dotZ2 = Z*p';
dotK2 = K*p';

newplot
hold on;
hist(dotZ2)
hist(dotK2)
hold off;

%% Finding polar
dotK = zeros(length(-2:.5:2)^2,3);
t = 1;
for i = -1:.5:3
    for j = -1:.5:3 
        p = [i j];
           
        dotK(t,:) = [min(K*p') p];
        t = t+1;
    end
end
[Y I] = sort(dotK(:,1));
dotK(I,:)

    
