%FN_GIVEN_FP   Estimate FNr for a fixed FPr
%
%   FN = FN_GIVEN_FP(D,FN)
%
% INPUT
%  D     One-class dataset
%  FP    False positive rate
%
% OUTPUT
%  FN    False negative rate
%
% DESCRIPTION
% Compute the false negative rate FN, given a maximum false positive
% rate FP on dataset D (where D is typically the output of a classifier
% like D =A*W).
%
% SEE ALSO
%   fp_given_fn, dd_error

function fn = fn_given_fp(d,fp)

% find the outputs of the outlier objects:
[targ,outl] = target_class(d);
pred = outl(:,'target');
% set the threshold such that (1-FP)% goes correctly
thr = dd_threshold(pred,1-fp);
% now see what the FN becomes
I = (targ(:,'target')<thr);
fn = mean(I);

