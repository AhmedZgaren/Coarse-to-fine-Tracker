%KCENTER_DD k-center data description.
% 
%       W = KCENTER_DD(A,FRACREJ,K,NRTRIES)
%       W = A*KCENTER_DD([],FRACREJ,K,NRTRIES)
%       W = A*KCENTER_DD(FRACREJ,K,NRTRIES)
% 
% INPUT
%   A         Dataset
%   FRACREJ   Error on the target class (default = 0.1)
%   K         Number of clusters (default = 5)
%   NRTRIES   Number of restarts (default = 25)
%
% OUTPUT
%   W       k-center model
%
% DESCRIPTION
% Train a k-center method with K prototypes on dataset A. Sometimes the
% clustering on A fails, and less than K clusters are found. If that is
% the case, the clustering is restarted. At most NRTRIES times the
% clustering is restarted.
% 
% SEE ALSO
% kmeans_dd, dkcenter_dd, som_dd, dd_roc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
  
%function W = kcenter_dd(a,fracrej,K,nrtries)
function W = kcenter_dd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,5,25);
  
if mapping_task(argin,'definition')       % Define mapping
   W = define_mapping(argin,'untrained','k-centers DD');
    
elseif mapping_task(argin,'training')			% Train a mapping.
  
   [a,fracrej,K,nrtries] = deal(argin{:});
	a = +target_class(a);     % make sure a is an OC dataset
	k = size(a,2);

	% train it:
	D = sqrt(sqeucldistm(a,a));
	D = (D+D')/2;
	w = dkcenter_dd(target_class(D),fracrej,K,nrtries);

	%and save all useful data:
	W.w = w;
	W.train_a = a;
	W.threshold = w.data.threshold;
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	W = setname(W,'K-Centers data description');

elseif mapping_task(argin,'trained execution') %testing

   [a,fracrej] = deal(argin{1:2});
	W = getdata(fracrej);  % unpack

   % make sure that the thresholds are consistent...
   v = W.w;
   dat = v.data; dat.threshold = W.threshold; v.data=dat;

	%compute:
	D = sqrt(sqeucldistm(+a,+W.train_a));
	newout = +(D*v);

	% Store the distance as output (note that the 'w' already took care
	% of the minus-sign for the distance):
	W = setdat(a,newout,fracrej);
	W = setfeatdom(W,{[-inf 0;-inf 0] [-inf 0;-inf 0]});
else
   error('Illegal call to kcenter_dd');
end
return


