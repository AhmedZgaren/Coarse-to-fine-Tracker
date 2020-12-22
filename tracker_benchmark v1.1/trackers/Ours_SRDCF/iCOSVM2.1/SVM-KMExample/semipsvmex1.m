%
%   Example of Semi parametric SVM Using Frame Kernel
%
%
%   14/10/2000 Alain Rakotomamonjy 


close all
clear all
tic
bruit=0.2;
N=50;
%-------------------creating and plotting data----------------

x=sort([0.01; 9.99;10*rand(N-2,1)]);
%x=linspace(0.1,9.9,N)';
xx=linspace(0,10,200)';
xi=x;
y=sin(xx)+1*sinc((xx-5))+sinc(5*(xx-2));
yi=sin(x)+1*sinc((x-5))+1*sinc(5*(x-2))+bruit*randn(size(x));
xi=x;

%----------------------Learning Parameters -------------------

n=200;
t=linspace(0,10,n)';
uo=1;
a=2^0.25;
bord1=-5;
bord2=15;
dilation=[ -8 -5];
framematrix=framewav(t,dilation,uo,a,bord1,bord2);
dual=dualframe(framematrix,t);
%kerneloption ='numerical';
%kernel='frame';

kernel='gaussian';kerneloption=0.2;

spanning='wavelet';
dilation=[ 2 5];
T=phispan(x,spanning,dilation,uo,a,bord1,bord2);



%-------------------------SemiparametricSVM----------------------------------------
C =10;  
epsilon = .5;
lambda=1e-6;
verbose=1;
[xsup,ysup,w,w0] = svmreg(xi,yi,C,epsilon,kernel,kerneloption,lambda,verbose,T,framematrix,t,dual);
T=phispan(xx,spanning,dilation,uo,a,bord1,bord2);
[rspx,approx,det] = svmval(xx,xsup,w,w0,kernel,kerneloption,T,framematrix,t,dual);
%-----------------------------------------------------------------------------------
figure
hold on
h = plot(xi,yi,'g+',xx,y,'g',xx,rspx,'b'); 
legend('data points', 'original','semiparametric');
set(h,'LineWidth',2);
title('Semi Parametric SVM Regression ');
xlabel('x');ylabel('y');
errspsvm=sum( (y-rspx).^2/200);
fprintf('mean square error: %f   \n',errspsvm);