%
%  example of a 2D Regression
%

clear all;
close all;
%-----------Data creation------------------------------
N=100;
x1=2*randn(N,1);
x2=2*randn(N,1);
y=exp(-(x1.^2+x2.^2)*2);
x=[x1 x2];
%------------------------------------------------------

C = 1000; 
lambda = 1e-7; 
epsilon = .05;
kerneloption = 0.30;
kernel='gaussian';
verbose=1;
[xsup,ysup,w,w0] = svmreg(x,y,C,epsilon,kernel,kerneloption,lambda,verbose);


%--------------------------------------------------------
[xtesta1,xtesta2]=meshgrid([-3:0.1:3],[-3:0.1:3]);
[na,nb]=size(xtesta1);
xtest1=reshape(xtesta1,1,na*nb);
xtest2=reshape(xtesta2,1,na*nb);
xtest=[xtest1;xtest2]';
ypred = svmval(xtest,xsup,w,w0,kernel,kerneloption);
ypredmat=reshape(ypred,na,nb);

%--------------------------------------------------------
mesh(xtesta1,xtesta2,ypredmat);
xlabel('x');
ylabel('y');
title('Support Vector Machine Regression');



