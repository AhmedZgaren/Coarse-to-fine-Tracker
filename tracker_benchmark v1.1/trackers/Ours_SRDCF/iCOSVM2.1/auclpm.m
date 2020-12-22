%AUCLPM AUC optimized linear mapping
%
%   W = AUCLPM(X, C, RTYPE, PAR, UNITNORM)
%   W = X*AUCLPM([], C, RTYPE, PAR, UNITNORM)
%   W = X*AUCLPM(C, RTYPE, PAR, UNITNORM)
%
% INPUT
%   X         Dataset
%   C         Regularization parameter (default = 10)
%   RTYPE     Subsample approach for constraints (default = 'subk')
%   PAR       Parameter for subsampling approach (default = 1.0)
%   UNITNORM  Normalize difference vectors (default = 0: no
%             normalization)
%
% OUTPUT
%   W         Trained linear mapping
%
% DESCRIPTION
% Optimize the AUC on dataset X and reg. param. C. This is done by
% finding the weights W for which the ordering of the objects mapped
% onto the line defined by W, is optimal. That means that objects from
% class +1 is always mapped above objects from the -1 class. This
% results in a constraint for each (+1,-1) pair of objects. The number
% of constraints therefore become very large.  The AUC constraints can
% be subsampled in different ways:
%
%		RTYPE     PAR
%	  'full',     -   use all constraints
%	  'subs',     N   subsample just N constraints
%	  'subk',     k   subsample just k*#trainobj. constraints
%	  'knn'       k   use only the k nearest neighbors
%	  'xval'      N   subsample just N constraints and use the rest to
%                 optimize C (this version can be very slow)
%    'xvalk'     k   subsample k*#trainobj and use remaining constraints
%                 to optimize C
%    'kmeans'    k   use k-means clustering with k clusters
%    'randk'     subsample objects to get PAR*(Npos+Nneg) constraints
%
% SEE ALSO
% createA, dd_auc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
  
function [w,returnA,r2] = auclpm(varargin)

prtrace(mfilename);
argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],10,'subk',1.00,1,0);

if mapping_task(argin,'definition')
	[a,C,rtype,par,unitnorm,usematlab] = deal(argin{:});
   w = define_mapping(argin,'untrained',defauclpmname(C,rtype,par,unitnorm));

elseif mapping_task(argin,'training')

	% Unpack the dataset.
	[x,C,rtype,par,unitnorm,usematlab] = deal(argin{:});
	islabtype(x,'crisp');
	isvaldset(x,1,2); % at least 1 object per class, 2 classes
	[n,k,c] = getsize(x); 
	% Check some values:
	if par<=0
		error('Parameter ''par'' should be larger than zero');
	end

	if c == 2  % two-class classifier:

		labl = getlablist(x); dim = size(x,2);
		% first create the target values (+1 and -1):
		% make an exception for a one-class or mil dataset:
		tnr = strmatch('target',labl);
		if isempty(tnr) % no target class defined.
			tnr = strmatch('positive',labl);
			if isempty(tnr) % no positive class defined.
				% we just take the first class as target class:
				tnr = 1;
			end
		end
		y = 2*(getnlab(x)==tnr) - 1;
		tlab = labl(tnr,:);

		% makes the mapping much faster:
		X = +x; clear x;

		%---create A for optauc
        rstate = rand('state');
		seed = 0;
		[A,Nxi,Aval] = createA(X,y,rtype,par,seed);
        rand('state',rstate);
		if unitnorm
			% normalize the length of A:
			lA = sqrt(sum(A.*A,2));
			lenn0 = find(lA~=0);  % when labels are flipped, terrible
			                      % things can happen
			A(lenn0,:) = A(lenn0,:)./repmat(lA(lenn0,:),1,size(A,2));
			if ~isempty(Aval)
				% also normalize the length of Aval:
				lA = sqrt(sum(Aval.*Aval,2));
				lenn0 = find(lA~=0);
				Aval(lenn0,:) = Aval(lenn0,:)./repmat(lA(lenn0,:),1,size(Aval,2));
			end
		end
