%MCD_GAUSS_DD Minimum Covariance Determinant Robust Gaussian data description.
% 
%       W = MCD_GAUSS_DD(A,FRACREJ)
%       W = A*MCD_GAUSS_DD([],FRACREJ)
%       W = A*MCD_GAUSS_DD(FRACREJ)
%
% INPUT
%   A        Dataset
%   FRACREJ  Error on target class (default = 0.1)
%
% OUTPUT
%   W        Minimum covariance determinant model
% 
% DESCRIPTION
% Fit a Minimum-Covariance-Determinant Gaussian density on dataset A. The
% minimum covariance determinant is found by rejection of FRACREJ of the
% data A, such that the determinant becomes minimum.
%
% REFERENCE:
%  Rousseeuw, P.J. and Van Driessen, Katrien, "A fast algorithm for
%  the minimum covariance determinant estimator", 15 Dec. 1998
% 
% SEE ALSO
% dd_roc, fastmcd, gauss_dd, rob_gauss_dd

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
  
%function W = mcd_gauss_dd(x,fracrej)
function W = mcd_gauss_dd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1);

if mapping_task(argin,'definition')       % Define mapping
   W = define_mapping(argin,'untrained','MCD Gaussian');

elseif mapping_task(argin,'training')			% Train a mapping.

   [x,fracrej] = deal(argin{:});
	x = +target_class(x);     % only use the target class
	[n,dim] = size(x);

	% call the function:
	options.alpha = 1-fracrej;
	options.cor = 1; % a robust corr. matrix will be returned...
	options.lts = []; % display nothing!
   warning off MATLAB:eigs:NoEigsConverged;
      res = fastmcd(x,options);
   warning on MATLAB:eigs:NoEigsConverged;

	% invert the covariance matrix:
	sinv = inv(res.cov);

	% get the distances on the training set:
	X = +x - repmat(res.center,n,1);
	d = sum((X*sinv).*X,2);
	
	% Obtain the threshold:
	thr = dd_threshold(d,1-fracrej);

	%and save all useful data:
	W.m = res.center;
	W.sinv = sinv;
	W.threshold = thr;
	%W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),dim,2);

	% actually, we can just call 'gauss_dd' now!
	W = prmapping('gauss_dd','trained',W,str2mat('target','outlier'),dim,2);
	W = setname(W,'MCD Gaussian');

else
	error('Evaluation of mcd_gauss_dd is treated by gauss_dd!');
end
return


