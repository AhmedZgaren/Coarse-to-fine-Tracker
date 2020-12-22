%DLPSDD  Bennett's linear programming data description on similarities
%
%     W = DLPSDD(K,NU)
%     W = K*DLPSDD([],NU)
%     W = K*DLPSDD(NU)
%
% INPUT
%   K        Similarity dataset
%   NU       Fraction error on target data (default = 0.1)
%
% OUTPUT
%   W        Similarity Linear programming model
%
% DESCRIPTION
% This linear one-class classifier works directly on similarities K.
% Fraction NU (0<NU<1) indicates the fraction of training objects that
% is outside the description.
% In the original paper of Bennet & Campbell the similarities K
% are computed using the Gaussian kernel. It gives a sparse solution.
% 
% Typical usage:
% >> u = dd_proxm([],'r',5)*dlpsdd([],0.05);
% >> w = a*u;
%
% REFERENCE
% C.Campbell, K.P.Bennett, A Linear Programming Approach to Novelty
% Detection, NIPS, 2001.
%
% SEE ALSO
% dlpdd, lpdd, dd_proxm

% Copyright: E.Pekalska, D. Tax, R.P.W. Duin, D.M.J.Tax@gmail.com
% Faculty of Applied Sciences, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

%function W = dlpsdd(x,nu,usematlab)
function W = dlpsdd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,0);

if mapping_task(argin,'definition')
   W = define_mapping(argin,'untrained','LP similarity descr.');

elseif mapping_task(argin,'training')

   [x,nu,usematlab] = deal(argin{:});
	% work directly on the distance matrix
	[n,d] = size(x);

	% maybe we have example outliers...
	if isocset(x)
		labx = getoclab(x);
	else
		labx = ones(n,1);
	end
	x = +x; % no dataset please.

	% set up the LP problem:
  if nu > 0 && nu <= 1,
		C = d./(n*nu);
		f = [sum(+x,1)'; d; repmat(C,n,1)];
		A = [+x ones(n,1) eye(n)].*repmat(labx,1,d+n+1);
		b = zeros(n,1);
		Aeq = [ones(1,d), zeros(1,n+1)];
		beq = 1;
		lb = [zeros(d,1); -inf; zeros(n,1)];
		ub = repmat(+inf,d+n+1,1);
  elseif nu == 0,
		f = [sum(+x,1)'; d];
		A = [+x ones(n,1)].*repmat(labx,1,n+1);
		b = zeros(n,1);
		Aeq = [ones(1,d), zeros(1,1)];
		beq = 1;
		lb = [zeros(d,1); -inf];
		ub = repmat(+inf,d+1,1);
  else
		error ('Wrong nu.');
  end

	% optimize::
	if (exist('glpk')>0) && (usematlab==0)
		ctype = [repmat('L',n,1); 'S'];
		vartype = repmat('C',length(f),1);
		alf = glpk(f,[A;Aeq],[b;beq],lb,ub,ctype,vartype,1);
	else
		% or the good old Matlab optimizer:
      opts = optimset('linprog');
      opts.display = 'off';
		alf = linprog(f,-A,-b,Aeq,beq,lb,ub,[],opts);
	end

	% store the results
	paramalf = alf(1:d);
	W.I = find(paramalf>1e-8);
	if isempty(W.I)
		warning(dd_tools:allWeightsZero, ...
            'All weights are zero: is this correct?');
	end
	W.w = paramalf(W.I);
	W.threshold = -alf(d+1);

	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),d,2);
	W = setname(W,'LP Similarity-data descr.');

elseif mapping_task(argin,'trained execution') %testing

   [x,nu] = deal(argin{1:2});
	% get the data:
	W = getdata(nu);
	m = size(x,1);

	% and here we go:
	K = +x(:,W.I);
	% annoying prtools:
	newout = [K*W.w repmat(W.threshold,m,1)];

	W = setdat(x,newout,nu);
else
   error('Illegal call to DLPSDD');
end
return


