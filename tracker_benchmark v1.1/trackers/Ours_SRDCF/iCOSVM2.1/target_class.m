% TARGET_CLASS  extracts the target class from an one-class dataset
%
%    [B,C] = TARGET_CLASS(A,CLNR)
%
% INPUT
%   A      One-class dataset
%   CLNR   Class number or class label (default = 'target')
%
% OUTPUT
%   B      Dataset with only target class
%   C      Dataset with remaining objects
%
% DESCRIPTION
% Extract the target class from an one-class dataset. When the label
% CLNR is given, the class indicated by this label is taken.
% When a second output argument C is requested, the remaining data is
% stored in C.
%
% SEE ALSO
% oc_set, gendatoc, find_target, relabel

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function [a,b] = target_class(a,clnr)
if (nargin<2)
  clnr = 'target';
end

% Be sure we are working with an OC set:
[a,I] = oc_set(a,clnr);

% Extract just the target objects:
It = find(I==1);
if isempty(It) && (nargout==1)
	error('Cannot find target class objects!');
end

% On request, also return the outlier objects:
% (do this before the construction of the target-class dataset, because
% in that construction the outlier data is removed)
if nargout>1
	Io = find(I==2);
	b = a(Io,:);
	%DXD  Now the question becomes, should we reduce the lablist to just
	% 'outlier'??
	b = setnlab(b,ones(length(Io),1));
	b = setlablist(b); % remove empty classes.
	b = setlablist(b,'outlier');
end

% and what it was all about:
a = a(It,:);
%DXD  Now the question becomes, should we reduce the lablist to just
% 'target'??
a = setlablist(a); % remove empty classes from the lablist
a = setnlab(a,ones(length(It),1));
a = setlablist(a,'target');

return


