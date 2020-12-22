%function exroccurvemodelsel(data);

%

% Model Selection script of SVM-L2 ROC curve maximization
% with regards to different criterion such as AUC, Accuraccy
% precision or Fmeas

% 30/07/2004 A. Rakotomamonjy

clear all
close all

data='wpbc';
fprintf('ModelSelection\n');
file=['../data/' data '/' data '.mat'];
load(file);

nbtrain=round(length(y)*0.90);
classcode=[1 -1];




kernel='gaussian';
span=1;
lambda = 1e-12;  

Cvec=[0.1 0.5 1 5 10 50 100 500 1000];
kerneloptionvec=[ 0.5 1 1.5 2 2.5 3 5 10 15];
% Cvec=[0.1 0.5 ];
%  kerneloptionvec=[0.5 0.75];
verbose=0;
for i=1:5
    fprintf('%d..',i);
    [Xapp,Yapp,xtest,ytest]=nfcv(x,y,5,i);
    [Xapp,xtest] = normalizemeanstd(Xapp,xtest);
    for m=1:5
        [xapp,yapp,xval,yval]=nfcv(Xapp,Yapp,5,m);
        for j=1:length(Cvec) 
            C=Cvec(j);
            for k=1:length(kerneloptionvec)
                kerneloption=kerneloptionvec(k);
                [xsup,w,w0,pos,tps,alpha] = svmclassL2(xapp,yapp,C,lambda,kernel,kerneloption,verbose); 
                [AUCval,tpr,fpr]=svmroccurve(xval,yval,xsup,w,w0,kernel,kerneloption,span);
                [ypred]=svmval(xval,xsup,w,w0,kernel,kerneloption,span);
                [Conf,metric]=ConfusionMatrix(sign(ypred),yval,classcode);
                MAUC(j,k,m)=AUCval;
                Maccur(j,k,m)=metric.accuracy;
                Mprecision(j,k,m)=metric.precision;
                Mfmeasure(j,k,m)=metric.fmeasure;
                Mwracc(j,k,m)=metric.wracc;
                Mdetection(j,k,m)=metric.detection;
            end;
        end;
    end;
    mauctest=mean(MAUC,3);
    maccur=mean(Maccur,3);
    mprecision=mean(Mprecision,3);
    mfmeasure=mean(Mfmeasure,3);
    mwracc=mean(Mwracc,3);
    mdetection=mean(Mdetection,3);
    
    % AUC
    [aux,indj]=max(max(mauctest));
    [aux,indi]=max(max(mauctest'));
    C=Cvec(indi);
    kerneloption=kerneloptionvec(indj);
    
    [xsup,w,w0,pos,tps,alpha] = svmclassL2(Xapp,Yapp,C,lambda,kernel,kerneloption,verbose); 
    [AUCtest,tpr,fpr]=svmroccurve(xtest,ytest,xsup,w,w0,kernel,kerneloption,span);
    [ypred]=svmval(xtest,xsup,w,w0,kernel,kerneloption,span);
    [Conf,metric]=ConfusionMatrix(sign(ypred),ytest,classcode);
    auctest(i)=AUCtest;
    aucval(i)=aux;

    % accur
    [aux,indj]=max(max(maccur));
    [aux,indi]=max(max(maccur'));
    C=Cvec(indi);
    kerneloption=kerneloptionvec(indj);
    [xsup,w,w0,pos,tps,alpha] = svmclassL2(Xapp,Yapp,C,lambda,kernel,kerneloption,verbose); 
    [ypred]=svmval(xtest,xsup,w,w0,kernel,kerneloption,span);
    [Conf,metric]=ConfusionMatrix(sign(ypred),ytest,classcode);
    accur(i)=metric.accuracy;
    accurval(i)=aux;
    
     % precision
    [aux,indj]=max(max(mprecision));
    [aux,indi]=max(max(mprecision'));
    C=Cvec(indi);
    kerneloption=kerneloptionvec(indj);
    [xsup,w,w0,pos,tps,alpha] = svmclassL2(Xapp,Yapp,C,lambda,kernel,kerneloption,verbose); 
    [ypred]=svmval(xtest,xsup,w,w0,kernel,kerneloption,span);
    [Conf,metric]=ConfusionMatrix(sign(ypred),ytest,classcode);
    prec(i)=metric.precision;
    precval(i)=aux;
         % fmeasure
    [aux,indj]=max(max(mfmeasure));
    [aux,indi]=max(max(mfmeasure'));
    C=Cvec(indi);
    kerneloption=kerneloptionvec(indj);
    [xsup,w,w0,pos,tps,alpha] = svmclassL2(Xapp,Yapp,C,lambda,kernel,kerneloption,verbose); 
    [ypred]=svmval(xtest,xsup,w,w0,kernel,kerneloption,span);
    [Conf,metric]=ConfusionMatrix(sign(ypred),ytest,classcode);
    fmeas(i)=metric.fmeasure;
    fmeasval(i)=aux;
end;






save([data 'modelsel.mat']);


