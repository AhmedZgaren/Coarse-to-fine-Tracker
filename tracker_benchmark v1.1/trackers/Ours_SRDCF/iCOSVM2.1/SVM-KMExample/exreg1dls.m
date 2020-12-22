%
%  1D Regression example
%
close all
clear all
tic
%-------------------creating and plotting data----------------
n=600;
x=linspace(0,5,n)';
xx=linspace(0,5,n)';
xi=x;
yi=cos(exp(x));
y=cos(exp(xx));
figure(1)
hold on;
plot(xx,y,'g');
%----------------------Learning Parameters -------------------
C = 10;  lambda = 0.000001; 
epsilon = .1;
kerneloption = 0.4;
kernel='gaussian';
verbose=1;
qpsize=100;
[xsup,ysup,w,w0] = svmregls(xi,yi,C,epsilon,kernel,kerneloption,lambda,verbose,qpsize);
%---------------------Processing and plotting regression function--------

rx = svmval(xx,xsup,w,w0,kernel,kerneloption);
h = plot(xx,rx,'b'); 
set(h,'LineWidth',2);
h = plot(xsup,ysup,'or'); 
set(h,'LineWidth',2);
plot(xx,rx+epsilon,'b--'); 
plot(xx,rx-epsilon,'b--'); hold off;
title('Support Vector Machine Regression');
xlabel('x');ylabel('y');
hold off

