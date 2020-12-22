%
%  SVM Classification 2D examples
%  with different kernels (including wavelets) and different penalization settings
%
%  05/05/03 AR


clear all
close all
tic
n = 500; 

sigma=0.3;
[Xapp,yapp,xtest,ytest]=datasets('gaussian',n,0,sigma);
[Xapp]=normalizemeanstd(Xapp);


 
lambda = 1e-12;  
C = 1;
 kernel='poly';
 kerneloption=2;
 qpsize=10;
 verbose=1;
 span=1;
[xsup,w,w0,pos,tps,alpha] = svmclassL2LS(Xapp,yapp,C,lambda,kernel,kerneloption,verbose,span,qpsize); 
[xsup1,w1,w01,pos1,tps,alpha1] = svmclassL2(Xapp,yapp,C,lambda,kernel,kerneloption,verbose,span); 

% max(w1-w)
% break

ypredapp = svmval(Xapp,xsup,w,w0,kernel,kerneloption,1);

%------- Building a 2D Grid for function evaluation -------------------------
[xtest1 xtest2]  = meshgrid([-1:.05:1]*3.5,[-1:0.05:1]*3); 
nn = length(xtest1); 
Xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 



%--------------  Evaluating the decision function
ypred = svmval(Xtest,xsup,w,w0,kernel,kerneloption,[ones(length(Xtest),1)]);
ypred = reshape(ypred,nn,nn); 
 ypred1 = svmval(Xtest,xsup1,w1,w01,kernel,kerneloption,[ones(length(Xtest),1)]);
ypred1 = reshape(ypred1,nn,nn); 

%--------------- plotting
figure(1); 
clf; 
%contourf(xtest1,xtest2,ypred,50);shading flat;
hold on
[cc,hh]=contour(xtest1,xtest2,ypred,[-1  0 1],'k');
[cc,hh]=contour(xtest1,xtest2,ypred1,[-1  0 1],'m:');
clabel(cc,hh); 
set(hh,'LineWidth',2);
h1=plot(Xapp(yapp==1,1),Xapp(yapp==1,2),'+r'); 
set(h1,'LineWidth',2);

h2=plot(Xapp(yapp==-1,1),Xapp(yapp==-1,2),'db'); 
set(h2,'LineWidth',2);
h3=plot(xsup(:,1),xsup(:,2),'ok'); 
set(h3,'LineWidth',2);




axis([-3.5 3.5 -3 3]); 

 

