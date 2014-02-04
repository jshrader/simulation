function [bhat,s2hat,s2til] = fe_sim(N,T,nsims,beta)

% Preallocating output
bhat = zeros(nsims,1);
s2hat = zeros(nsims,1);
s2til = zeros(nsims,1);

for i = 1:nsims;
    % Data generation
    x = randn(T,N);
    u = randn(T,N).*abs(x);
    y = x.*beta + u;

    %xVec = x(:);
    %uVec = u(:);
    %yVec = y(:);

    % Fixed Effects estimation
    %J = ones(T,T)./T;
    %P = kron(eye(N),J);
    %Q = eye(N*T) - P;
    %bhat(i) = (xVec'*Q*xVec)\(xVec'*Q*yVec);
    % Adopting your demeaning method which is much faster:
    yd = y - repmat(mean(y),T,1);
    xd = x - repmat(mean(x),T,1);
    yVec = yd';
    xVec = xd';
    xVec = xVec(:);
    yVec = yVec(:);
    bhat(i) = xVec\yVec;
    
    % Standard error calculation
    uhat = yd - xd.*bhat(i);
    Sxx = xVec'*xVec;
    s2hat(i) = sqrt(Sxx^(-2)*sum((sum(xd.*uhat).^2)));
    s2til(i) = sqrt(Sxx^(-2)*sum(sum((xd.^2).*(uhat.^2))));
end;

end