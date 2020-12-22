%GETOCLAB  Get numeric labels from an OC set
%
%    LAB = GETOCLAB(X)
%
% INPUT
%   X     One-class dataset
%
% OUTPUT
%   LAB   Numeric labels, +1/-1
%
% DESCRIPTION
% Returns numeric labels of the objects X according to:
%   'target'  : +1
%   'outlier' : -1
% If X is not an OC-set, an error is generated.
%
% SEE ALSO
% isocset, isocc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function lab = getoclab(x)

if isocset(x)
	n = size(x,1);
	lab = -ones(n,1);
	lab(find_target(x)) = 1;
else
	error('Dataset is not a One-class dataset.');
end

return
