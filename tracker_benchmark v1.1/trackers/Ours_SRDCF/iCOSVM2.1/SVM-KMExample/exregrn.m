%
% Example of Checker Data
% classification with regularization networks
%
%

clear all
close all

%-------------------------------------------------------------------
%                           Datasets
%-------------------------------------------------------------------

nbapp=100;
nbtest=500;
sigma=1;
xapp=linspace(0,5,nbapp)';
xtest=linspace(0,5,nbtest)';
yapp=cos(exp(xapp))+2 + sigma*randn(nbapp,1);
ytest=cos(exp(xtest))+2;

%-------------------------------------------------------------------
%                        Regularization Networks Parameters
%-------------------------------------------------------------------


lambda = 0.05;  
kernel='gaussian';
kerneloption=1;
[c,d]=rncalc(xapp,yapp,kernel,kerneloption,lambda);
ypred=rnval(xapp,xtest,kernel,kerneloption,c,d);

% ypred = reshape(ypred,nn,nn); 
% 
% %-------------------------------------------------------------------
% %                         Plotting
% %-------------------------------------------------------------------
% 

plot(xapp,yapp,'b',xtest,ytest,'r',xtest,ypred,'k')