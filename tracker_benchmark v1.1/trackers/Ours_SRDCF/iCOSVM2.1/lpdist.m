%LPDIST Fast L_p distance 
%
%     D = LPDIST(A,B,P,W)
%
% INPUT
%   A,B   Dataset
%   P     Degree P (default = 2)
%   W     Feature weights (default = [])
%
% OUTPUT
%   D     Distance matrix
%
% DESCRIPTION
% Compute the L_p^p distance between data A and B in a fast(er) way than
% using dd_proxm.m using p=P. The features can also be weighted by
% weights W.
%
%    d(a,b) =  [sum_i abs(a_i-b_i)^p ]
%
% SEE ALSO
% lpball_dd

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function D = lpdist(a,b,p,w)
if nargin<4
	w = [];
end
if nargin<3
	p = 2;
end

% size of the data:
m = size(a,1);
% size of the means:
n = size(b,1);
D = zeros(m,n);

if isempty(w)
	for i=1:n
		D(:,i) = sum( abs(a-repmat(b(i,:),m,1)).^p ,2);
	end
else
	for i=1:n
		D(:,i) = sum( repmat(w(i,:),m,1).*abs(a-repmat(b(i,:),m,1)).^p ,2);
	end
end

return

