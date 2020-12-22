%FP_GIVEN_FN   Estimate FPr for a fixed FNr
%
%   FP = FP_GIVEN_FN(D,FN)
%
% INPUT
%  D     One-class dataset
%  FN    False negative rate
%
% OUTPUT
%  FP    False positive rate
%
% DESCRIPTION
% Compute the false positive rate FP, given a maximum false negative
% rate FN on dataset D (where D is typically the output of a classifier
% like D =A*W).
%
% SEE ALSO
%   fn_given_fp, dd_error

function fp = fp_given_fn(d,fn)

% find the outputs of the target objects:
[targ,outl] = target_class(d);
pred = targ(:,'target');
% set the threshold such that (1-FN)% goes correctly
thr = dd_threshold(pred,fn);
% now see what the FP becomes
I = (outl(:,'target')>thr);
fp = mean(I);

