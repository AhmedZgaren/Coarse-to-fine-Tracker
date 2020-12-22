%  example of rankboost algorithm on real data.
%
%
%

% 30/07/2004 A. Rakotomamonjy


clear all
close all


n = 2000; 
sigma=0.5;
[x,y]=datasets('gaussian',n,0,sigma);
nbtrain=1000;
classcode=[1 -1];



%Data and Data parameters
% data='yeast';
% file=['../data/' data '/' data '.mat'];
% load(file);
% classcode=[1 -1];
% nbtrain=150;


% algorithm parameters

T=100;
[xapp,yapp,xtest,ytest,indice]=CreateDataAppTest(x,y,nbtrain, classcode);
[xapp,xtest]=normalizemeanstd(xapp,xtest);
% 
% xapp=[0 1 2 3 4 5 6 2.17 8 9;
%       0 1 2 3 4 5 6 7 3.1 9]';

[alpha,threshold,rankfeat]=rankboostAUC(xapp,yapp,T);
ypred=rankboostAUCval(xapp,alpha,threshold,rankfeat,T);
[AUC,tpr,fpr,b]=rankroccurve(ypred,yapp);
ypredtest=rankboostAUCval(xtest,alpha,threshold,rankfeat,T);
[AUCtest,tprt,fprt]=rankroccurve(ypredtest,ytest);
[Conf,metric]=ConfusionMatrix(sign(ypredtest+b),ytest,classcode);
AUC
AUCtest
metric
figure
plot(xapp(yapp==1,1),xapp(yapp==1,2),'r+',xapp(yapp==-1,1),xapp(yapp==-1,2),'bx'); hold on
[xtest1 xtest2]  = meshgrid([-1:.05:1]*3.5,[-1:0.05:1]*3); 
nn = length(xtest1); 
xtest = [reshape(xtest1 ,nn*nn,1) reshape(xtest2 ,nn*nn,1)]; 
ypred =rankboostAUCval(xtest,alpha,threshold,rankfeat,T);
ypred = reshape(ypred,nn,nn); 
hold on
[cc,hh1]=contour(xtest1,xtest2,ypred,3);
% figure
% plot(fpr,tpr,'r',fprt,tprt,'b');
% legend('Learning Set','Testing Set');