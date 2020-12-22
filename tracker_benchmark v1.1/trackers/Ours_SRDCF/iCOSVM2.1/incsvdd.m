%INCSVDD Incremental Support Vector Data Description
%
%    W = INCSVDD(A,FRACREJ,KTPYE,KPAR)
%    W = A*INCSVDD([],FRACREJ,KTPYE,KPAR)
%    W = A*INCSVDD(FRACREJ,KTPYE,KPAR)
%
% INPUT
%   A         One-class dataset
%   FRACREJ   Error on target class (default = 0.1)
%   KTYPE     Kernel type (default = 'p')
%   KPAR      Kernel parameter (default = 1)
%
% OUTPUT
%   W         Incremental SVDD
%
% DESCRIPTION
% Train an incremental support vector data description on dataset A.
% The C-parameter is set such that FRACREJ of the target points is
% rejected, using the formula:
%     C = 1/(N*FRACREJ)
% The kernel (and its parameters) are defined by kernel type KTYPE and
% parameter(s) KPAR. For possible definitions of the kernel, see DD_KERNEL.
%
% REFERENCE
%@article{Tax1999c,
%	author = {Tax, D.M.J. and Duin, R.P.W},
%	title = {Support vector domain description},
%	journal = {Pattern Recognition Letters},
%	year = {1999},
%	volume = {20},
%	number = {11-13},
%	pages = {1191-1199},
%}
% SEE ALSO
% dd_kernel, inc_add, inc_setup, inc_store

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
  
%function W = incsvdd(a,fracrej,ktype,kpar)
function W = incsvdd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,'p',1);

if mapping_task(argin,'definition')
   [a,fracrej,ktype,kpar]=deal(argin{:});
   W = define_mapping(argin,'untrained','IncSVDD (%s)',...
   getname(dd_proxm([],ktype,kpar)));

elseif mapping_task(argin,'training')
   [a,fracrej,ktype,kpar]=deal(argin{:});

	% be resistent against flipping of the third and forth input
	% parameter (which may be used in  consistent_occ.m
	if isa(ktype,'double')
		if (nargin<4)||~isa(kpar,'char'), kpar = 'r'; end
		tmp = kpar;
		kpar = ktype;
		ktype = tmp;
   end
	% remove double objects... (should I give a warning??)
	[B,I] = unique(+a,'rows');
	if length(I)~=size(a,1),
		a = a(I,:);
		warning('dd_tools:incsvdd:RemoveDoubleObjects',...
		'Some double objects in dataset are removed.');
	end
	dim = size(a,2);
	%define C:
	[It,Io] = find_target(a);
	if length(fracrej)==1 % only error on the target class
		if fracrej<0 % trick to define C directly
			C = -fracrej;
		else
			C = 1/(length(It)*fracrej);
		end
		C = [C C];
	else % use two different Cs for target and outlier class
		if fracrej(1)<0,
			C(1) = fracrej(1);
		else
			C(1) = 1/(length(It)*fracrej(1));
		end
		if fracrej(2)<0,
			C(2) = fracrej(2);
		else
			C(2) = 1/(length(Io)*fracrej(2));
		end
	end

	% do the adding:
	W = inc_setup('svdd',ktype,kpar,C,+a,getoclab(a));
	% store:
	w = inc_store(W);
	W = setname(w,'IncSVDD (%s)',getname(dd_proxm([],ktype,kpar)));

elseif mapping_task(argin,'trained execution')
   [a,fracrej] = deal(argin{1:2});
	% Now evaluate new objects:
	W = getdata(fracrej); % unpack
	[n,dim] = size(a);
	out = repmat(W.offs,n,1);
	for i=1:n
		wa = dd_kernel(+a(i,:),W.sv,W.ktype,W.kpar);
		out(i) = out(i) - 2*wa*W.alf + ...
            dd_kernel(+a(i,:),+a(i,:),W.ktype,W.kpar);
	end
    if (W.threshold<0)
        W.threshold = -W.threshold; % ...DXD  hmmm
    end
	newout = [out repmat(W.threshold,n,1)];
	% store:
	W = setdat(a,-newout,fracrej);
   W = setfeatdom(W,{[-inf 0;-inf 0] [-inf 0;-inf 0]});
else
   error('Illegal call to incsvdd.');

end

