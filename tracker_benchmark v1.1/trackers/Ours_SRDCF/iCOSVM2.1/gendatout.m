%GENDATOUT Generate outlier objects
%
%       [Z,R] = GENDATOUT(A,N,DR,KEEPDATA)
%       [Z,R] = A*GENDATOUT([],N,DR,KEEPDATA)
%       [Z,R] = A*GENDATOUT(N,DR,KEEPDATA)
%
% INPUT
%   A         One-class dataset
%   N         Number of objects (default = 100)
%   DR        Factor rescaling of sphere radius (default = 1.1)
%   KEEPDATA  Keep the target data from A in the dataset (default = 0)
%
% OUTPUT
%   Z     Dataset
%   R     Radius of the sphere
%
% DESCRIPTION
% Generate N outlier objects in a hypersphere round dataset A. This
% dataset should be a one-class dataset. The hypersphere is calculated
% from SVDD.  The radius can be enlarge by a certain fraction:  r' =
% dR*r_org.
% If requested, KEEPDATA=1, the original target data from dataset A can
% still be retained in dataset Z.
%
% REFERENCE
%@article{Tax2001,
%	author = {Tax, D.M.J. and Duin, R.P.W.},
%	title = {Uniform object generation for optimizing one-class classifiers},
%	journal = {Journal for Machine Learning Research},
%	year = {2001},
%	pages = {155-173}
%}
% SEE ALSO
% randsph, gendatblockout, gendatoc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function [z,R,meana] = gendatout(a,n,dR,keepdata)
function [z,R,meana] = gendatout(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],100,1.1,0);

if mapping_task(argin,'definition')
   z = define_mapping(argin,'generator','Uniform Sphr.');
   return
end

[a,n,dR,keepdata] = deal(argin{:});
% what is our target data?
if isocset(a)
	featlab = getfeatlab(a);
	a = +target_class(a);
else
	featlab = [];
	a = +a;
end

[nra,dim] = size(a);

% Compute SVDD with linear kernel:
w = incsvdd(oc_set(a),1/nra,'p',1);
% Get the support vectors and their weights:`
svx = w.data.sv;
alf = w.data.alf;
nrsv = size(svx,1);

% Compute from SVDD the mean and radius
if (nrsv<=1) % no support vectors found...
	%warning('dd_tools:NoSVs','Something wrong with calculating the center in gendatout');
	meana = mean(a);
	D = sqeucldistm(a,meana);
	R = sqrt(max(D));
else % do it as it is supposed to work:
	% note that the sum_i alf_i is not always normalized:
	meana = sum(svx.*repmat(alf,1,dim))/sum(alf);
	R = sqrt(mean(sum((svx-repmat(meana,nrsv,1)).^2,2)));
end
% extend the radius if requested:
R = dR*R;
% generate new data
zdat = repmat(meana,n,1) + randsph(n,dim)*R;
%label it as outliers
z = prdataset(zdat,repmat('outlier',n,1), 'featlab',featlab);
% include the original target data??
if keepdata
   z = gendatoc(a,z);
end
z = setname(z,'Artif. spherical-distr''d outliers');


return
