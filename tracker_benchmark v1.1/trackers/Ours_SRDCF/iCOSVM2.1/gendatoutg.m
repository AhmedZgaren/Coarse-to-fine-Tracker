%GENDATOUTG Generate Gaussian distr. outlier objects
%
%       Z = GENDATOUTG(A,N,SCALE)
%       Z = A*GENDATOUTG([],N,SCALE)
%       Z = A*GENDATOUTG(N,SCALE)
%
% INPUT
%   A       One-class dataset
%   N       Number of objects (default = 100)
%   SCALE   Scaling factor of covariance matrix (default = 1.5)
%
% OUTPUT
%   Z    Dataset
%
% DESCRIPTION
% Generate N outlier objects in a Gaussian distr. round dataset A. This
% dataset should be a one-class dataset.
% Note that the original data A is not included in the
% dataset! (To do that, do:  Z = GENDATOC(A,Z); )
%
% The covariance matrix can be enlarged by a certain fraction:
% C' = dR*C_org.
%
% SEE ALSO
% make_outliers, gendatoc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function z = gendatoutg(a,n,dR)
function z = gendatoutg(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],100,1.5);

if mapping_task(argin,'definition')
   z = define_mapping(argin,'generator','Gaussian outlier generation');
   return
end

[a,n,dR] = deal(argin{:});
% what is our target data?
if isocset(a)
	featlab = getfeatlab(a);
	a = +target_class(a);
else
	featlab = [];
	a = +a;
end

[nra,dim] = size(a);

% 'train' the Gaussian model
meana = mean(a);
a = a - repmat(meana,nra,1);
% the C-matrix
C = dR*cov(a);

% generate new data
zdat = gauss(n,meana,C);

%label it as outliers
z = prdataset(+zdat,repmat('outlier',n,1), 'featlab',featlab);
z = setname(z,'Artif. Gaussian-distr''d outliers');

return
