function [bpols,bfe,bfd,bah,bias,se,rmse] = dynamic_panel_sim(N,T,rho,rho0,nsims)

% Preallocating output
lr = length(rho);
bpols = zeros(nsims,lr);
bfe = zeros(nsims,lr);
bfd = zeros(nsims,lr);
bah = zeros(nsims,lr);
bias = zeros(lr,4);
se = bias;
se2 = bias;
rmse = bias;

for r = 1:lr;
    for i = 1:nsims;
        % Data generation
        y = zeros(T+1,N);
        a = randn(1,N);
        e = randn(1,N);
        u = randn(T+1,N);
        y(1,:) = rho0*a + e;
        for t = 2:T+1;
            y(t,:) = rho(r)*y(t-1,:) + a + u(t,:);
        end

        % Messing around with the data matrix
        x = y(1:(end-1),:);
        y = y(2:end,:);
      
        % Pooled OLS
        bpols(i,r) = x(:)\y(:);

        % Fixed Effects estimation
        yd = y - repmat(mean(y),T,1);
        xd = x - repmat(mean(x),T,1);
        bfe(i,r) = xd(:)\yd(:);

        % First Difference
        yfd = y(2:end,:) - y(1:(end-1),:);
        xfd = x(2:end,:) - x(1:(end-1),:);
        bfd(i,r) = xfd(:)\yfd(:);
        
        % Anderson-Hsiao (y(t-2) as instrument)
    	z = reshape(x(1:end-1,:),[],1);
        bah(i,r) = (z'*yfd(:))/(z'*xfd(:));
    end;
    % Statistics about each estimator
    bias(r,1) = mean(bpols(:,r)) - rho(r);
    bias(r,2) = mean(bfe(:,r)) - rho(r);
    bias(r,3) = mean(bfd(:,r)) - rho(r);
    bias(r,4) = mean(bah(:,r)) - rho(r);

    se(r,1) = sqrt(mean((bpols(:,r) - mean(bpols(:,r))).^2));
    se(r,2) = sqrt(mean((bfe(:,r) - mean(bfe(:,r))).^2));
    se(r,3) = sqrt(mean((bfd(:,r) - mean(bfd(:,r))).^2));
    se(r,4) = sqrt(mean((bah(:,r) - mean(bah(:,r))).^2));

    %se2(r,1) = std(bpols(:,r));
    %se2(r,2) = std(bfe(:,r));
    %se2(r,3) = std(bfd(:,r));
    %se2(r,4) = std(bah(:,r));

    rmse(r,1) = sqrt(bias(r,1)^2 + se(r,1)^2);
    rmse(r,2) = sqrt(bias(r,2)^2 + se(r,2)^2);
    rmse(r,3) = sqrt(bias(r,3)^2 + se(r,3)^2);
    rmse(r,4) = sqrt(bias(r,4)^2 + se(r,4)^2);
end;

end
