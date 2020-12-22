%DD_FP False Pos. rate for given false neg. rate
%
%    E = DD_FP(Z,W,ERR)
%
% INPUT
%   Z     One-class dataset
%   W     One-class classifier
%   ERR   False negative rate
%
% OUTPUT
%   E     False positive rate
%
% DESCRIPTION
% Change the threshold of a (trained) classifier W, such that the error
% on the target class (the fraction false negative) is set to ERR. The
% error on the outlier class, the false positive fraction, is then
% returned. The target and outlier data is extracted from dataset Z.
%
% SEE ALSO
% dd_error, dd_roc, dd_auc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function e = dd_fp(w,z,err)

% first find out where the output for the target objects are stored:
tcolumn = strmatch('target ',getlabels(w));
if isempty(tcolumn)
	error('Cannot find target objects in dataset.');
end

% compute the classifier output:
wz = +(z*w);
% sometimes it happens...
wz = real(wz);

if tcolumn~=1
	% then we are probably using 'normal' prtools classifiers, and in
	% that case, the outputs should be normalized
	if abs(sum(sum(wz)) - size(wz,1)) > 1e-9
		error('Are the classifier outputs normalized?');
  end
end

%find target and outliers
[It,Io] = find_target(z);
if isempty(It)||isempty(Io)
	error('Both target and outlier objects should be available!');
end
% set error on target set:
out = wz(It,:);
thr = dd_threshold(out(:,tcolumn),err);
% and compute error on outlier set:
out = wz(Io,:);
e = sum(out(:,tcolumn)>=thr)/length(Io);

return
