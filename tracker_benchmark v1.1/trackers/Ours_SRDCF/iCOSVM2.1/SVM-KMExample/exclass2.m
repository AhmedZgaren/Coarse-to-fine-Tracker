%
%   SVM 2D Classification 
%   Comparing Gaussian and polynomial Kernels 
%
%


clear all
close all


%
%   Creating Data
%

nbapp=100;
nn=20;
nbtest=nn*nn;
sigma=0.5;
[xapp,yapp,xtest,ytest,xtest1,xtest2]=datasets('gaussian',nbapp,nbtest,sigma);
%------- Building a 2D Grid for function evaluation -------------------------
[xtest1 xtest2]  = meshgrid([-1:.05:1]*3.5,[-1:0.05:1]*3); 
nn = length(xtest1); 
xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 


%
%  learning with polynomial kernels
%

lambda = 1e-10;  
C = 1;
kernel='poly';
kerneloption=1;
verbose=1;
qpsize=500;
phi = ones(size(yapp));
[xsup,w,w0,tps,alpha] = svmclassLS(xapp,yapp,C,lambda,kernel,kerneloption,verbose,phi,qpsize); 
ypred = svmval(xtest,xsup,w,w0,kernel,kerneloption,ones(length(xtest),1));%,framematrix,vector,dual)
ypred = reshape(ypred,nn,nn); 



%
%               plotting
%

figure(1); 
clf; 
contourf(xtest1,xtest2,ypred,50);shading flat; hold on
h1=plot(xapp(yapp==1,1),xapp(yapp==1,2),'+k'); 
h2=plot(xapp(yapp==-1,1),xapp(yapp==-1,2),'xk'); 
h3=plot(xsup(:,1),xsup(:,2),'ok'); 

%-------------------  Gaussian Kernel -------------------------


kernel='gaussian';
kerneloption=.25;
phi = ones(size(yapp));
[xsup,w,w0,tps,alpha] = svmclassLS(xapp,yapp,C,lambda,kernel,kerneloption,verbose,phi); 
ypred = svmval(xtest,xsup,w,w0,kernel,kerneloption,ones(length(xtest),1));%,framematrix,vector,dual)
ypred = reshape(ypred,nn,nn); 


      %        plotting

 
figure(2); 
clf;
clf; 
contourf(xtest1,xtest2,ypred,50);shading flat;
hold on
h1=plot(xapp(yapp==1,1),xapp(yapp==1,2),'+k'); 
h2=plot(xapp(yapp==-1,1),xapp(yapp==-1,2),'xk'); 
h3=plot(xsup(:,1),xsup(:,2),'ok'); 
set(h1,'LineWidth',2);
set(h2,'LineWidth',2);
set(h3,'LineWidth',2);
[cc, hh]=contour(xtest1,xtest2,ypred,[-100000,-1 0 1],'k'); 
clabel(cc,hh); 
hold off
