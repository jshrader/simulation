%% Metrics 200C Problem Set 1 Code
%
tic
% Preliminaries
clear
clc
nsims = 1000;

%% 1. Panel data estimation with FE
%% 1.a: Running the simulation for initial N,T
N = 500;
T = 5;
beta = 1;
[bhat, s2hat, s2til] = fe_sim(N,T,nsims,beta);


% Results
%% 1.b: Distribution of bhat
disp('Comparing empirical distribution of beta_hat to standard error')
disp(['Empirical Std: ', num2str(std(bhat))])
disp(['s2hat Estimate: ', num2str(mean(s2hat))])
disp(['s2til Estimate: ', num2str(mean(s2til))])
disp(' ')

%% 1.c: Statistics of s2hat and s2til
disp('sigma_hat')
disp(['Std: ', num2str(std(s2hat))])
disp(['Bias: ', num2str(mean(s2hat)-std(bhat))])
disp(['RMSE: ', num2str(sqrt(std(s2hat)^2 + (mean(s2hat)-std(bhat))^2))])
disp(' ')
disp('sigma_tilde')
disp(['Std: ', num2str(std(s2til))])
disp(['Bias: ', num2str(mean(s2til)-std(bhat))])
disp(['RMSE: ', num2str(sqrt(std(s2til)^2 + (mean(s2til)-std(bhat))^2))])
disp(' ')
disp('On the basis of RMSE, sigma_hat is better.')
disp(' ')

%% 1.d: Repeating with T = 10, 20
disp('T = 10')
T = 10;
[bhat, s2hat, s2til] = fe_sim(N,T,nsims,beta);
disp(['Empirical Std: ', num2str(std(bhat))])
disp('sigma_hat')
disp(['Std: ', num2str(std(s2hat))])
disp(['Bias: ', num2str(mean(s2hat)-std(bhat))])
disp(['RMSE: ', num2str(sqrt(std(s2hat)^2 + (mean(s2hat)-std(bhat))^2))])
disp(' ')
disp('sigma_tilde')
disp(['Std: ', num2str(std(s2til))])
disp(['Bias: ', num2str(mean(s2til)-std(bhat))])
disp(['RMSE: ', num2str(sqrt(std(s2til)^2 + (mean(s2til)-std(bhat))^2))])
disp(' ')

disp('T = 20')
T = 20;
[bhat, s2hat, s2til] = fe_sim(N,T,nsims,beta);
disp(['Empirical Std: ', num2str(std(bhat))])
disp('sigma_hat')
disp(['Std: ', num2str(std(s2hat))])
disp(['Bias: ', num2str(mean(s2hat)-std(bhat))])
disp(['RMSE: ', num2str(sqrt(std(s2hat)^2 + (mean(s2hat)-std(bhat))^2))])
disp(' ')
disp('sigma_tilde')
disp(['Std: ', num2str(std(s2til))])
disp(['Bias: ', num2str(mean(s2til)-std(bhat))])
disp(['RMSE: ', num2str(sqrt(std(s2til)^2 + (mean(s2til)-std(bhat))^2))])
disp(' ')

disp('T = 40')
T = 40;
[bhat, s2hat, s2til] = fe_sim(N,T,nsims,beta);
disp(['Empirical Std: ', num2str(std(bhat))])
disp('sigma_hat')
disp(['Std: ', num2str(std(s2hat))])
disp(['Bias: ', num2str(mean(s2hat)-std(bhat))])
disp(['RMSE: ', num2str(sqrt(std(s2hat)^2 + (mean(s2hat)-std(bhat))^2))])
disp(' ')
disp('sigma_tilde')
disp(['Std: ', num2str(std(s2til))])
disp(['Bias: ', num2str(mean(s2til)-std(bhat))])
disp(['RMSE: ', num2str(sqrt(std(s2til)^2 + (mean(s2til)-std(bhat))^2))])
disp(' ')
disp('As T increases, sigma_tilde becomes a better estimate from a RMSE perspective')
disp(' ')

%% 1.e: Theory for the switch
disp('See the pdf with write-up')

%% 1.f: beta = pi*100
beta = pi*100;
T = 5;
[bhat, s2hat, s2til] = fe_sim(N,T,nsims,beta);
disp(['Empirical Std: ', num2str(std(bhat))])
disp('sigma_hat')
disp(['Std: ', num2str(std(s2hat))])
disp(['Bias: ', num2str(mean(s2hat)-std(bhat))])
disp(['RMSE: ', num2str(sqrt(std(s2hat)^2 + (mean(s2hat)-std(bhat))^2))])
disp(' ')
disp('sigma_tilde')
disp(['Std: ', num2str(std(s2til))])
disp(['Bias: ', num2str(mean(s2til)-std(bhat))])
disp(['RMSE: ', num2str(sqrt(std(s2til)^2 + (mean(s2til)-std(bhat))^2))])
disp(' ')
disp('As you can see, changing beta has no effect. We would expect this to be the case.')

toc