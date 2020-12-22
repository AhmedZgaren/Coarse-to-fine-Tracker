%
%  1D Regression example
%
close all
clear all
tic
%-------------------creating and plotting data----------------
n=100;
x=linspace(0,5,n)';
xx=linspace(0,5,n)';
xi=x;
yi=cos(exp(x))+2;
y=cos(exp(xx))+2;

%----------------------Learning Parameters -------------------
C = 10;  lambda = 0.000001; 
epsilon = .1;
kerneloption = 0.1;
kernel='gaussian';
verbose=1;
[xsup,ysup,w,w0] = LPsvmreg(xi,yi,C,epsilon,lambda,kernel,kerneloption,verbose);

%---------------------Processing and plotting regression function--------

rx = svmval(xx,xsup,w,w0,kernel,kerneloption);
figure(1)
hold on;
plot(xx,y,'g');
h = plot(xx,rx,'b'); 
set(h,'LineWidth',2);
h = plot(xsup,ysup,'or'); 
set(h,'LineWidth',2);
plot(xx,rx+epsilon,'b--'); 
plot(xx,rx-epsilon,'b--'); hold off;
title('Support Vector Machine Regression');
xlabel('x');ylabel('y');
hold off

