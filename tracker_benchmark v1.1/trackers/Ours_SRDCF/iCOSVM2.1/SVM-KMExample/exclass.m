%
%  SVM Classification 2D examples
%
%  15/06/00 AR


close all
clear all
%-------------Data Set-------------------------------------
nbapp=200;
nbtest=0;
sigma=2;
[xapp,yapp]=datasets('Checkers',nbapp,nbtest,sigma);

%-----------------------------------------------------
%   Learning and Learning Parameters
c = inf;
epsilon = .000001;
kerneloption= 1;
kernel='gaussian';
verbose = 1;
tic
[xsup,w,b,pos]=svmclass(xapp,yapp,c,epsilon,kernel,kerneloption,verbose);
toc
%--------------Testing Generalization performance ---------------
[xtesta1,xtesta2]=meshgrid([-4:0.1:4],[-4:0.1:4]);
[na,nb]=size(xtesta1);
xtest1=reshape(xtesta1,1,na*nb);
xtest2=reshape(xtesta2,1,na*nb);
xtest=[xtest1;xtest2]';
ypred = svmval(xtest,xsup,w,b,kernel,kerneloption);
ypredmat=reshape(ypred,na,nb);
%----------------------Plotting---------------------------------

ind1=find(ypred>0);
indm1=find(ypred<0);

contourf(xtesta1,xtesta2,ypredmat,50);shading flat;
hold on
[cs,h]=contour(xtesta1,xtesta2,ypredmat,[-1 0 1],'k');
clabel(cs,h);
h1=plot(xapp(yapp==1,1),xapp(yapp==1,2),'+k'); 
set(h1,'LineWidth',2);

h2=plot(xapp(yapp==-1,1),xapp(yapp==-1,2),'xk'); 
set(h2,'LineWidth',2);
h3=plot(xsup(:,1),xsup(:,2),'ok'); 
set(h3,'LineWidth',2);



xlabel('x1');ylabel('x2');
title('Learning Data and Margin ');
axis([-4 4 -4 4]);
