%NNDIST (Average) nearest neighbor distance
%
%      D = NNDIST(A,K)
%      D = NNDIST(A,K,N)
%
% INPUT
%   A     Dataset
%   K     Number of neighbors (default = 5)
%   N     Number of subsampled objects (default = 500)
%
% OUTPUT
%   D     Averaged k-nearest neighbor distance
%
% DESCRIPTION
% Compute the averaged K-nearest neighbor distance of dataset (or data
% matrix) A. 
% To reduce the computational load, subsample only N objects from A.
%
% SEE ALSO
% sqeucldistm, dd_proxm, knndd, scale_range

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function d = nndist(a,k,n)

if nargin<3
	n = 500;
end
if nargin<2 | isempty(k)
	k = 5;
end

% check k:
if k>n
	error('Please make k<(n=%d).',n);
end

if size(a,1)>n % we have a lot of data: subsample
	I = randperm(size(a,1));
	as = +a(I(1:n),:);
   % compute squared distance
   D = sqeucldistm(as,+a);
else
   % compute squared distance
   D = sqeucldistm(+a,+a);
end
% and the average k-NN distance:
sD = sort(D);
d = mean(sqrt(sD(k+1,:))); % use k+1, because first element is always 0

