%INCSVC Incremental support vector classifier
%
%     W = INCSVC(A,KTYPE,KPAR,C)
%     W = A*INCSVC([],KTYPE,KPAR,C)
%     W = A*INCSVC(KTYPE,KPAR,C)
%
% INPUT
%   A       Dataset
%   KTYPE   Kernel type (default = 'p')
%   KPAR    Kernel parameter (default = 1)
%   C       Tradeoff parameter (default = 1)
%
% OUTPUT
%   W       Incremental SVC
%
% Optimizes a support vector classifier for the dataset A by an
% incremental procedure to perform the quadratic programming. The
% kernel can be of one of the types as defined by DD_PROXM. Default is
% linear (KTYPE = 'p', KPAR = 1). The kernel computation is done by
% DD_KERNEL which is more lightweight than DD_PROXM.
%
% SEE ALSO
% svc, incsvdd, inc_setup, inc_add

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function W = incsvc(a,ktype,kpar,C)
function W = incsvc(varargin)

argin = shiftargin(varargin,'char');
argin = setdefaults(argin,[],'p',1,1);

if mapping_task(argin,'definition')
   [a,ktype,kpar,C] = deal(argin{:});
   W = define_mapping(argin,'untrained','Inc.SVC (%s)',...
   getname(dd_proxm([],ktype,kpar)));

elseif mapping_task(argin,'training')
   [a,ktype,kpar,C] = deal(argin{:});

	% remove double objects...
	[B,I] = unique(+a,'rows');
	a = a(I,:);

	[n,dim,c] = getsize(a);
	if (c>2)
		W = mclassc(a,prmapping(mfilename,{ktype,kpar,C}));
	else
        % make sure that objects of different classes are mixed a bit
		a = unrandomize(a);
		y = 3 - 2*getnlab(a);
%         y = getnlab(a);

		if length(C)==1, C = [C;C]; end
		% do the adding:
		V = inc_setup('svc',ktype,kpar,C,+a,y);
		% store:
        dat.ktype = ktype;
        dat.kpar = kpar;
        if isempty(V)
            % fill in something stupid:
            dat.alf = 0;
            dat.sv = +a(1,:);
            dat.b = 0;
        else
            setSV = [V.setS; V.setE];
            dat.alf = V.y(setSV).*V.alf(setSV);
            dat.sv = V.x(setSV,:);
            dat.b = V.b;

				% DXD: it seems that when there are no, or just one, support
				% vectors in the active set, the offset b is not properly
				% defined. Set it then by hand:
				if length(V.setS)<2
					K = dd_kernel(V.x(V.setS,:),dat.sv,ktype,kpar);
					V.b = mean(K*dat.alf);
				end
        end
		ll = getlablist(a);
		W = prmapping(mfilename,'trained',dat,ll,dim,size(ll,1));
		W = setname(W,'Inc SVC (%s)',getname(dd_proxm([],ktype,kpar)));
	end

elseif mapping_task(argin,'trained execution') % evaluation!
   [a,ktype] = deal(argin{1:2});
	W = getdata(ktype);
	[n,dim] = size(a);
	out = repmat(W.b,n,1);
	out = zeros(n,1);
	for i=1:n
		K = dd_kernel(+a(i,:),W.sv,W.ktype,W.kpar);
		out(i) = out(i) + K*W.alf;
	end
	W = setdat(a,[out -out],ktype);
else
   error('Illegal call to incsvc.');
end

