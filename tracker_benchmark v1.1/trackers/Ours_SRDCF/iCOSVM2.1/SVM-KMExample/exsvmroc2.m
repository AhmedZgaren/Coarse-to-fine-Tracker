function exsvmroc2(data,margin,kppv,Cvec,kerneloptionvec);

%
%  code for big cross-validation procedure for
%  SVM-ROC on real data.
%
% 

% 30/07/2004 A. Rakotomamonjy


% clear all
% close all

% data='wpbc';
% 
% kppv=5;
% 
% Cvec=[0.1 1          10          ];
% kerneloptionvec=[5 ];

file=['../data/' data '/' data '.mat'];
load(file);

nbtrain=round(length(y)*0.90);
classcode=[1 -1];


margin=0.01;

kernel='gaussian';
span=1;
lambda = 1e-12;  


verbose=1;
span=1;
qpsize=500;




NCV=10;
for i=1:NCV
    fprintf('\n%d..',i);
    [xapp,yapp,xtest,ytest]=nfcv(x,y,NCV,i);
    [xapp,xtest] = normalizemeanstd(xapp,xtest);
    for j=1:length(Cvec) 
        C=Cvec(j);
        for k=1:length(kerneloptionvec)
            kerneloption=kerneloptionvec(k);
            
            
            [xsup,w,w0,pos,timeps,alpha]=svmroc(xapp,yapp,C,kppv,margin,lambda,kernel,kerneloption,verbose,span,qpsize);
            [AUC,tpr,fpr,w0]=svmroccurve(xapp,yapp,xsup,w,w0,kernel,kerneloption,span); % calcul de w0
            
            [AUCtest,tpr,fpr]=svmroccurve(xtest,ytest,xsup,w,w0,kernel,kerneloption,span);
            [ypred]=svmrocval(xtest,xsup,w,w0,kernel,kerneloption,span);
            [Conf,metric]=ConfusionMatrix(sign(ypred),ytest,classcode);
            nbsv(j,k,i)=size(xsup,1);
            MAUCtest(j,k,i)=AUCtest;
            Maccur(j,k,i)=metric.accuracy;
            Mprecision(j,k,i)=metric.precision;
            Mfmeasure(j,k,i)=metric.fmeasure;
            Mwracc(j,k,i)=metric.wracc;
            Mdetection(j,k,i)=metric.detection;
        end;
    end;
end;
mauctest=mean(MAUCtest,3);
maccur=mean(Maccur,3);
mprecision=mean(Mprecision,3);
mfmeasure=mean(Mfmeasure,3);
mwracc=mean(Mwracc,3);
mdetection=mean(Mdetection,3);

sauctest=std(MAUCtest,0,3);
saccur=std(Maccur,0,3);
sprecision=std(Mprecision,0,3);
sfmeasure=std(Mfmeasure,0,3);
swracc=std(Mwracc,0,3);
sdetection=std(Mdetection,0,3);



save([data 'OptimMarginGaussian' int2str(margin*100) '-kppv' int2str(kppv)    '.mat']);


