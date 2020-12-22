%
%  example of multiclass problem
%  This is the one that can be found in 
%   Lin & Wahba Tech Rep 
%
%
%
%  22/08/2002 AR
clear all
close all
n=100;
nbtest=500;
nbiter=10;

for i=1:nbiter
    fprintf('%d...',i);
    x=rand(n,1);
    auxy=rand(n,1);
    xtest=linspace(0,1,nbtest)';
    auxytest=rand(nbtest,1);
    %-------------------------------- DATA Generation --------------------------------% 
    p1=0.97*exp(-3*x);
    p3= exp(-2.5*(x-1.2).^ 2);
    p2=1-p1-p3;
    y= 1*(auxy <=p1) + 2*(auxy > p1 &auxy <=p1+p2) + 3*(auxy > p1+p2 &auxy <=p1+p2 +3);
    p1=0.97*exp(-3*xtest);
    p3= exp(-2.5*(xtest-1.2).^ 2);
    p2=1-p1-p3;
    ytest= 1*(auxytest <=p1) + 2*(auxytest > p1 &auxytest <=p1+p2) + 3*(auxytest > p1+p2 &auxytest <=p1+p2 +3);
    %plot(x,y,'rx',xtest,ytest,'bx');
    
    %--------------------------------- Real pdf  --------------------------------------% 
    x1=linspace(0,1,1000);
    p1=0.97*exp(-3*x1);
    p3= exp(-2.5*(x1-1.2).^ 2);
    p2=1-p1-p3;
    %---------------------------------------------------------------------------------%
    
    nbclass=3;
    c = 1000;
    lambda = 1e-7;
    kerneloption= 1;
    kernel='gaussian';
    verbose = 0;
    
    [xsup,w,b,nbsv,classifier]=svmmulticlassoneagainstone(x,y,nbclass,c,lambda,kernel,kerneloption,verbose);
    [ypred,maxi] = svmmultivaloneagainstone(xtest,xsup,w,b,nbsv,kernel,kerneloption);
    ypred1=ypred==1;
    ypred2=ypred==2;
    ypred3=ypred==3;
    
    %  Estimating the Bayes Threshold for the problem
    ind1=find(ypred1==1);
    if ~isempty(ind1)
        bayesthresh1(i)=xtest(ind1(end));
    else
        bayesthresh1(i)=0;
    end;
    
    ind3=find(ypred3==1);
    if ~isempty(ind3)
        bayesthresh3(i)=xtest(ind3(1));
    else
        bayesthresh1(i)=1;
    end;
    
end;

fprintf('\nMean Threshold 1:%2.2f \t  \t 2: %2.2f \n', mean(bayesthresh1),mean(bayesthresh3));

figure(1);
plot(x1,p1,'r',x1,p2,'b',x1,p3,'k');
legend('Class 1','Class 2', 'Class 3');
title('Conditional probabilities of each class');
hold on
plot(xtest,ypred1,'r',xtest,ypred2,'b',xtest,ypred3,'k');