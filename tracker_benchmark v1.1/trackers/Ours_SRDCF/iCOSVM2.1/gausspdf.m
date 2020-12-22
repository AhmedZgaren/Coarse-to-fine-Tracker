%GAUSSPDF Multivariate Gaussian probability density function
%
%    Y = GAUSSPDF(X,MU,SIGMA)
%    Y = GAUSSPDF(X,MU,SIGMA,LAMBDA)
%
% INPUT
%   X       Data matrix
%   MU      Mean vector (default = 0)
%   SIGMA   Covariance matrix (default = 1)
%   LAMBDA  Regularization parameter (default = [])
%
% OUTPUT
%   Y       Estimated density
%
% DESCRIPTION
% This function defines the high dimensional version of normpdf. Given
% the mean MU and covariance matrix SIGMA, the density at points X is
% computed. It is assumed that all objects are row objects.
% Per default, just the inverse of the covariance matrix is computed.
%
% When LAMBDA>0, the covariance matrix is regularized by:
%
%      SIGMA' = SIGMA + LAMBDA*eye(dim)
%
% For LAMBDA<0 the pseudo-inverse is used.

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function [y,d2] = gausspdf(x,mu,sigma,lambda)

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
	error('Gausspdf requires at least one input argument.');
end

% First the Mahanalobis distance:
d2 = mahaldist(x,mu,sigma,lambda);

% When lambda>0 is supplied, the regularized sigma should also be
% used in the computation of the detS:
dim = size(x,2);
if ~isempty(lambda) && (lambda>0)
	sigma = sigma + lambda*eye(dim);
end

% Normalize to pdf:
detS = det(sigma);
if (detS<0)  % annoying when near-singular cov.matrix
  detS = -detS;  %DXD: hack hack hack
end

% and finally the density computation:
y = exp(-d2/2)/sqrt(detS*(2*pi)^dim);

return

