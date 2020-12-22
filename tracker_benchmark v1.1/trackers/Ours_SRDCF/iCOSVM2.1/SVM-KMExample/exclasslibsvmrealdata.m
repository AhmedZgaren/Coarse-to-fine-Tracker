%
%  SVM Classification 2D examples
%  with different kernels (including wavelets) and different penalization settings
%
%  05/05/03 AR


clear all
close all
nbitermax=1;


nbtrain=100;




%--- real data ------------
data='ionosphere';
file=['../data/' data '/' data '.mat'];
load(file);



kerneloption=[3];
C =1;
kernel='gaussian';
classcode=[1 -1];


lambda = 1e-10;  
verbose=1;
span=1;
qpsize=100;
chunksize=qpsize;
for iter=1:nbitermax
    [xapp,yapp,xtest,ytest,indice]=CreateDataAppTest(x,y,nbtrain, classcode);
xapp=single(xapp);
    [xapp,xtest]=normalizemeanstd(xapp,xtest);
    Ind=randperm(nbtrain);
    yapp=yapp(Ind);
    xapp=xapp(Ind,:);
    
    [xsup,w,w0] = svmclass(xapp,yapp,C,lambda,kernel,kerneloption,verbose,span); 
    ypred(iter) = mean(sign(svmval(xtest,xsup,w,w0,kernel,kerneloption,span))~=ytest);
    
    %--------------------------------
    [xsup1,w1,w01] = svmclasslib(xapp,yapp,C,lambda,kernel,kerneloption,verbose,span); 
    ypredlib(iter) = mean(sign(svmvallib(xtest,xsup1,w1,w01,kernel,kerneloption,span))~=ytest);
    w0-w01

    
end;
ypred
ypredlib
