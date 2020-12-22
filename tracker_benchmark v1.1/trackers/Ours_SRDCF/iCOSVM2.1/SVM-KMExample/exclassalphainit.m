%
%
%       Examples of classification with initialization
%       of Lagrangian Multipliers
%
%   

close all
clear all
n = 250;

%-------------------------------------------------------------------
%                           Datasets
%-------------------------------------------------------------------

sigma=1.2;
[Xapp,yapp]=datasets('Clowns',n,0,sigma);
[xtest1 xtest2]  = meshgrid([-1:.05:1]*3.5,[-1:0.05:1]*3); 
nn = length(xtest1); 
Xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 


%-------------------------------------------------------------------
%                           SVM Parameters
%-------------------------------------------------------------------

lambda = 1e-7;  
C = inf;
verbose=1;
kernel='gaussian';
kerneloption=1;
phi = [ones(size(yapp))]; 



%-------------------------------------------------------------------
%                          Learning SVM Without Initialization
%-------------------------------------------------------------------

tic
[xsup,w,w0,pos,timeps,alpha]= svmclass(Xapp,yapp,C,lambda,kernel,kerneloption,verbose,phi); 
time1=toc; 

ypred = svmval(Xtest,xsup,w,w0,kernel,kerneloption,[ones(length(Xtest),1)]);
ypred = reshape(ypred,nn,nn); 
 
figure(1); 
clf;
[cc, hh]=contourf(xtest1,xtest2,ypred,[50]); shading flat
hold on; 
h=plot(Xapp(yapp==1,1),Xapp(yapp==1,2),'+r'); 
set(h,'LineWidth',2)
h=plot(Xapp(yapp==-1,1),Xapp(yapp==-1,2),'xb'); 
set(h,'LineWidth',2)
h=plot(xsup(:,1),xsup(:,2),'om'); 
set(h,'LineWidth',2)
[cc, hh]=contour(xtest1,xtest2,ypred,[-1 0 1],'k'); 
axis([-3.5 3.5 -3 3]); 
clabel(cc,hh); 
title('SVM Classification w/o initialisation');


%-------------------------------------------------------------------
%                          Learning SVM With Initialization
%-------------------------------------------------------------------

Xapp1=Xapp+0.05*randn(size(Xapp));
alphainit=zeros(size(Xapp,1),1);
alphainit(pos)=alpha;
tic
[xsup,w1,w0,pos,timeps] = svmclass(Xapp1,yapp,C,lambda,kernel,kerneloption,verbose,phi,alphainit); 
time2=toc;
ypred2 = svmval(Xtest,xsup,w1,w0,kernel,kerneloption,[ones(length(Xtest),1)]);
ypred2 = reshape(ypred2,nn,nn); 
 

figure(2); 
clf;
[cc, hh]=contourf(xtest1,xtest2,ypred2,[50]); shading flat
hold on; 
h=plot(Xapp1(yapp==1,1),Xapp1(yapp==1,2),'+r'); 
set(h,'LineWidth',2)
h=plot(Xapp1(yapp==-1,1),Xapp1(yapp==-1,2),'xb'); 
set(h,'LineWidth',2)
h=plot(xsup(:,1),xsup(:,2),'om'); 
set(h,'LineWidth',2)
[cc, hh]=contour(xtest1,xtest2,ypred2,[-1 0 1],'k'); 
axis([-3.5 3.5 -3 3]); 
clabel(cc,hh); 
title('SVM Classification with initialisation');


fprintf('Time Processing : %2.2f Time Processing with Init: %2.2f Gain:%2.2f\n',time1,time2,time1/time2);  