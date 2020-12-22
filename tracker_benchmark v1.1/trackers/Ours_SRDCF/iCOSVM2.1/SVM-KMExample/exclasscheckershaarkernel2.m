%
% Example of 2D Classification with Checkers Data
% Using Gaussian Kernel and Haar Wavelet Kernel;
% Average Error over 100 trials
%
% 11/11/2002 AR
clear all
close all
tic



n = 80; 
ntest=400;
sigma=1.2;
nbiter=2;



%-----------------------------------------------------------%
%                   SVM Kernel Option                       %  
%-----------------------------------------------------------%
Nvec=1;
lambda = 1e-7;  
C = 100000000;
kernel2='gaussian';
kernel2optionvec=linspace(0.01,1,Nvec);
kernel2optionvec=0.11;



verbose=0;


scale=1;
minimum=0;

kernel='tensorwavkernel';


kerneloption.wname='Haar';   % Type of mother wavelet
kerneloption.pow=8;          % number of dyadic decomposition   
kerneloption.par=4;          % number of vanishing moments
kerneloption.jmax=2;
kerneloption.jmin=-2;
kerneloption.father='on';   % use father wavelet in kernel
kerneloption.coeffj=1/sqrt(2); % coefficients of ponderation of a given j scale  
%-----------------------------------------------------------%
%                   SVM  Calculation                        %  
%-----------------------------------------------------------%

for i=1:Nvec
    i
    %kerneloption=kerneloptionvec(i);  UNCOMMENT FOR VALIDATION ERROR
    for k=1:nbiter
        
        [Xapp,yapp,xtest,ytest, xtest1, xtest2]=dataset('Checkers',n,ntest,sigma);  
        [Xapp,mini,maxi,xtest]=normalizeinterval(Xapp,xtest,scale,minimum);
        [xsup2,w2,w02,tps,alpha] = svmclass(Xapp,yapp,C,lambda,kernel,kerneloption,verbose); 
        ypred2 = svmval(xtest,xsup2,w2,w02,kernel,kerneloption,[ones(length(xtest),1)]);
        nberror(k,i)= sum((sign(ypred2)~=ytest))/length(xtest);
    end
end;


