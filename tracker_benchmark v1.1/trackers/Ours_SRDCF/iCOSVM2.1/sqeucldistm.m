%SQEUCLDISTM Square Euclidean distance matrix
%
%        D = SQEUCLDISTM(A,B)
%
% INPUT
%   A,B   Data matrices
%
% OUTPUT
%   D     Distance matrix
%
% DESCRIPTION
% A specialized function for computing the squared Euclidean distance D
% between datasets A and B. This is mainly for computational speed, so
% it is light-weight, without any checking.  Normal users will probably
% use dd_proxm.
%
% Some speedups and improvements by G. Bombara <g.bombara@gmail.com>
% Mainly for internal use.
%
% SEE ALSO
% dd_proxm

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function D = sqeucldistm(A,B)

dA = sum(A.*A,2);
dB = sum(B.*B,2);

D = bsxfun(@plus,dA,dB') - 2*A*B';

% no negative distances:
D(find(D<0)) = 0;

return

