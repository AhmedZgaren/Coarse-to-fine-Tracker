%
%
%   One-Class SVM example
%


clear all
close all

randn('seed',0)
nu=0.9;
n=1000;
sigma=0.5;
[xapp,yapp]=datasets('gaussian',n,0,sigma);

xapp=xapp(yapp==1,:);
n=size(xapp,1);

kernel='poly';
kerneloption=3.0;
verbose=0;
%size(xapp)
[xsup,alpha,rho,pos]=svmoneclass(xapp,kernel,kerneloption,nu,verbose);
%size(alpha)
ypredapp=svmoneclassval(xapp,xsup,alpha,rho,kernel,kerneloption);

[xtest,xtest1,xtest2,nn]=DataGrid2D([-2:0.1:2],[-2:0.1:2]);


ypred=svmoneclassval(xtest,xsup,alpha,rho,kernel,kerneloption);
%ypred
ypred=reshape(ypred,nn,nn);
epsilon=1e-6;
% if sum(alpha<-epsilon | alpha > (1/nu/n)+epsilon)
%     error('numerical error');
% end;
pos1=pos(alpha<(1/nu/n));

%--------------- plotting
figure(1); 
%clf; 
%contourf(xtest1,xtest2,ypred,50);shading flat;
hold on
[cc,hh]=contour(xtest1,xtest2,ypred,[0 0],'k');
clabel(cc,hh); 
h1=plot(xapp(:,1),xapp(:,2),'+k'); 
set(h1,'LineWidth',2);
h3=plot(xsup(:,1),xsup(:,2),'ok'); 
set(h3,'LineWidth',2);
h1=plot(xapp(pos1,1),xapp(pos1,2),'om'); 
%axis([-2 2 -2 2])
set(gcf,'color','white');