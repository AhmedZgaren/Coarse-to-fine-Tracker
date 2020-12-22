%GOWER Gower dissimilarity
%
%    S = GOWER(X,Y,FEATTYPE,FEATRANGE)
%
% INPUT
%   X          D-dimensional feature vector
%   Y          D-dimensional feature vector
%   FEATTYPE   Indicator for nominal feature
%   FEATRANGE  Min and max value per feature
%
% OUTPUT
%   S          Gower similarity
%
% DESCRIPTION
% Compute the Gower general similarity S between two objects X and Y.
% It should work for continuous and nominal features. For easy
% application, please use the function dd_proxm.m.
%
% The vector FEATTYPE should indicate if the corresponding feature
% is:
%   0 : continuous
%   1 : nominal values.
% Obviously, the FEATTYPE index vector should have length d (the
% dimensionality of the feature space). To find out which features
% are continuous or nominal, use the function getfeattype.m
%
% For the continuous features, the FEATRANGE of these features should be
% specified. This can be a problem, when we have just a very few
% objects...
%
% REFERENCE
%@article{Gower1971,
%	author = {Gower, J.C.},
%	title = {A general coefficient of similarity and some of its properties},
%	journal = {Biometrics},
%	year = {1971},
%	volume = {27},
%	pages = {857-872}
%}
% SEE ALSO
% dd_proxm, getfeattype, dissim

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function s = gower(x,y,feattype,featrange)

% First the checks:
[m,dim] = size(x);
[n,dim2] = size(y);
if m>1
	error('I only can handle vector x');
end
if dim~=dim2
	error('Vectors in x and y should have equal length');
end

% So now we can go:
s = zeros(n,1);
lens = zeros(n,1);
% The continuous features:
Ic = find(feattype==0);
if ~isempty(Ic)
	d = 1 - abs( repmat(x(1,Ic),n,1)-y(:,Ic) )./repmat(featrange(Ic),n,1);
	s = s + sum(d,2);
	lens = length(Ic);
end

% The nominal features:
In = find(feattype==1);
if ~isempty(In)
	z = (repmat(x(1,In),n,1)==y(:,In));
	% Kick out elements for which both x and y have 0 value.
	Iz = (repmat(x(1,In),n,1)==0)&(y(:,In)==0);
	z(Iz) = 0;
	w = dim - sum(Iz,2);
	s = s + sum(z,2);
	lens = lens + w;
end

% Finally, normalize the similarity:
s = s./lens;

return
