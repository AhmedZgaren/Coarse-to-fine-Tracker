%DENS_EST map a distance to a posterior probability
%
%     OUT = DIST2DENS(IN,SIGM)
%
% INPUT
%   IN    Matrix or dataset
%   SIGM  Scaling factor (default = mean(IN))
%
% OUTPUT
%   OUT   Matrix or dataset
%
% DESCRIPTION
% Map the output of a reconstruction method to a posterior
% probability:
%     out=exp(-in/sigm)
%
% SEE ALSO
% dissim, dd_proxm

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function out = dist2dens(in,sigm)
if nargin<2
	sigm = mean(in);
end

out = exp(-in/sigm);

return
