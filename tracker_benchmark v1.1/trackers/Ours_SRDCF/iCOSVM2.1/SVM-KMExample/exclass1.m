%
%  SVM Classification 2D examples
%  with different kernels (including wavelets) and different penalization settings
%
%  05/05/03 AR


clear all
close all
clc


n = 1000; 
sigma=0.3;


[Xapp,yapp,xtest,ytest]=datasets('gaussian',n,0,sigma);
Xapp=single(Xapp);
[Xapp]=normalizemeanstd(Xapp);


 
lambda = 1e-7;  
C = 10;


%
%  assymetric C
%

%C=[100*ones(n/2,1); 100*ones(n/2,1)];


% 
 kernel='gaussian';
 kerneloption=1;
 

%  uncomment this is you want to use a wavelet kernel.
%  but you need to install the wavelab toolbox of Donoho et al.
%
% kernel='tensorwavkernel';
% kerneloption.wname='Haar';
% kerneloption.pow=8;
% kerneloption.par=4;
% kerneloption.jmax=5;
% kerneloption.jmin=0;
% kerneloption.crossterm='off';
% kerneloption.coeffj=1/sqrt(2); 
% 
% x=linspace(0,1,20)';
% [kernel,KernelInfo]=tensorwavkernel(x,x,kerneloption);
   

%keyboard
[xsup,w,w0,pos,tps,alpha] = svmclass(Xapp,yapp,C,lambda,kernel,kerneloption,1); 
%[xsup,w,w0,pos,tps,alpha] = svmclassLS(Xapp,yapp,C,lambda,kernel,kerneloption,1,1,100); 

ypredapp = svmval(Xapp,xsup,w,w0,kernel,kerneloption,1);

%------- Building a 2D Grid for function evaluation -------------------------
[xtest1 xtest2]  = meshgrid([-1:.05:1]*3.5,[-1:0.05:1]*3); 
nn = length(xtest1); 
Xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 



%--------------  Evaluating the decision function
ypred = svmval(Xtest,xsup,w,w0,kernel,kerneloption,[ones(length(Xtest),1)]);
ypred = reshape(ypred,nn,nn); 
 

%--------------- plotting
figure(1); 
clf; 
%contourf(xtest1,xtest2,ypred,50);shading flat;
hold on
[cc,hh]=contour(xtest1,xtest2,ypred,[-1  0 1],'k');
clabel(cc,hh); 
set(hh,'LineWidth',2);
h1=plot(Xapp(yapp==1,1),Xapp(yapp==1,2),'+r'); 
set(h1,'LineWidth',2);

h2=plot(Xapp(yapp==-1,1),Xapp(yapp==-1,2),'db'); 
set(h2,'LineWidth',2);
h3=plot(xsup(:,1),xsup(:,2),'ok'); 
set(h3,'LineWidth',2);




axis([-3.5 3.5 -3 3]); 

 

