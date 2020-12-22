%
%  example of multiclass problem
%  
%
%
%  22/08/2002 AR
clear all
close all
n=50;   % examples per class
nbtest=50; %examples per class
nbiter=1;

classmeanvar=[-0.2 0.5;0.2 0.2 ; 1 0.3;1.5 0.2];
nbclass=size(classmeanvar,1);
for i=1:nbiter
    fprintf('%d...',i);
    xapp=[];
    yapp=[];
    yindice=[];
    %-------------------------------- DATA Generation --------------------------------% 
    for j=1:nbclass
        xapp=[xapp; classmeanvar(j,1)+classmeanvar(j,2)*randn(n,1)];
        yapp=[yapp;j*ones(n,1)];
    end;
    
    %---------------------------------------------------------------------------------%
    xtest=linspace(-1,2,nbtest)';
    
    c = 1000;
    lambda = 1e-7;
    kerneloption= 2;
    kernel='gaussian';
    verbose = 0;
    
    [xsup,w,b,nbsv,classifier]=svmmulticlassoneagainstone(xapp,yapp,nbclass,c,lambda,kernel,kerneloption,verbose);
    [ypred,maxi] = svmmultivaloneagainstone(xtest,xsup,w,b,nbsv,kernel,kerneloption);
    
    for j=1:nbclass;
        yindice=[yindice (ypred==j)']; 
        
    end;
    
end;

figure(1); hold on
for j=1:nbclass
    plot(xtest,normpdf(xtest,classmeanvar(j,1),classmeanvar(j,2)));
    plot(xtest,yindice(:,j),'r');
end;
title('pdf of each classes and Decision Boundaries of a 1v1 multiclass SVM');