%
%   Example of Semi parametric SVM Using Frame Kernel
%
%
%   14/10/2000 Alain Rakotomamonjy 


close all
clear all
tic
bruit=0.2;
%-------------------creating and plotting data----------------
N=100;
x1=2*randn(N,1);
x2=2*randn(N,1);
y=exp(-(x1.^2+x2.^2)*2)+ 0.05*x1 -0.05*x2;
x=[x1 x2];


%----------------------Learning Parameters -------------------




kernel='gaussian';kerneloption=0.2;

spanning='linear';
T=phispan(x,spanning);



%-------------------------SemiparametricSVM----------------------------------------
C =10;  
epsilon = .2;
lambda=1e-6;
verbose=1;
[xsup,ysup,w,w0] = svmreg(x,y,C,epsilon,kernel,kerneloption,lambda,verbose,T);

% %-----------------------------------------------------------------------------------

[xtesta1,xtesta2]=meshgrid([-5:0.1:5],[-5:0.1:5]);
[na,nb]=size(xtesta1);
xtest1=reshape(xtesta1,1,na*nb);
xtest2=reshape(xtesta2,1,na*nb);
xtest=[xtest1;xtest2]';
T=phispan(xtest,spanning);
ypred = svmval(xtest,xsup,w,w0,kernel,kerneloption,T);
ypredmat=reshape(ypred,na,nb);

%--------------------------------------------------------
mesh(xtesta1,xtesta2,ypredmat);
xlabel('x');
ylabel('y');
title('Support Vector Machine Regression');
