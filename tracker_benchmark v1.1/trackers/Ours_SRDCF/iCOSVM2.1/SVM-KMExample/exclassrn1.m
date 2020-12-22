%
% Example of CosExp Data
% semiparametric classification with regularization networks
%
%

clear all
close all


%-------------------------------------------------------------------
%                           Datasets
%-------------------------------------------------------------------
nbapp=300;
nbtest=25;
[xapp,yapp]=datasets('CosExp',nbapp,nbtest);
[xtest1 xtest2]  = meshgrid(linspace(0,4,nbtest),linspace(-1,1,nbtest)); 
nn = length(xtest1); 
xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 


lambda = 1;  
kernel='gaussian';
kerneloption=0.1;
T=phispan(xapp,'sin2d');
[c,d]=rncalc(xapp,yapp,kernel,kerneloption,lambda,T);
T=phispan(xtest,'sin2d');
ypred=rnval(xapp,xtest,kernel,kerneloption,c,d,T);
ypred = reshape(ypred,nn,nn); 



figure(1); 
clf; 
contourf(xtest1,xtest2,ypred,50);shading flat;
hold on

h1=plot(xapp(yapp==1,1),xapp(yapp==1,2),'+k'); 
h2=plot(xapp(yapp==-1,1),xapp(yapp==-1,2),'xk'); 
set(h1,'LineWidth',2);
set(h2,'LineWidth',2);
[cc, hh]=contour(xtest1,xtest2,ypred,[0 0],'k-'); 

clabel(cc,hh); 
title('SemiParametric Regularization Networks  Classification');