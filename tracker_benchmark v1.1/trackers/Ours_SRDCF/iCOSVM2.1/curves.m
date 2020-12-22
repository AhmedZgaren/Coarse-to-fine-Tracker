% Example of the precision-recall curve, an hit-rate vs. false alarm
% rate curve, and a comparison with the Receiver-Operating
% Characteristic Curve

%a = oc_set(gendatb([2000,250],2),1);
 rbfvals=load('rbfvals.dat');
fracrej=0.2;
prdatasets
a=diabetes;
%   a = mit_cbcl;
  a= setprior(a,0);
  a= oc_set(a,'absent');
for j=1:10
    for k=1:10
        w1 = incsvdd(a,fracrej,'e',rbfvals(k,j))*dd_normc;
        w2 = incsvc (a,'e',rbfvals(k,j),1);
        w3 = inccosvc (a,'mahal',rbfvals(k,j),1,0);
        w4 = inccosvc (a,'cov',rbfvals(k,j),1,0);
    end
end

% figure(1); clf; scatterd(a);
% h1 = plotc(w1,'b'); h2 = plotc(w2,'k'); h3 = plotc(w3,'r');
% legend([h1 h2 h3],'LDA','Gauss','AUClpm');

figure(2); clf;
h1 = plotroc(a*w1*dd_roc,'b');
h2 = plotroc(a*w2*dd_roc,'k');
h3 = plotroc(a*w3*dd_roc,'r');
h4 = plotroc(a*w3*dd_roc,'k--');

legend([h1 h2 h3 h4],'iSVDD','iSVC','iSVMM','iCOSVM');
title('ROC curve');

% figure(3); clf;
% plotroc(a*w1*dd_prc,'b');
% plotroc(a*w2*dd_prc,'k');
% plotroc(a*w3*dd_prc,'r');
% plotroc(a*w4*dd_prc,'--r');
% legend('iSVDD','iSVC','iSVMM','iCOSVM');
% title('Precision-recall curve');
% 
% figure(4); clf;
% plotroc(roc2hit(a*w1*dd_roc),'b');
% plotroc(roc2hit(a*w2*dd_roc),'k');
% plotroc(roc2hit(a*w3*dd_roc),'r');
% plotroc(roc2hit(a*w4*dd_roc),'--r');
% legend('iSVDD','iSVC','iSVMM','iCOSVM');
% title('False Alarm vs. Hit-rate');
% 
