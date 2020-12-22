
%
% Example of 2D Classification with Checkers Data
% Using Gaussian Kernel and Haar Wavelet Kernel;
%
%
% 11/11/2002 AR


clear all
close all
tic





n = 160; 
ntest=400;
sigma=1.2;
[Xapp,yapp,xtest,ytest, xtest1, xtest2]=datasets('Checkers',n,ntest,sigma);

%-----------------------------------------------------------%
%  rescaling data on [0,1]^2 interval                       %  
%-----------------------------------------------------------%
Napp=length(Xapp);
scaling=1.0;

%[Xapp,mini,maxi,xtest]=normalizeinterval(Xapp,xtest,scaling);
%------- Building a 2D Grid for function evaluation -------------------------
[xtest1 xtest2]  = meshgrid([-2:0.1:2]); 
nn = length(xtest1); 
Xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 


%-----------------------------------------------------------%
%                   SVM Kernel Option                       %  
%-----------------------------------------------------------%

lambda = 1e-7;  
C = 10000000;




kernel='tensorwavkernel';


kerneloption.wname='Haar';   % Type of mother wavelet
kerneloption.pow=8;          % number of dyadic decomposition   
kerneloption.par=4;          % number of vanishing moments
kerneloption.jmax=2;
kerneloption.jmin=-2;
kerneloption.father='on';   % use father wavelet in kernel
kerneloption.coeffj=1/sqrt(2); % coefficients of ponderation of a given j scale    

kernel2='gaussian';
kernel2option=0.5;

%-----------------------------------------------------------%
%                   SVM  Calculation                        %  
%-----------------------------------------------------------%


tic
[xsup,w,w0,tps,alpha] = svmclass(Xapp,yapp,C,lambda,kernel,kerneloption,1); 
tpstensor=toc;
ypred = svmval(Xtest,xsup,w,w0,kernel,kerneloption,[ones(length(Xtest),1)]);
ypred = reshape(ypred,nn,nn); 

%------------------------Plotting--------------------------%

figure(1); 
clf; 
contourf(xtest1,xtest2,ypred,50);shading flat;hold on
[cc,hh]=contour(xtest1,xtest2,ypred,[0  0 ],'k');
clabel(cc,hh); 
h1=plot(Xapp(yapp==1,1),Xapp(yapp==1,2),'+k'); 
set(h1,'LineWidth',2);
h2=plot(Xapp(yapp==-1,1),Xapp(yapp==-1,2),'xk'); 
set(h2,'LineWidth',2);

title('2D Tensor-Product Kernel');
set(gcf,'color','white');

%-----------------------------------------------------------%
%                   SVM  Calculation                        %  
%-----------------------------------------------------------%



tic
[xsup2,w2,w02,tps,alpha] = svmclass(Xapp,yapp,C,lambda,kernel2,kernel2option,1); 
tps2d=toc;
ypred2 = svmval(Xtest,xsup2,w2,w02,kernel2,kernel2option,[ones(length(Xtest),1)]);
ypred2 = reshape(ypred2,nn,nn); 

%------------------------Plotting--------------------------%

figure(2); 
clf; 
contourf(xtest1,xtest2,ypred2,50);shading flat;hold on
[cc,hh]=contour(xtest1,xtest2,ypred2,[ 0 0],'k');
clabel(cc,hh); 
h1=plot(Xapp(yapp==1,1),Xapp(yapp==1,2),'+k'); 
set(h1,'LineWidth',2);
h2=plot(Xapp(yapp==-1,1),Xapp(yapp==-1,2),'xk'); 
set(h2,'LineWidth',2);

title('Gaussian Kernel');
set(gcf,'color','white');
fprintf('Temps Tensor : %f   Teps 2d : %f \n',tpstensor,tps2d);

%------------------------Plotting--------------------------%

figure(3); 
clf; 
contourf(xtest1,xtest2,ypred,50);shading flat;hold on
[cc,hh]=contour(xtest1,xtest2,ypred2,[ 0 0],'k');
clabel(cc,hh); 
h1=plot(xtest(ytest==1,1),xtest(ytest==1,2),'+k'); 
set(h1,'LineWidth',2);
h2=plot(xtest(ytest==-1,1),xtest(ytest==-1,2),'xk'); 
title('Comparing Gaussian Kernel Solution and Haar Kernels');


%k=svmkernel(Xapp,kernel,kerneloption);
%k2=svmkernel(Xapp,kernel2,kernel2option);