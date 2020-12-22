%
%  SVM Classification 2D examples
%  with a kernel processed outside of svmclass and without knowledge of x 
%
%  05/05/03 AR


clear all
close all

n = 100; 

sigma=0.5;
[xapp,yapp,xtest,ytest]=datasets('clowns',n,0,sigma);
[xapp]=normalizemeanstd(xapp);
%------- Building a 2D Grid for function evaluation -------------------------
[xtest1 xtest2]  = meshgrid([-1:.05:1]*3.5,[-1:0.05:1]*3); 
nn = length(xtest1); 
xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 



 
lambda = 1e-7;  
C = 1000;
sigmakernel=1;
K=svmkernel(xapp,'gaussian',sigmakernel);
kerneloption.matrix=K;
kernel='numerical';
[xsup,w,w0,pos,tps,alpha] = svmclass(xapp,yapp,C,lambda,kernel,kerneloption,1); 
% 

size(w)

%--------------  Evaluating the decision function
kerneloption.matrix=svmkernel(xtest,'gaussian',sigmakernel,xsup);
ypred = svmval(xtest,xapp,w,w0,kernel,kerneloption,[ones(length(xtest),1)]);



 

%--------------- plotting
ypred = reshape(ypred,nn,nn); 
figure; 
clf; 
contourf(xtest1,xtest2,ypred,50);shading flat;
hold on
[cc,hh]=contour(xtest1,xtest2,ypred,[-1  0 1],'k');
clabel(cc,hh); 
set(hh,'LineWidth',2);
h1=plot(xapp(yapp==1,1),xapp(yapp==1,2),'+k'); 
set(h1,'LineWidth',2);

h2=plot(xapp(yapp==-1,1),xapp(yapp==-1,2),'dk'); 
set(h2,'LineWidth',2);



axis([-3.5 3.5 -3 3]); 

 
% 
