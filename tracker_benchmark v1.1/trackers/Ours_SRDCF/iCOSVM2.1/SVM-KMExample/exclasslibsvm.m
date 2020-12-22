%



clear all
close all

n = 500; 

sigma=1.3;
[Xapp,yapp,xtest,ytest]=datasets('clowns',n,0,sigma);
[Xapp]=normalizemeanstd(Xapp);


 
lambda = 1e-7;  
C = 10;
 kernel='gaussian';
 kerneloption=2;
 verbose=1;
 span=1;

tic;[xsup,w,w0,pos,tps,alpha] = svmclass(Xapp,yapp,C,lambda,kernel,kerneloption,verbose,span); toc
tic; [xsup1,w1,w01]=svmclasslib(Xapp,yapp,C,lambda,kernel,kerneloption,verbose,span);toc


[xtest1 xtest2]  = meshgrid([-1:.01:1]*3.5,[-1:0.01:1]*3); 
nn = length(xtest1); 
Xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 



%--------------  Evaluating the decision function
tic;
ypred = svmval(Xtest,xsup,w,w0,kernel,kerneloption,[ones(length(Xtest),1)]);toc
ypred = reshape(ypred,nn,nn); 
tic
ypredlib=svmvallib(Xtest,xsup1,w1,w01,kernel,kerneloption,span);toc

ypredlib = reshape(ypredlib,nn,nn); 
 

%--------------- plotting
figure(2); 
clf; 
%contourf(xtest1,xtest2,ypred,50);shading flat;
hold on
[cc,hh]=contour(xtest1,xtest2,ypred,[-1  0 1],'k');
clabel(cc,hh); 
[cc,hh]=contour(xtest1,xtest2,ypredlib,[-1  0 1],'r:');
clabel(cc,hh); 
set(hh,'LineWidth',2);
h1=plot(Xapp(yapp==1,1),Xapp(yapp==1,2),'+r'); 
set(h1,'LineWidth',2);

h2=plot(Xapp(yapp==-1,1),Xapp(yapp==-1,2),'db'); 
set(h2,'LineWidth',2);
h3=plot(xsup(:,1),xsup(:,2),'ok'); 
set(h3,'LineWidth',2);




axis([-3.5 3.5 -3 3]); 

 

