%IS_OCC Test for one-class classifiers
%
%    N = IS_OCC(W)
%
% INPUT
%   W    Classifier
%
% OUTPUT
%   N    0/1 if W isn't/is a one-class classifier
%
% DESCRIPTION
% IS_OCC(W) returns true if the classifier W is a one-class classifier,
% outputting only classes 'target' and/or 'outlier' and having a
% structure with threshold stored.
%
% Only problem is when you have an empty oc-classifier, this will
% return false. I cannot help it:-(
%
% SEE ALSO
% is_ocset, getoclab, target_class

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function out = is_occ(w)

% Zeroth check: do we have a prmapping?
if ~ismapping(w)
   out = 0;
   return
end

% First check: are the labels 'target' and/or 'outlier'?
lablist = getlabels(w);
switch size(lablist,1)
case 1
   out = strcmp(lablist,'target')|...
         strcmp(lablist,'target ')|...
         strcmp(lablist,'outlier');
case 2
   out = strcmp(lablist,['outlier';'target ']) | ...
         strcmp(lablist,['target ';'outlier']);
otherwise
   out = 0;
end

% Second check: is the field 'threshold' defined?
if out
  d = +w;
  if isstruct(d)
    fn = fieldnames(d);
    out = out & sum(strcmp(fn,'threshold'));
  end
  if ~out
    warning('dd_tools:NoThresholdInOCC',...
	 	'Missing threshold field in OC classifier.');
  end
end

return
