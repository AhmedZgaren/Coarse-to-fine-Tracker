%KMEANS_DD k-means data description.
% 
%       W = KMEANS_DD(A,FRACREJ,K,TOL)
%       W = A*KMEANS_DD([],FRACREJ,K,TOL)
%       W = A*KMEANS_DD(FRACREJ,K,TOL)
%
% INPUT
%   A        Dataset
%   FRACREJ  Error on the target class (default = 0.1)
%   K        Number of clusters (default = 5)
%   TOL      Error tolerance (for convergence) (default = 1e-5)
%
% OUTPUT
%   W        k-means data description
%
% DESCRIPTION 
% Train a k-means method with K prototypes on dataset A. Parameter
% FRACREJ gives the fraction of the target set which will be rejected.
% 
% Optionally, one may give the error tolerance TOL as last argument as
% stopping criterion.
% 
% SEE ALSO
% knndd, kcenter_dd, som_dd

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
  
%function [W,out] = kmeans_dd(a,fracrej,K,errtol)
function [W,out] = kmeans_dd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,5,1e-5);
  
if mapping_task(argin,'definition')       % Define mapping
   [a,fracrej,K] = deal(argin{1:3});
   W = define_mapping(argin,'untrained','%d-means DD',K);

elseif mapping_task(argin,'training')			% Train a mapping.

   [a,fracrej,K,errtol] = deal(argin{:});
	a = +target_class(a);     % make sure a is an OC dataset
	k = size(a,2);

	% train it:
	[labs,w] = mykmeans(a,K,errtol);

	% obtain the threshold:
	d = sqrt(min(sqeucldistm(a,w),[],2));
	if (size(d,2)~=1)
		d = d';
	end
	thr = dd_threshold(d,1-fracrej);

	%and save all useful data:
	W.w = w;
	W.threshold = thr;
	W.scale = mean(d);
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	W = setname(W,'K-Means dd (k=%d)',K);

elseif mapping_task(argin,'trained execution') %testing

   [a,fracrej] = deal(argin{1:2});
	W = getdata(fracrej);  % unpack
	m = size(a,1);

	%compute:
	out = [sqrt(min(sqeucldistm(+a,W.w),[],2)) repmat(W.threshold,m,1)];

	% Store the distance as output:
	W = setdat(a,-out,fracrej);
	W = setfeatdom(W,{[-inf 0;-inf 0] [-inf 0;-inf 0]});
else
   error('Illegal call to kmeans_dd');
end

return

