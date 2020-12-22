%PCA_DD Principal Component data description
%
%       W = PCA_DD(A,FRACREJ,N)
%       W = A*PCA_DD([],FRACREJ,N)
%       W = A*PCA_DD(FRACREJ,N)
%       W = PCA_DD(A,FRACREJ,VAR)
%       W = A*PCA_DD([],FRACREJ,VAR)
%       W = A*PCA_DD(FRACREJ,VAR)
%
% INPUT
%   A         One-class dataset
%   FRACREJ   Error on the target class (default = 0.1)
%   N         Number of PCA components
%   VAR       Fraction of explained variance (default = 0.9)
%
% OUTPUT
%   W         PCA model
%
% DESCRIPTION
% Fit a Principal Component Analysis data description by estimating
% first a PCA on the target class of A, and mapping the training data
% onto the PCA subspace. The distance between the original objects and
% the mapped objects is used to detect outliers. 
% The number of dimensions of the PCA can be supplied by N.
% Alternatively the fraction of explained variance can be given (in
% VAR).
%
% SEE ALSO
% pcam, gauss_dd

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function W = pca_dd(a,fracrej,n)
function W = pca_dd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,0.9);

if mapping_task(argin,'definition')
   [a,fracrej,n] = deal(argin{:});
   if (n<1)
      W = define_mapping(argin,'untrained',...
      'PCAdd (%4.2f)',n)
   else
      W = define_mapping(argin,'untrained',...
      'PCAdd (%dD)',n)
   end

elseif mapping_task(argin,'training')
   [a,fracrej,n] = deal(argin{:});
	a = target_class(a);     % only use the target class
	[m,k] = size(a);
	% Be careful with the mean:
	meana = repmat(mean(a),m,1);
	a = (a - meana);

	% Train it and compute the reconstruction error:
	w = pcam(a,n);
	W = w.data.rot;
	dim = size(W,2);
	if dim==k
		warning('dd_tools:NoFeatureReduction',...
			'Output dimensionality is equal to input dimensionality!');
	end
	Proj = W*inv(W'*W)*W';
	% project and find the distribution of the distance:
	dif = a - a*Proj;
	d = sum(dif.*dif,2);

	% obtain the threshold:
	thr = dd_threshold(d,1-fracrej);

	%and save all useful data:
	% (I know I just have to store W instead of Proj, but I do not like
	% to compute the inverse of W'*W over and over again, this uses just
	% some disk/memory space):
	W = [];  % W was already used, forget that one...
	W.P = Proj;
	W.mean = meana(1,:);
	W.dim = dim;  %just for inspection...
	W.threshold = thr;
	W.scale = mean(d);
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	if (n<1)
		W = setname(W,'PCA dd (%4.2f)',n);
	else
		W = setname(W,'PCA dd (%dD)',n);
	end

elseif mapping_task(argin,'trained execution') %testing

   [a,fracrej,n] = deal(argin{:});
	W = getdata(fracrej);  % unpack
	m = size(a,1);

	%compute reconstruction error:
	dif = +a - repmat(W.mean,m,1);
	dif = dif - dif*W.P;
	out = sum(dif.*dif,2);
	newout = [out, repmat(W.threshold,m,1)];

	% Store the distance as output:
	W = setdat(a,-newout,fracrej);
	W = setfeatdom(W,{[-inf 0;-inf 0] [-inf 0;-inf 0]});
else
   error('Illegal call to pca_dd');
end

return