orgA = A;
		% negative should be present for the constraints:
		A = [A -A];
		% take also care for the xi:
		A = [A -speye(Nxi)];
		%A = [A -eye(Nxi)];
		%---create f
		% NO, do this later, maybe we want to optimize it!
		%f = [ones(2*k,1); repmat(C,Nxi,1)];
		%--- generate b
		b = -ones(Nxi,1);   % no zeros, otherwise we get w=0
		    % the constraint is changed here to <=-1
		%---lower bound constraints
		lb = zeros(2*k+Nxi,1);

		% should we run over a range of Cs?
		if ~isempty(Aval)
			M = 25;
			xtr = zeros(M,1);
			xval = zeros(M,1);
			C = logspace(-3,3,M);
         % run over all the Cs
			for i=1:length(C)
				%---create f again:
				f = [ones(2*k,1); repmat(C(i),Nxi,1)];
				%---solve linear program
				if (exist('glpk')>0) & ~usematlab
					[z,fmin,status]=glpk(f,A,b,lb,[],repmat('U',Nxi,1),...
						repmat('C',size(f,1),1),1);
				elseif (exist('glpkmex')>0) & ~usematlab
					[z,fmin,status]=glpkmex(1,f,A,b,repmat('U',Nxi,1),...
						lb,[],repmat('C',size(f,1),1));
				else
					opts = optimset('Display','off','LargeScale','on','Diagnostics','off');
					z = linprog(f,A,b,[],[],lb,[],[],opts);
				end
				constr = Aval*(z(1:k)-z(k+1:2*k));
				% the number of satisfied constraints (=AUC:)
				I = find(constr<-0);
				if ~isempty(I)
					xval(i) = length(I)/size(constr,1);
				end
				% the number of satisfied constraints (=AUC:)
				constr = orgA*(z(1:k)-z(k+1:2*k));
				I = find(constr<-0);
				if ~isempty(I)
					xtr(i) = length(I)/size(constr,1);
				end
			end
if nargout>1
	returnA = xval;
	if nargout>2
		r2 = xtr;
	end
end
			[minxval,mini] = max(xval);
			C = C(mini);
		end
		%---create f
		f = [ones(2*k,1); repmat(C,Nxi,1)];
		%---solve linear program
		if (exist('glpkmex')>0) & ~usematlab
			prwarning(7,'Use glpkmex');
			param.msglev=0;
			[z,fmin,status,xtra]=glpkmex(1,f,A,b,repmat('U',Nxi,1),...
				lb,[],repmat('C',size(f,1),1),param);
			alpha = []; %xtra.lambda;
		else
			[z,fmin,exitflag,outp,alpha] = linprog(f,A,b,[],[],lb);
		end

		%---extract parameters
		u = z(1:k); u = u(:);
		v = z(k+1:2*k); v = v(:);
		zeta = z(2*k+1:2*k+Nxi); zeta = zeta(:);
	else
		error('Only a two-class classifier is implemented');
	end
	% now find out how sparse the result is:
	rel = (abs(u-v)>1e-6);
	nr = sum(rel);
	if (nr==0)
		error('None of the features is selected. Please make the C a bit larger.');
	end
	
	% and store the results:
	W.u = u-v; %the ultimate weights
	W.alpha = alpha;
	W.zeta = zeta;
	W.nr = nr;
	W.rel = rel;
	W.C = C;
	w = prmapping(mfilename,'trained',W,tlab,dim,1);
	w = setname(w,defauclpmname(C,rtype,par,unitnorm));
	
elseif mapping_task(argin,'trained execution')
	% Evaluate the classifier on new data:
   [x,C] = deal(argin{1:2});
	W = getdata(C);
	n = size(x,1);

	% linear classifier:
	out = x*W.u;

	% and put it nicely in a prtools dataset:
	% (I am not really sure what I should output, I decided to give a 1D
	% output:)
	w = setdat(x,out,C);
else
   error('Illegal call');

end
		
return

function cl_name = defauclpmname(C,rtype,par,unitnorm)
% define the correct name:
if unitnorm
	cl_name = sprintf('AUClpm (C=%s, %s, k=%s) 1norm',num2str(C),rtype,num2str(par));
else
	cl_name = sprintf('AUClpm (C=%s, %s, k=%s)',num2str(C),rtype,num2str(par));
end

return
