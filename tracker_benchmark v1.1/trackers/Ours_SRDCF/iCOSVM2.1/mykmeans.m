%MYKMEANS K-means clustering
%
%      [LABS,MEANS] = MYKMEANS(X,K)
%
% INPUT
%   X       Data matrix
%   K       Number of clusters
%   TOL     Error tolerance (default = 1e-5)
%
% OUTPUT
%   LABS    Cluster label for each object in X
%   MEANS   Cluster means
%
% DESCRIPTION
% Very light-weight implementation of the K-means procedure;
% Place K centers in the data X. Update the location of the means until
% the relative error improvement is smaller than TOL. The error is in
% terms of the reconstruction error.

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function [labs,means,err] = mykmeans(x,k,errtol)

if nargin<3
  errtol = 1e-5;
end

% init:
n = size(x,1);

% use k random objects as initialization
I = randperm(n);
means = x(I(1:k),:);

% label all objects:
D = distm(x,means);
[dx, labs] = min(D,[],2);

% the reconstruction error:
err = sum(dx);
olderr = 10*err;

% update the means until the error does not change
while ((olderr-err)>errtol*err)

	% update the means:
	for i=1:k
		I = find(labs==i);
		if ~isempty(I)
			means(i,:) = mean(x(I,:),1);
		end
	end
	% relabel all objects:
	D = sqeucldistm(x,means);
	[dx, labs] = min(D,[],2);
	% the error:
	olderr = err;
	err = sum(dx);
end

return
