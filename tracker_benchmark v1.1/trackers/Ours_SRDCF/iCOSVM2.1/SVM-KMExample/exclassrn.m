%
% Example of Checker Data
% classification with regularization networks
%
%

clear all
close all

%-------------------------------------------------------------------
%                           Datasets
%-------------------------------------------------------------------
nbapp=600;
nbtest=0;
[xapp,yapp]=datasets('Checkers',nbapp,nbtest);
[xtest1 xtest2]  = meshgrid([-2:0.1:2]); 
nn = length(xtest1); 
xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 

%-------------------------------------------------------------------
%                        Regularization Networks Parameters
%-------------------------------------------------------------------


lambda = 1;  
kernel='gaussian';
kerneloption=0.2;
[c,d]=rncalc(xapp,yapp,kernel,kerneloption,lambda);
ypred=rnval(xapp,xtest,kernel,kerneloption,c,d);
ypred = reshape(ypred,nn,nn); 

%-------------------------------------------------------------------
%                         Plotting
%-------------------------------------------------------------------


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
hold off
title('Regularization Networks for CheckerBoard Classification');