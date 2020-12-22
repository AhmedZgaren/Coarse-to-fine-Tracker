%
% Example of kernel PCA as prepocessing stage
% for a linear (or non linear) SVM classifier
% This script illustrates the so-called multilayers SVM
%
%
%

close all
clear all
%---------------------------------------------------------------------%
%                               Data                                  %
%---------------------------------------------------------------------%
N=200;
sigma=1;
[xapp yapp]=datasets('clowns',N,N,sigma);
[x,y]=meshgrid(-4:0.1:4);
nx=size(x,1);
xtest=[reshape(x,nx*nx,1) reshape(y,nx*nx,1)];
indplus=find(yapp==1);
indmoins=find(yapp==-1);

%---------------------------------------------------------------------%
%                      KernelPCA  + Linear Classifier                 %
%---------------------------------------------------------------------%

kernel='gaussian';
kerneloption=1;
max_eigvec=500;
[eigvect,eigval]=kernelpca(xapp,kernel,kerneloption);
max_eigvec=min([length(eigval) max_eigvec]);
appfeature=kernelpcaproj(xapp,xapp,eigvect,kernel,kerneloption,1:max_eigvec);
testfeature=kernelpcaproj(xapp,xtest,eigvect,kernel,kerneloption,1:max_eigvec);
c = 1000;
lambda =1e-7;
kerneloption = 1;
kernel='poly';
verbose = 0;
[xsup,w,b,pos]=svmclass(appfeature,yapp,c,lambda,kernel,kerneloption,verbose);
yestkpcasvm= svmval(testfeature,xsup,w,b,kernel,kerneloption);
ymestkpcasvm=reshape(yestkpcasvm,nx,nx);
%---------------------------------------------------------------------%
%                    Non Linear SVM Classifier                        %
%---------------------------------------------------------------------%
c = 1000;
lambda=1e-7;
kerneloption = 1;
kernel='gaussian';
verbose = 0;
[xsup,w,b,pos]=svmclass(xapp,yapp,c,lambda,kernel,kerneloption,verbose);
yestsvm= svmval(xtest,xsup,w,b,kernel,kerneloption);
ymestsvm=reshape(yestsvm,nx,nx);
%---------------------------------------------------------------------%
%                    Non Linear SVM Classifier                        %
%---------------------------------------------------------------------%
[cs,h1]=contour(x,y,ymestkpcasvm,[0 0],'r');
hold on
[cs,h2]=contour(x,y,ymestsvm,[0 0],'g');
legend([h1(1) h2(1)],'KPCA + linear SVM solution','NonLinear SVM')
set(gcf,'color','white');
plot(xapp(indplus,1),xapp(indplus,2),'b.');
plot(xapp(indmoins,1),xapp(indmoins,2),'b+');
hold off
