
%
%  Example on toy problem of
%  WMW / AUC  optimisation with linear hypothesis
%  on a toy problem

clear all
close all
tic



n=4000;
sigma=0.5;
[x,y]=datasets('gaussian',n,0,sigma);



nbtrain=100;
kernel='poly';
kerneloption=[1];
margin=1;
kppv=inf;
C=100;
lambda = 1e-12;  
verbose=1;
span=1;
classcode=[1 -1];
qpsize=500;
kkttol=0.01;
%load toydatapouet
xapp=x;
yapp=y;

[xapp,yapp,xtest,ytest,indice]=CreateDataAppTest(x,y,nbtrain, classcode);
[xapp,xtest]=normalizemeanstd(xapp,xtest);

% % SVMROC
[xsup,w,w0,pos,timeps,alpha,matriceind]=svmroc(xapp,yapp,C,kppv,margin,lambda,kernel,kerneloption,verbose,span,qpsize,kkttol);
%[xsup,w,w0,pos,timeps,alpha,matriceind]=svmrocL2(xapp,yapp,C,kppv,margin,lambda,kernel,kerneloption,verbose,span,qpsize,kkttol);
%[xsup2,w2,w02,pos,timeps,alpha2,matriceind2]=svmrocL2CS(xapp,yapp,C,kppv,margin,lambda,kernel,kerneloption,verbose,span);

[AUC,tpr,fpr,w0]=svmroccurve(xapp,yapp,xsup,w,w0,kernel,kerneloption,span);
[AUCtest,tprt,fprt]=svmroccurve(xtest,ytest,xsup,w,w0,kernel,kerneloption,span);

[ypredapp]=svmrocval(xapp,xsup,w,w0,kernel,kerneloption,span);
[Confapp,metric]=ConfusionMatrix(sign(ypredapp),yapp,[1 -1]);Confapp

[ypredtest]=svmrocval(xtest,xsup,w,w0,kernel,kerneloption,span);
[Conftest,metric]=ConfusionMatrix(sign(ypredtest),ytest,[1 -1]);

metric
AUCtest
plot(xapp(yapp==1,1),xapp(yapp==1,2),'r+',xapp(yapp==-1,1),xapp(yapp==-1,2),'bx'); hold on

%---------------------------------------------------------------
[xsupsvm,wsvm,w0svm,possvm,timeps,alpha]=svmclassL2(xapp,yapp,C,lambda,kernel,kerneloption,verbose,span);
[AUC,tpr,fpr,w0svm]=svmroccurve(xapp,yapp,xsupsvm,wsvm,w0svm,kernel,kerneloption,span);
[ypredappsvm]=svmrocval(xapp,xsupsvm,wsvm,w0svm,kernel,kerneloption,span);
[Confappsvm,metric]=ConfusionMatrix(sign(ypredappsvm),yapp,[1 -1]);Confappsvm


%------- Building a 2D Grid for function evaluation -------------------------
%------------------------Plot the optimized points--------------%
indpos=(find(yapp==1));
indneg=(find(yapp==-1));
optpos=unique(matriceind(:,1));
optneg=unique(matriceind(:,2));
plot(xapp(indpos(optpos),1),xapp(indpos(optpos),2),'ro',xapp(indneg(optneg),1),xapp(indneg(optneg),2),'bo'); hold on
[xtest1 xtest2]  = meshgrid([-1:.05:1]*3.5,[-1:0.05:1]*3); 
nn = length(xtest1); 
xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 
ypred = svmrocval(xtest,xsup,w,w0,kernel,kerneloption,span); % ROC SVM
ypred = reshape(ypred,nn,nn); 
ypredsvm = svmrocval(xtest,xsupsvm,wsvm,w0svm,kernel,kerneloption,span); 
ypredsvm = reshape(ypredsvm,nn,nn); 
hold on
[cc,hh1]=contour(xtest1,xtest2,ypred,20);
[cc,hh1]=contour(xtest1,xtest2,ypred,[0 0],'k--');
%[cc,hh2]=contour(xtest1,xtest2,ypredsvm,20);
%legend([hh1(1) hh2(1)], 'SVM-ROC','SVM');
%figure
%plot(fpr,tpr);

% xsupsvm
% xsup{1},xsup{2}
% w
% wsvm
% yapp(possvm)