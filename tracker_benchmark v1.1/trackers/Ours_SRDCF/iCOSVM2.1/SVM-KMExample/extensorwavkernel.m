%
%
%   try to build some relevant tensorproduct wavelet kernel
%
%

clear all
close all

kernel='tensorwavkernel';
kerneloption.wname='Daubechies';
kerneloption.pow=8;
kerneloption.par=4;
kerneloption.coeffj=1;
kerneloption.crossterm='on';
kerneloption.jmin=-3;
kerneloption.jmax=2;
kerneloption.check=1;
%--------------------------------------------------------------------------------
%  one can use a predetermined wavelet kernel using wavelet with prespecified
%  dilation and translation.
%  this matrix is contained in the kerneloption.vect field
%---------------------------------------------------------------------------------%
%load examplevect
%kerneloption.jmin=min(vect(:,1));
%kerneloption.jmax=max(vect(:,1));
%nbwav=size(vect,1);
%nbscal=length(find(vect(:,1)==kerneloption.jmin));
%kerneloption.vect=vect;



%---------------------------------------------------------------------------------%
%  one can use predetermined matric Cin and Din for the kernel computation        %  
%---------------------------------------------------------------------------------%  



%kerneloption.C=zeros(Nbfunct,nbscal);
Nbfunct=50;
ncol=50;
kerneloption.D=1*randn(Nbfunct,ncol);  %  size of this matrices will be crumped if too large or zero-padded if too small
kerneloption.C=1*randn(Nbfunct,ncol); %
%-----------------------------------------------------------------------%  
%                       Classifying                                     %    
%-----------------------------------------------------------------------%



n = 50; 
sigma=0.5;
[Xapp,yapp]=datasets('Clowns',n,0,sigma);
[Xapp]=normalizemeanstd(Xapp);
lambda = 1e-7;  
C = 1000;

[xsup,w,w0,tps,alpha] = svmclass(Xapp,yapp,C,lambda,kernel,kerneloption,1); 


%-----------------------------------------------------------------------%  
%                                                                       %    
%-----------------------------------------------------------------------%

[xtest1 xtest2]  = meshgrid([-1:.1:1]*3.5,[-1:0.1:1]*3); 
nn = length(xtest1); 
Xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 

%--------------  Evaluating the decision function
ypred = svmval(Xtest,xsup,w,w0,kernel,kerneloption,[ones(length(Xtest),1)]);
ypred = reshape(ypred,nn,nn); 
%--------------- plotting---------------------------
[K]=svmkernel(Xapp,kernel,kerneloption);
figure 
mesh(K);
title('Gram Matrix of Training Data');
figure; 
clf; 
contourf(xtest1,xtest2,ypred,50);shading flat;hold on
[cc,hh]=contour(xtest1,xtest2,ypred,[-1  0 1],'k');
clabel(cc,hh); 
h1=plot(Xapp(yapp==1,1),Xapp(yapp==1,2),'+k'); 
set(h1,'LineWidth',2);

h2=plot(Xapp(yapp==-1,1),Xapp(yapp==-1,2),'xk'); 
set(h2,'LineWidth',2);
h3=plot(xsup(:,1),xsup(:,2),'ok'); 
set(h3,'LineWidth',2);

title('Example of Classification using Wavelet Kernels');


axis([-3.5 3.5 -3 3]); 