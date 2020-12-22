%function exrankboost1(data);


%  Model Selection for analysing rankboost performance 
%  on ROC curve optimization  with real data 
% 
% This code has been used in the SVM-AUC TechRep

% 30/07/2004 A. Rakotomamonjy


clear all
close all

data='credit';
file=['../data/' data '/' data '.mat'];
load(file);
nbtrain=300;
classcode=[1 -1];






Tvec=[50 100];
verbose=0;

for i=1:20
    fprintf('%d..',i);
   [xapp,yapp,xtest,ytest,indice]=CreateDataAppTest(x,y,nbtrain, classcode);
   [xapp,xtest] = normalizemeanstd(xapp,xtest);
    for j=1:length(Tvec) 
        T=Tvec(j);
        fprintf('-');
        [alpha,threshold,rankfeat]=rankboostAUC(xapp,yapp,T);
         ypred=rankboostAUCval(xapp,alpha,threshold,rankfeat,T);
        [AUC,tpr,fpr,b]=rankroccurve(ypred,yapp);
        ypredtest=rankboostAUCval(xtest,alpha,threshold,rankfeat,T);
        [AUCtest,tpr,fpr]=rankroccurve(ypredtest,ytest);
        [Conf,metric]=ConfusionMatrix(sign(ypredtest+b),ytest,classcode);

        MAUCtest(j,i)=AUCtest;
        Maccur(j,i)=metric.accuracy;
        Mprecision(j,i)=metric.precision;
        Mfmeasure(j,i)=metric.fmeasure;
        Mwracc(j,i)=metric.wracc;
        Mdetection(j,i)=metric.detection;
    end;
    
    

end;

mauctest=mean(MAUCtest,2);
maccur=mean(Maccur,2);
mprecision=mean(Mprecision,2);
mfmeasure=mean(Mfmeasure,2);
mwracc=mean(Mwracc,2);
mdetection=mean(Mdetection,2);

% sauctest=std(MAUCtest,0,2);
% saccur=std(Maccur,0,2);
% sprecision=std(Mprecision,0,3);
% sfmeasure=std(Mfmeasure,0,3);
% swracc=std(Mwracc,0,3);
% sdetection=std(Mdetection,0,3);


mauctest=mean(MAUCtest,2);
maccur=mean(Maccur,2);

%save([data 'rank.mat'])

