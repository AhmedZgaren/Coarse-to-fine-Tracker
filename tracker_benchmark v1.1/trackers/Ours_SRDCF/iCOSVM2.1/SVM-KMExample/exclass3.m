%
%
%   Example of Semiparametric Classificition
%
%
%

clear all
close all


nbapp=500;
nn=20;
nbtest=nn*nn;
sigma=0.1;
[xapp,yapp,xtest,ytest,xtest1, xtest2]=datasets('CosExp',nbapp,nbtest,sigma);

%
%  learning with polynomial kernels
%

lambda = 1e-7;  
C = 100;
kernel='gaussian';
kerneloption=1;
phi = phispan(xapp,'sin2D');
phitest = phispan(xtest,'sin2D');
[xsup,w,w0,tps,alpha] = svmclass(xapp,yapp,C,lambda,kernel,kerneloption,1,phi); 
[ypred,y1,y2] = svmval(xtest,xsup,w,w0,kernel,kerneloption,phitest,1);
ypred = reshape(ypred,nn,nn); 


%
%               plotting
%

figure(1); 
clf; 
contourf(xtest1,xtest2,ypred,50);shading flat;
hold on

h1=plot(xapp(yapp==1,1),xapp(yapp==1,2),'+k'); 
h2=plot(xapp(yapp==-1,1),xapp(yapp==-1,2),'xk'); 
h3=plot(xsup(:,1),xsup(:,2),'ok'); 
set(h1,'LineWidth',2);
set(h2,'LineWidth',2);
set(h3,'LineWidth',2);
[cc, hh]=contour(xtest1,xtest2,ypred,[-100000,-1 0 1],'k-'); 

clabel(cc,hh); 
hold off