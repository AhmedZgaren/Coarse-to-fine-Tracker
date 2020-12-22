%NNDD Nearest neighbour data description
% 
%       W = NNDD(A,FRACREJ)
%       W = A*NNDD([],FRACREJ)
%       W = A*NNDD(FRACREJ)
% 
% INPUT
%   A         One-class dataset
%   FRACREJ   Error on the target class (default = 0.1)
%
% OUTPUT
%   W         Nearest neighbor description
%
% DESCRIPTION
% Calculates the Nearest neighbour data description. Training only
% consists of the computation of the resemblance of all training
% objects to the training data using Leave-one-out.
%
% WARNING: this method is basically a wrapper around dnndd, which is the
% nearest neighbor directly on distance data. In NNDD the squared
% Euclidean distance is used.
% 
% SEE ALSO
% knndd, datasets, mappings, dd_roc, dnndd

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
  
% W = nndd(a,fracrej)
function W = nndd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1);
  
if mapping_task(argin,'definition')       % Define mapping
   W = define_mapping(argin,'untrained','Nearest Neighbor DD');
    
elseif mapping_task(argin,'training')			% Train a mapping.
  
   [a,fracrej] = deal(argin{:});
	a = +target_class(a);      % make sure we have a OneClass dataset
	[m,k] = size(a);

	% Compute distance matrix and remove zero distances:
	distmat = sqeucldistm(a,a);
	large_D = max(distmat(:));
	small_D = 1.0e-10;           % almost zero distance
	distmat = distmat + large_D*(distmat<small_D); %surpress 0 dist.

	% Now go to the dnndd:
	w = dnndd(distmat,fracrej);

	% and save all useful data:
	W.w = w;
	W.x = +a;
	W.threshold = w.data.threshold;
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	W = setname(W,'Nearest neighb. dd');

elseif mapping_task(argin,'trained execution') %testing

   [a,fracrej] = deal(argin{:});
	W = getdata(fracrej);  % unpack
	m = size(a,1);

	%compute:
	distmat = +sqeucldistm(+a,W.x);
	out = +(distmat*W.w);

   % and return it nicely
	W = setdat(a,out,fracrej);
	W = setfeatdom(W,{[-inf 0;-inf 0] [-inf 0; -inf 0]});
else
   error('Illegal call to nndd.');
end
return
