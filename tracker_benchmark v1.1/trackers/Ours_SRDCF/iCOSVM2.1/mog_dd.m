%MOG_DD Mixture of Gaussians data description
%
%   W = MOG_DD(A,FRACREJ,N,CTYPE,REG,NRITERS)
%   W = A*MOG_DD([],FRACREJ,N,CTYPE,REG,NRITERS)
%   W = A*MOG_DD(FRACREJ,N,CTYPE,REG,NRITERS)
%
% INPUT
%   A          One-class dataset
%   FRACREJ    Error on the target class
%   N          Number of clusters for target and outlier data
%              (default = [5 0])
%   CTYPE      Covariance type (default = 'full')
%   REG        Regularization (default = 0.01)
%   NRITERS    Number of iterations (default = 100)
%
% OUTPUT
%   W          Mixture of Gaussians
%
% DESCRIPTION
% Train a Mixture of Gaussians model on data A, using N1 clusters to
% model the target class, and N2 clusters for the outlier data, where
% N=[N1 N2]. The location, size and priors of each of the clusters is
% optimized using the EM algorithm. The shape of the clusters can be
% chosen by setting CTYPE:
% CTYPE = 'sphr':  spherical clusters (only diagonal elements with
%                  equal values in the cov. matrices)
%         'diag':  elliptical and aligned clusters (only diagonal
%                  elements)
%         'full':  arbitrary shaped clusters (full covariance matrices)
%
% When no outlier data is available, you can choose to use
% N2=[], or N2=0. To ensure that the classifiers obtains a closed
% boundary around the target class, one extra cluster is added to the
% outlier clusters, that will model the uniform outlier distribution.
% When you only supply N1, a fixed threshold will be used and no extra
% outlier cluster is added.
%
% The EM algorithm was inspired by NetLab (by Bishop), but it has been
% changed significantly after that.
% Optionally, you can set a regularization for the covariance matrices,
% by giving REG, or the maximum number of iterations by NRITERS.
%
% SEE ALSO
% mog_init, mog_update, mog_P, mogEMupdate, mogEMextend

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function w = mog_dd(a,fracrej,n,ctype,reg,numiters)
function w = mog_dd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,[5 0],'full',0.01,100);
  
if mapping_task(argin,'definition')       % Define mapping
   mapname = sprintf('MoG (%d)',argin{3}(1));
   w = define_mapping(argin,'untrained',mapname);
    
elseif mapping_task(argin,'training')			% Train a mapping.
  
   [a,fracrej,n,ctype,reg,numiters] = deal(argin{:});
	% Setup some variables:
	W = [];
	[m,k] = size(a);
	[at,ao] = target_class(a);

	% Detect which type of covariance matrix we have:
	switch ctype
	case {'sphr' 'diag' 'full'}
		W.covtype = ctype;
	otherwise
		error('The covariance structure %s is not known',ctype);
	end

	% First do the target class
	[W.mt, W.ict, W.pt] = mog_init(at, n(1), W.covtype);
	% then do the outlier class
	if (length(n)>1)
		if isempty(ao)
			% When no outlier data is avaiable, all clusters will have
			% centers on the mean of the data
			[W.mo, W.ico, W.po] = mog_init(mean(at),n(2),W.covtype,cov(+at));
		else
			% When some outlier data is available, only the first cluster
			% will be fixed to the mean of the data, the rest will be
			% fitted
			[W.mo, W.ico, W.po] = mog_init(ao,n(2),W.covtype,cov(+a));
		end
	end
	
	% and not to forget to store:
	W.threshold = 0;
	W.reg = reg;
	W.fracrej = fracrej;

	% and store it in the mapping:
	w = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	% also give it a suitable name
	if (length(n)>1) && (n(2)>0)  % we model also the outliers
		w = setname(w,sprintf('MoG (%d+%d)',n(1),n(2)));
	else
		% we only describe the target class
		w = setname(w,sprintf('MoG (%d)',n(1)));
	end
	
	% Now start training this mapping:
	w = mog_update(w,a,numiters);
	w = mog_threshold(w,at,fracrej);

elseif mapping_task(argin,'trained execution') %testing

   [a,fracrej] = deal(argin{1:2});
	w = getdata(fracrej);  % unpack
	m = size(a,1);

	%compute the output, depending if the outlier class is also modelled:
	out = sum(mog_P(+a,w.covtype,w.mt,w.ict,w.pt),2);
	% when we have the outlier class modelled:
	if isfield(w,'mo')
		% Do it nicely using Bayes rule:
		Po = sum(mog_P(+a,w.covtype,w.mo,w.ico,w.po),2) + 10*eps;
        warning off MATLAB:divideByZero;
			out = out./Po;
		warning on MATLAB:divideByZero;
	end
	newout = [out repmat(w.threshold,m,1)];

	% Store the density:
	w = setdat(a,newout,fracrej);
	w = setfeatdom(w,{[0 inf;0 inf] [0 inf;0 inf]});
else
   error('Illegal call to mog_dd.');
end

return
