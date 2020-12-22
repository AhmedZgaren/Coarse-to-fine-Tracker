%
% Example MultiClass SVM Classifiction
% "One against One"
%
%
%


close all
clear all
%--------------------------------------------------
n=100;
sigma=0.5;
x1=sigma*randn(1,n)-1.4;
x2=sigma*randn(1,n)+0;
x3=sigma*randn(1,n)+2;

y1=sigma*randn(1,n)-1.4;
y2=sigma*randn(1,n)+2;
y3=sigma*randn(1,n)-1.4;

xapp=[x1 x2 x3;y1 y2 y3]';
yapp=[1*ones(1,n) 2*ones(1,n) 3*ones(1,n)]';
nbclass=3;
[n1, n2]=size(xapp);

%-----------------------------------------------------
%   Learning and Learning Parameters
c = 1000;
lambda = 1e-7;
kerneloption= 1;
kernel='poly';
verbose = 0;

%---------------------One Against One algorithms----------------
nbclass=3;
%
%[xsup,w,b,nbsv,classifier,pos]=svmmulticlassoneagainstone(xapp,yapp,nbclass,c,lambda,kernel,kerneloption,verbose);
kerneloptionm.matrix=svmkernel(xapp,kernel,kerneloption);
[xsup,w,b,nbsv,classifier,pos]=svmmulticlassoneagainstone([],yapp,nbclass,c,lambda,'numerical',kerneloptionm,verbose);



[xtesta1,xtesta2]=meshgrid([-4:0.1:4],[-4:0.1:4]);
 [na,nb]=size(xtesta1);
 xtest1=reshape(xtesta1,1,na*nb);
 xtest2=reshape(xtesta2,1,na*nb);
 xtest=[xtest1;xtest2]';

% [ypred,maxi] = svmmultivaloneagainstone(xtest,xsup,w,b,nbsv,kernel,kerneloption);
kerneloptionm.matrix=svmkernel(xtest,kernel,kerneloption,xapp(pos,:));
 [ypred,maxi] = svmmultivaloneagainstone([],[],w,b,nbsv,'numerical',kerneloptionm);
  
  
 ypredmat=reshape(ypred,na,nb);
contourf(xtesta1,xtesta2,ypredmat*2,30);shading flat
style=['x+*'];
color=['kkk'];
hold on
for i=0:nbclass-1
    h=plot(xapp(i*n+1:(i+1)*n,1),xapp(i*n+1:(i+1)*n,2),[style(i+1) color(i+1)]);
    set(h,'LineWidth',2);
    hold on
end; 

h=plot(xapp(pos,1),xapp(pos,2),'ok');
set(h,'LineWidth',2);
axis( [ -4 4 -4 4]);
legend('classe 1','classe 2','classe 3', 'Support Vector');
hold off




