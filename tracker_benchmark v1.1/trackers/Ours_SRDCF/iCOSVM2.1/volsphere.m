%VOLSPHERE Compute the volume of a hypersphere
%
%      V = VOLSPHERE(D,R,TAKELOG)
%
% INPUT
%   D        Dimensionality
%   R        Radius (default = 1)
%   TAKELOG  Flag indicating the use of log(volume) (default = 0)
%
% OUTPUT
%   V        Volume of the hypersphere
%
% DESCRIPTION
% Compute the volume of a hypersphere in D dimensions, with radius R.
%
% If TAKELOG>0 than the log(V) is computed (more useful for computations
% in high dimensional feature spaces)
%
% SEE ALSO
% knn_optk

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function V = volsphere(d,R,takelog)
if nargin<3
	takelog=0;
end
if nargin<2
	R = 1;
end

if takelog
	V = log(2) + d*log(R*sqrt(pi)) - log(d) - gammaln(d/2);
else
	V = 2*(R*sqrt(pi))^d/(d*gamma(d/2));
end

return
