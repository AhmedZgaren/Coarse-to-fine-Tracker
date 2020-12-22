%
%    Example of ROC curve with SVM  
%    and real data
%

% 30/07/2004 A. Rakotomamonjy

clear all
close all
tic

data='sonar';
svm='L1'
file=['../data/' data '/' data '.mat'];
load(file);
classcode=[1 -1];



[xapp,yapp,xtest,ytest]=nfcv(x,y,10,1);
[xapp,xtest]=normalizemeanstd(xapp,xtest);




lambda = 1e-7;  
C=0.1;
kernel='gaussian';
kerneloption=0.5;
span=1;qpsize=100;verbose=1;

if strcmp(svm,'L2')
    if size(xapp,1)< 1000
        [xsup,w,w0,pos,tps,alpha] = svmclassL2(xapp,yapp,C,lambda,kernel,kerneloption,1); 
    else
        [xsup,w,w0,pos,tps,alpha] = svmclassL2LS(xapp,yapp,C,lambda,kernel,kerneloption,1,span,qpsize);
    end;
else
    if size(xapp,1)< 1000
        [xsup,w,w0,pos,tps,alpha] = svmclass(xapp,yapp,C,lambda,kernel,kerneloption,1); 
    else
        [xsup,w,w0,pos,tps,alpha] = svmclassLS(xapp,yapp,C,lambda,kernel,kerneloption,1,span,qpsize);
        
    end;
end


[AUC,tpr,fpr]=svmroccurve(xtest,ytest,xsup,w,w0,kernel,kerneloption,span);
[ypred]=svmval(xtest,xsup,w,w0,kernel,kerneloption,span);
AUC
[C,metric]=ConfusionMatrix(sign(ypred),ytest,classcode);
C
figure
h=plot(fpr,tpr,'k',0:0.1:1,0:0.1:1,'k:');
set(gcf,'color','white');
set(h,'LineWidth',2);
h=xlabel('False Positive Rate');
set(h,'Fonts',16);
h=ylabel('True Positive Rate');
set(h,'Fonts',16);
h=title('ROC curve ');
set(h,'Fonts',16);


