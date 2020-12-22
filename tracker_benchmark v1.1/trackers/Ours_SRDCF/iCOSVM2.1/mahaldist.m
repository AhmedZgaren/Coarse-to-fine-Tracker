%MAHALDIST Mahalanobis distance
%
%    Y = MAHALDIST(X,MU,SIGMA,LAMBDA)
%
% INPUT
%   X        Data matrix
%   MU       Mean vector (default = 0)
%   SIGMA    Covariance matrix (default = 1)
%   LAMBDA   Regularization (default = [])
%
% OUTPUT
%   Y        Mahalanobis distance
%
% DESCRIPTION
% For dataset X, the Mahalanobis distance of these objects to the
% normal density, given by the MU and SIGMA.
%
% When LAMBDA>0, the covariance matrix is regularized by:
%  SIGMA' = SIGMA + LAMBDA*eye(dim)
%
% For LAMBDA<0 the pseudo-inverse is used.
%
% SEE ALSO
% sqeucldistm, gauss_dd, dd_proxm

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function y = mahaldist(x,mu,sigma,lambda)
if nargin<4
	lambda = [];
end
if nargin<3
	sigma = 1;
end
if nargin<2
	mu = 0;
end
if nargin<1
	error('Requires at least on input argument.');
end

% check sizes:
[rx,cx] = size(x);
[rm,cm] = size(mu);
[rs,cs] = size(sigma);
if (cx ~= cm) || (cx ~= cs)
	error('Number of columns in X, MU and SIGMA should be equal');
end

% mean, inv-covariance and mahanalobis distance:
X = x - ones(rx,1)*mu;
if isempty(lambda)
	Sinv = inv(sigma);
else
	if (lambda<0)
		Sinv = pinv(sigma);
  else
	  Sinv = inv(sigma + lambda*eye(cs));
  end
end
% and finally the distance becomes:
y = sum((X*Sinv).*X,2);

return

