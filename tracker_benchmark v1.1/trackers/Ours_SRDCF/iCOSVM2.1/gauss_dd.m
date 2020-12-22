%GAUSS_DD Gaussian data description.
% 
%       W = GAUSS_DD(A,FRACREJ,R)
%
% INPUT
%   A         One-class dataset
%   FRACREJ   Error on the target class (default = 0.1)
%   R         Regularization parameter (default = 0.001)
% 
% OUTPUT
%   W         Gaussian data description
%
% DESCRIPTION
% Fit a Gaussian density on dataset A. If requested, the r can be
% given to add some regularization to the estimated covariance matrix:
% sig_new = (1-r)*sig + r*eye(dim).
%
% This version actually computes just the Mahalanobis distance to the
% mean. This should avoid underflows at the computation of a real
% Gaussian density (especially problematic in high dimensional spaces).
%
% SEE ALSO
% mcd_gauss_dd, rob_gauss_dd, mappings, dd_roc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
  
function W = gauss_dd(varargin)

% allow for skipping of the dataset:
argin = shiftargin(varargin,'scalar');
% define the default values:
argin = setdefaults(argin,[],0.1,0.001);

% Define the empty mapping, define the training and evaluation: 
if mapping_task(argin,'definition')

   W = define_mapping(argin,'untrained','Gaussian OC');

elseif mapping_task(argin,'training')

   [a,fracrej,r] = deal(argin{:});
	a = target_class(a);     % only use the target class
	[n,k] = size(a);

	% Train it:
	[mu,sig] = meancov(+a);
	sig = (1-r)*sig + r*mean(diag(sig))*eye(k);
	% invert the covariance matrix:
	sinv = inv(sig);

	% get the distances on the training set:
	X = a - repmat(mu,n,1);
	d = sum((X*sinv).*X,2);

	% Obtain the threshold:
	thr = dd_threshold(d,1-fracrej);

	%and save all useful data:
	W.m = +mu;
	W.sinv = sinv;
	W.threshold = thr;
	W.scale = mean(d);
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	W = setname(W,'Gaussian OC');

elseif mapping_task(argin,'trained execution')

   [a,fracrej] = deal(argin{1:2});
	% Extract the data:
	W = getdata(fracrej);
	m = size(a,1);

	% Compute the Mahalanobis distance (to avoid problems in the non-essential
	% normalization factor):
	%X = +a - repmat(W.m,m,1);
    X = bsxfun(@minus,+a,W.m); %DXD: faster... somewhat...
	out = sum((X*W.sinv).*X,2);
	newout = [out repmat(W.threshold,m,1)];

	% Store the distance as output:
	W = setdat(a,-newout,fracrej);
	W = setfeatdom(W,{[-inf 0; -inf 0] [-inf 0;-inf 0]});
else
   error('Illegal call to gauss_dd.');
end
return


