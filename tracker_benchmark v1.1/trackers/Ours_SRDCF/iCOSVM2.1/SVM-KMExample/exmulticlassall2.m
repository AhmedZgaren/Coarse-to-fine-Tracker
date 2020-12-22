%
%
%   example of multiclass SVM using M-SVM
%   with assymetric penalizarion Coefficient C
%  
%   06/01/2003  Alain Rakotomamonjy



close all
clear all
%--------------------------------------------------
n=10;
sigma=1;


x1= sigma*randn(n,2)+ ones(n,1)*[-1.5 -1.5];
x2= sigma*randn(n,2)+ ones(n,1)*[0 2];
x3= sigma*randn(n,2)+ ones(n,1)*[2 -1.5];
xapp=[x1;x2;x3];

yapp=[1*ones(1,n) 2*ones(1,n) 3*ones(1,n)]';
[ell, n2]=size(xapp);


%-------------------------------------------------------
% Kernel Parameters
%-------------------------------------------------------
kernel='gaussian';
kerneloption=10;
C1=10000;
C2=10000;
C3=500;
C=[C1*ones(n,1); C2*ones(n,1); C3*ones(n,1); ];
verbose=1;
lambda=1e-7;
nbclass=3;
%-------------------------------------------------------
% Solving
%-------------------------------------------------------
[xsup,w,b,nbsv,pos,alpha]=svmmulticlass(xapp,yapp,nbclass,C,lambda,kernel,kerneloption,verbose);
[ypred] = svmmultival(xapp,xsup,w,b,nbsv,kernel,kerneloption);
fprintf( '\nRate of correct class in training data : %2.2f \n',100*sum(ypred==yapp)/length(yapp)); 
%-------------------------------------------------------
% Testing
%-------------------------------------------------------

[xtesta1,xtesta2]=meshgrid([-5:0.1:5],[-5:0.1:5]);
[na,nb]=size(xtesta1);
xtest1=reshape(xtesta1,1,na*nb);
xtest2=reshape(xtesta2,1,na*nb);
xtest=[xtest1;xtest2]';
[ypred,maxi] = svmmultival(xtest,xsup,w,b,nbsv,kernel,kerneloption);
ypredmat=reshape(ypred,na,nb);


%-------------------------------------------------------
% Plotting
%-------------------------------------------------------

contourf(xtesta1,xtesta2,ypredmat*2+reshape(2*maxi/max(maxi),na,nb),30);shading flat;hold on
[cs,h]=contour(xtesta1,xtesta2,ypredmat,[ 1 2 3]);
clabel(cs,h);
style=['x+*'];
color=['kkk'];
hold on
nbclass=max(yapp);
for i=0:nbclass-1
    h=plot(xapp(i*n+1:(i+1)*n,1),xapp(i*n+1:(i+1)*n,2),[style(i+1) color(i+1)]);
     hold on
end; 
legend('classe 1','classe 2','classe 3');
