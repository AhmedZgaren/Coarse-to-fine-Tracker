%ABOF_DD Angle-based Outlier factor data description.
% 
%    W = ABOF_DD(A,FRACREJ)
%    W = A*ABOF_DD([],FRACREJ)
%    W = A*ABOF_DD(FRACREJ)
%
% INPUT
%    A        Dataset
%    FRACREJ  Fraction of targets rejected
%
% OUTPUT
%    W        ABOF data description
%   
% DESCRIPTION
% Use the Angle-based Outlier Factor to find the outliers in a dataset.
% This should work for high dimensional datasets, but it is kind of slow.
%
% REFERENCE
% 'Angle-based outlier detection in high-dimensional data', H-P Kriegel,
% M. Schubert, A. Zimek, Proc.14th ACM SIGKDD conf. on KDD'08.
%
% SEE ALSO
% lof_dd

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
  
function W = abof_dd(varargin)

argin = shiftargin(varargin,'scalar'); % handle  A*ABOF_DD(FRACREJ)
argin = setdefaults(argin,[],0.1);     % default values, fracrej=0.1

if mapping_task(argin,'definition')    % define empty mapping
   W = define_mapping(argin,'untrained','ABOF');

elseif mapping_task(argin,'training')  % train the mapping
   [a,fracrej] = deal(argin{:});
	a = target_class(a);     % only use the target class
	% checks:
   xx = unique(+a,'rows');
   [m,k] = size(xx);
   if (m<3)
        error('I need at least 3 (unique) target objects.');
   end
	% Obtain the threshold on the train data:
   out = zeros(m,1);
   I = find(triu(ones(m-1,m-1),1));
   for i=1:m
       % the difference vectors:
       df = repmat(xx(i,:),m,1)-xx;
       df(i,:) = [];  % do LOO
       % all inner products:
       df2 = df*df';
       % normalise:
       ang = df2./(repmat(diag(df2),1,m-1).*repmat(diag(df2)',m-1,1));
       % and compute the variance:
       out(i) = var(ang(I));
   end
	thr = dd_threshold(out,fracrej);

	%and save all useful data:
	W.x = xx;
	W.threshold = thr;
	W.scale = mean(out);
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	W = setname(W,'ABOF');

elseif mapping_task(argin,'trained execution')   %testing

	% Extract the data:
   [a,fracrej] = deal(argin{1:2});
	W = getdata(fracrej);
   n = size(W.x,1);
	m = size(a,1);

	% Compute the abof for all test objects
   out = zeros(m,1);
   I = find(triu(ones(n,n),1));
   for i=1:m
       df = repmat(+a(i,:),n,1) - W.x;
       df2 = df*df';
       ang = df2./(repmat(diag(df2),1,n).*repmat(diag(df2)',n,1));
       out(i) = var(ang(I));
   end
   newout = [out repmat(W.threshold,m,1)];
    
	% Store the output:
	W = setdat(a,newout,fracrej);
	W = setfeatdom(W,{[0 inf; 0 inf] [0 inf; 0 inf]});
else
   error('Illegal call');
end
return


