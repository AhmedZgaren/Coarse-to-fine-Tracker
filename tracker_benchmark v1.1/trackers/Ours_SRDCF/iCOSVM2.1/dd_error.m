%DD_ERROR compute false negative and false positive rate for oc_classifier
%
%   E = DD_ERROR(X,W)
%   E = DD_ERROR(X*W)
%   E = X*W*DD_ERROR
%   [E,F,G] = DD_ERROR(X,W)
%
% INPUT
%   X     One-class dataset
%   W     One-class classifier
%
% OUTPUT
%   E     False positive and false negative rates
%   F     Precision and recall
%   G     Hit and false alarm rate
%
% DESCRIPTION
% Compute the fraction of target objects rejected and the fraction of outliers
% accepted for dataset X on the trained mapping W:
%    E(1) = target rejected     (false negative)
%    E(2) = outlier accepted    (false positive)
% When two or three outputs are requested, the second output F will contain:
%    F(1) = precision
%    F(2) = recall
% and the third output contains:
%    G(1) = hit rate
%    G(2) = false alarm rate
%
% SEE ALSO
% dd_eer, dd_roc, gendatoc, plotroc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function [e,f,g] = dd_error(x,w)

% Do it the same as testc:
% When no input arguments are given, we just return an empty mapping:

if nargin==0
	
	% Sometimes Prtools is crazy, but fun!:
	e = prmapping(mfilename,'fixed');
   e = setbatch(e,0);
   e = setname(e,'DD_error');
	return

elseif nargin == 1
	% Now we are doing the actual work:
   if size(x,2)==1
      % DXD: what about a single output: is it smart to define this
      % threshold??
      warning('Dataset has just one feature, now using threshold 0.5.');
      x = [x 0.5*ones(size(x,1),1)];
      x = setfeatlab(x,['target ';'outlier']);
   end

	% true target labels
	[nin,llin] = getnlab(x);
	Ittrue = strmatch('target',llin);
	if isempty(Ittrue), Ittrue = -1; end
	Ittrue = find(nin==Ittrue);
	% true outlier labels
	Iotrue = strmatch('outlier',llin);
	if isempty(Iotrue), Iotrue = -1; end
	Iotrue = find(nin==Iotrue);

	% classification labels:
	% (this is too slow:)
	%lout = labeld(x);
	%[nout,llout] = renumlab(lout);
	llout = getfeatlab(x);
	[mx,nout] = max(+x,[],2);
	% objects labeled target:
	It = strmatch('target',llout);
	if isempty(It), It = -1; end
	It = (nout==It);
	% objects labeled outlier:
	Io = strmatch('outlier',llout);
	if isempty(Io), Io = -1; end
	Io = (nout==Io);

	% Finally the error:
	% Warning can be off, because we like to have NaN's when one of the
	% classes is empty:
    warning off MATLAB:divideByZero;
	e(1) = sum(It(Ittrue)==0)/length(Ittrue);
	e(2) = sum(Io(Iotrue)==0)/length(Iotrue);
    warning on MATLAB:divideByZero;
	
	% compute the precision and recall when it is requested:
	if (nargout>1)
		warning off MATLAB:divideByZero;
      f(1) = sum(It(Ittrue)==1)/sum(It);
		f(2) = sum(It(Ittrue)==1)/length(Ittrue);
		warning on MATLAB:divideByZero;
	end

   % compute the hit rate and false alarm rate when it is requested
   if (nargout>2)
		warning off MATLAB:divideByZero;
      g(1) = sum(It(Ittrue)==1)/length(Ittrue);
      g(2) = sum(It(Iotrue)==1)/sum(It);
		warning on MATLAB:divideByZero;
   end

else

	ismapping(w);
	istrained(w);

	if (nargout>2)
		[e,f,g] = feval(mfilename,x*w);
   elseif (nargout>1)
		[e,f] = feval(mfilename,x*w);
	else
		e = feval(mfilename,x*w);
	end

end

return
