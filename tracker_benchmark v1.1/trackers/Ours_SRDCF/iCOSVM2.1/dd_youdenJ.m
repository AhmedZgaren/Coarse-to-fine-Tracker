%DD_YOUDENJ compute the Youden J score 
%
%   E = DD_YOUDENJ(X,W)
%   E = DD_YOUDENJ(X*W)
%   E = X*W*DD_YOUDENJ
%
% INPUT
%   X    One-class dataset
%   W    One-class classifier
%
% OUTPUT
%   E    Youden J performance
%
% DESCRIPTION
% Compute the Youden J score of a dataset, defined as:
%
%     J  = max_t sensitivity(t) + specificity(t) - 1
%
% where t is the threshold that is optimized.
%
% SEE ALSO
% dd_f1, dd_error, dd_roc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function e = dd_youdenJ(x,w)

% Do it the same as testc:
% When no input arguments are given, we just return an empty mapping:
if nargin==0
	
	e = prmapping(mfilename,'fixed');
   e = setname(e,'YoudenJ');
	return

elseif nargin == 1
	% Now we are doing the actual work, our input is a mapped dataset:

	% get the roc curve
	r = dd_roc(x);

	% and compute J:
   % (in the ROC curve we stored the FNr and FPR, and we need the TPr
   % and TNr)
   n = size(r.err,1);
   J = ones(n,1) - r.err(:,1) - r.err(:,2);
   e = max(J);

else

	ismapping(w);
	istrained(w);

	e = feval(mfilename,x*w);

end

return

