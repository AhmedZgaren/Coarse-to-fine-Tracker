

close all
clear all
tic
%--------------------------------------------------
N=50;
sigma=0.3;
[xapp,yapp,xtest,ytest]=datasets('gaussian',N,N,sigma);

%-----------------------------------------------------
%   Learning and Learning Parameters
c =1e6;
c1=10000;
c2=100;
epsilon = .000001;
gamma =[0.2 0.2 100];
gamma1=0.4;
kernel='gaussian';
verbose = 1;


[xsup1,w1,b1,pos1]=svmclassnpa(xapp,yapp,c1,kernel,gamma1,verbose);


indpos=find(yapp==1);
indneg=find(yapp==-1);

%----------------------Creating Test Data----------------------------------

[xtesta1,xtesta2]=meshgrid([-4:0.2:4],[-4:0.2:4]);
[na,nb]=size(xtesta1);
xtest1=reshape(xtesta1,1,na*nb);
xtest2=reshape(xtesta2,1,na*nb);
xtest=[xtest1;xtest2]';

%--------------Testing Generalization performance ---------------


ypred1=svmval(xtest,xsup1,w1,b1,kernel,gamma1);

%---------------------------------------------------------
na=sqrt(length(xtest));

ypredmat1=reshape(ypred1,na,na);
xtesta1=reshape(xtest(:,1),na,na);
xtesta2=reshape(xtest(:,2),na,na);
%----------------------Plotting---------------------------------

figure
plot(xapp(indpos,1),xapp(indpos,2),'rx',xapp(indneg,1),xapp(indneg,2),'bx',xsup1(:,1),xsup1(:,2),'kd');
axis([-2 2 -2 2]);

hold on
[cs,h]=contour(xtesta1,xtesta2,ypredmat1,[-1 0 1]);clabel(cs,h);
hold off
xlabel('x1');ylabel('x2');
title('NPA Classifier Algorithm Quadratic Penalization');
