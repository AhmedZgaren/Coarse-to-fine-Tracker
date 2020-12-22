% comparing different settings of semiparametric
% regularization
% 
%   sin +gaussian
%   wavelet
%   wavelet + gaussian
%   sinc + sin
%
%  function to be approximated : sin(x) + sinc(x-5)+sinc(5(xf-2))
%
% This script is the one used for experiment 2.
% in the TechRep "Frame, Reproducing Kernel, Regularization and Learning"
% by Rakotomamonjy and Canu The hyperparameter setting
% can be retrieved by using semipregex2 semipregex3 semipregex4 semipreg5
% script
%

%   Last Modified : 15/03/2001 Alain Rakotomamonjy 


close all
clear all

verbose=0;
bruit=0.2;
N=100;

%----------------------Wavelet Frame----------------%
n=200;
t=linspace(0,10,n)';
uo=1;
a=2^0.25;
bord1=0;
bord2=10;
dilation=[-10];
framematrix=framewav(t,dilation,uo,a,bord1,bord2);
dual=dualframe(framematrix,t);
%---------------------Sin Sinc Frame --------------%
    n=200;
    t=linspace(0,10,n)';
    framematrix1=[];
    for j=[3 6]
        for k=1:10
            framematrix1=[framematrix1; sinc(j*(t'-k))];
        end;
    end;
    dual1=dualframe(framematrix1,t);

%---------------Hyperparameters---------------------%
%
%  to be tuned by model selection                   %
lambdagauss=0.6;   
lambdawav=80;
lambdawavgauss=3;
lambdasin=40;
%---------------------------------------------------%

itermax=1;
erreur=zeros(itermax,4);
for i=1:itermax
    
    %-------------------creating data----------------
    x=sort([0.01; 9.99;10*rand(N-2,1)]);
    xf=linspace(0,10,200)'; 
    x1=x;
    x2=x;
    yf=sin(xf)+1*sinc((xf-5))+sinc(5*(xf-2));
    y=sin(x)+1*sinc((x-5))+1*sinc(5*(x-2))+bruit*randn(size(x));
   
    %---------------------- GAUSSIAN / SIN Semi RegNet-------------------
    kerneloption =0.15;  
    kernel='gaussian';
    spanning='sin';
    T=phispan(x,spanning);
    K=kernelframe(x1,kernel,x2,kerneloption);
    [c,d]=regsolve(K,T,y,lambdagauss);
    x1=xf;
    K=kernelframe(x1,kernel,x2,kerneloption);
    T=phispan(x1,spanning);
    f1=K*c+T*d;
   
    %--------------------Wavelet SemiParam RegNet----------------------------
    kernel='numerical';
    spanning='wavelet';
    dilation=[0 5];
    T=phispan(x,spanning,dilation,uo,a,bord1,bord2);
    K=kernelframe(x,kernel,x2,framematrix,t,dual);
    [c,d]=regsolve(K,T,y,lambdawav);
    T=phispan(xf,spanning,dilation,uo,a,bord1,bord2);
    K=kernelframe(xf,kernel,x2,framematrix,t,dual);
    f2=K*c+T*d;
    
    %-----------------------------Wav Gaussian SemiParam RegNet-------------------------------
    kerneloption=0.11;
    kernel='gaussian';
    spanning='wavelet';
    dilation=[0 5];
    T=phispan(x,spanning,dilation,uo,a,bord1,bord2);
     K=kernelframe(x,kernel,x2,kerneloption);
    [c,d]=regsolve(K,T,y,lambdawavgauss);
    T=phispan(xf,spanning,dilation,uo,a,bord1,bord2);
    K=kernelframe(xf,kernel,x2,kerneloption);
    f3=K*c+T*d;
    
    %--------------------Sin/Sinc SemiParam RegNet----------------------------
    kernel='numerical';
    spanning='sinc_sin';
    T=phispan(x,spanning);
    K=kernelframe(x,kernel,x2,framematrix1,t,dual1);
    [c,d]=regsolve(K,T,y,lambdasin);
    T=phispan(xf,spanning);
    K=kernelframe(xf,kernel,x2,framematrix1,t,dual1);
    f4=K*c+T*d;
    
    
    %figure
    %hold on
    h = plot(x,y,'k+',xf,yf,'k',xf,f1,'b',xf,f2,'r',xf,f3,'m',xf,f4,'g'); 
    legend('data points', 'original','Gaussian','Wavelet','WavGauss','Sin/Sin');
    set(h,'LineWidth',2);
    title('Semi Parametric Regularization Networks ');
    xlabel('x');ylabel('y');
    errspgauss=sum( (yf-f1).^2/200);
    errspwav=sum( (yf-f2).^2/200);
    errspwavgauss=sum( (yf-f3).^2/200);
    errspsin=sum( (yf-f4).^2/200);
    
    erreur(i,:)=[errspgauss errspwav errspwavgauss errspsin];
    fprintf('i:%d mse gaussian: %f    mse wavelet : %f    mse wavgauss:%f msesin : %f\n',i,errspgauss,errspwav,errspwavgauss,errspsin);
    %save compsemipreg erreur i lambdawav lambdagauss lambdawavgauss lambdasin
end;
