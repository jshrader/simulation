%% Program to investigate properties of dynamic panel data estimators for
% Metrics 220C Problem Set 2.
%
% Jeff Shrader
% 2012-05-04
%% Preliminaries
clear -a;
clc;
close all;

nsims=100;

%% (a) Bias, SE, RMSE of estimators as function of rho
% Parameters
N=100;
T=6;
rho=0:0.1:1;
rho0=0.5;
[rols,rfe,rfd,rah,bias,se,rmse] = dynamic_panel_sim(N,T,rho,rho0,nsims);

% Graphs of bias, se, and rmse
figure(100);
subplot(2,2,1)
H1 = plot(rho, bias);
xlabel ('\rho'); 
ylabel ('Bias');
%set(H1, 'linewidth', 2,'markersize', 4);
%set(H2, 'fontsize', 12)

subplot(2,2,2)
H2 = plot(rho, se);
xlabel ('\rho'); 
ylabel ('SE');

subplot(2,2,3)
H3 = plot(rho, rmse);
legend('pols','fe','fd','ah','location','eastoutside');
%pos = get(H, 'position');
%set(H, 'position',[0.8 0.5 pos(3:4)])

%title(['RMSE of Different Estimators,' ' N = ' num2str(N) ', T = ' num2str(T)]);
xlabel ('\rho'); 
ylabel ('RMSE');


% Histogram of estimators against normal for rho=0.7

figure(101);
subplot(2,2,1)
histfit(rols(:,8));
%[freq, bins] = hist(rols(:,8));
%bar(bins, freq/sum(freq));
%hold on;
%x = (min(rols(:,8)):0.001:max(rols(:,8)))';
%plot(x, normpdf(x,mean(rols(:,8)),std(rols(:,8))));
%hold off;

subplot(2,2,2)
histfit(rfe(:,8));
%[freq, bins] = hist(rfe(:,8));
%bar(bins, freq/sum(freq));
%hold on;
%x = (min(rfe(:,8)):0.001:max(rfe(:,8)))';
%plot(x, normpdf(x,mean(rfe(:,8)),std(rfe(:,8))));
%hold off;

subplot(2,2,3)
histfit(rfd(:,8));
%[freq, bins] = hist(rfd(:,8));
%bar(bins, freq/sum(freq));
%hold on;
%x = (min(rfd(:,8)):0.001:max(rfd(:,8)))';
%plot(x, normpdf(x,mean(rfd(:,8)),std(rfd(:,8))));
%hold off;

subplot(2,2,4)
histfit(rah(:,8));
%[freq, bins] = hist(rah(:,8));
%bar(bins, freq/sum(freq));
%hold on;
%x = (min(rah(:,8)):0.001:max(rah(:,8)))';
%plot(x, normpdf(x,mean(rah(:,8)),std(rah(:,8))));
%hold off;
