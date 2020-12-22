%
%
%   Examples of Non linear Robust linear program SVM
%
%
%
%   min C sum nu_j  + sum s_j 
%
%   st  y_i ( sum_j w_j y_j K(x_i,x_j) -b ) + nu_i >= 1
%       nu >=0
%       -s_j <= w_j <= s_j
%

clear all
close all
addpath('../toollp');

Napp = 300; 
Nunl =10;
tic
sigma=0.3;
C=100;

[xapp,yapp,xtest,ytest, xtest1, xtest2]=datasets('checkers',Napp,Nunl,sigma);
[xtest1 xtest2]  = meshgrid([-1:.05:1]*3.5,[-1:0.05:1]*3); 
nn = length(xtest1); 
Xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 


Napp=size(xapp,1);
Nbvar=size(xapp,2);

lambda=1e-6;
kernel='gaussian';
kerneloption=0.4;

 [xsup,w,b,pos]=LPsvmclass(xapp,yapp,C,lambda,kernel,kerneloption);


%toc


ypred = svmval(Xtest,xsup,w,b,kernel,kerneloption,[ones(length(Xtest),1)]);
ypred = reshape(ypred,nn,nn); 







verbose=0;
lambda=1e-7;
%tic

[xsupsvm,w1,w0,possvm,tps,alpha1] = svmclass(xapp,yapp,C,lambda,kernel,kerneloption,verbose); 
ypred1 = svmval(Xtest,xsupsvm,w1,w0,kernel,kerneloption,[ones(length(Xtest),1)]);
ypred1 = reshape(ypred1,nn,nn);
%toc

hold on

h1=plot(xapp(yapp==1,1),xapp(yapp==1,2),'+g'); hold on
set(h1,'LineWidth',2);
h2=plot(xapp(yapp==-1,1),xapp(yapp==-1,2),'xr'); 
set(h2,'LineWidth',2);

[cc,hh]=contour(xtest1,xtest2,ypred,[-1  0 1],'k');
h2=plot(xsup(:,1),xsup(:,2),'ob'); 
set(h2,'LineWidth',2);
clabel(cc,hh); 
[cc,hh]=contour(xtest1,xtest2,ypred1,[-1  0 1],'r:');
h2=plot(xsupsvm(:,1),xsupsvm(:,2),'om'); 
clabel(cc,hh); 

