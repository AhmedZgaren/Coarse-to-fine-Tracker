%
%
%   Example of Large-Scale Classification problem
%
%
%


clear all
close all
tic
n = 7000; 
nbtest=1600;
sigma=0.3;  % This problem needs around a thousand iteration 
            % you can speed up the example by setting sigma=0.3 for instance    
[Xapp,yapp]=datasets('checkers',n,0,sigma);


lambda = 1e-10;  
C = 10;
kernel='gaussian';
kerneloption=0.3;
qpsize=1000;
chunksize=1000;
verbose=1;
span=[];
[xsup,w,w0,pos,tps,alpha,status,cost] = svmclassLS(Xapp,yapp,C,lambda,kernel,kerneloption,verbose,span,qpsize,chunksize); 
%[xsup,w,b,pos,timeps,alpha,obj]=svmclass(Xapp,yapp,C,lambda,kernel,kerneloption,verbose,span);
%break

%------- Building a 2D Grid for function evaluation -------------------------

[xtest1 xtest2]  = meshgrid(linspace(-4,4,sqrt(nbtest))); 
nn = length(xtest1); 
Xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 



%--------------  Evaluating the decision function
ypred = svmval(Xtest,xsup,w,w0,kernel,kerneloption,[ones(length(Xtest),1)]);
ypred = reshape(ypred,nn,nn); 
 

%--------------- plotting
figure(1); 
clf; 
contourf(xtest1,xtest2,ypred,50);shading flat;
hold on
[cc,hh]=contour(xtest1,xtest2,ypred,[-1  0 1],'k');
clabel(cc,hh); 
h1=plot(Xapp(yapp==1,1),Xapp(yapp==1,2),'+r'); 
set(h1,'LineWidth',2);

h2=plot(Xapp(yapp==-1,1),Xapp(yapp==-1,2),'db'); 
set(h2,'LineWidth',2);
h3=plot(xsup(:,1),xsup(:,2),'ok'); 
set(h3,'LineWidth',2);

toc



 

