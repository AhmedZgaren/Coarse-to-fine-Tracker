
%
%  Evaluation of the radius square of the smallest sphere
%  
% 
%

close all
clear all

N=2;
xapp=[1 1; 2 2];
N=100;
rho=4;
moy=[0 0];
xapp=randn(N,2) + ones(N,1)*moy;
mod2=sum((xapp-ones(N,1)*moy).^2,2);
xapp(find(mod2>rho),:)=[];


%yapp= sign(rand(N,1)-0.5);
kernel='poly';


C=0.001;
verbose=1;
kerneloption=1;

% if you just want to pass the kernel
K=svmkernel(xapp,kernel,kerneloption);
kerneloption.matrix=K+1/C*eye(size(xapp,1));
[beta,r2,pos]= r2smallestsphere([],kernel,kerneloption);

%beta,r2,pos]= r2smallestsphere(xapp,kernel,kerneloption);

fprintf('Radius : %4.4f\n', sqrt(r2));
plot(xapp(:,1),xapp(:,2),'+'); hold on
axis([-8 8 -8 8])
plot(xapp(pos,1),xapp(pos,2),'or');