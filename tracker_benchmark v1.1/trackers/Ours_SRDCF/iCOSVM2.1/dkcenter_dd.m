%DKCENTER_DD Distance k-center data description.
% 
%       W = DKCENTER_DD(D,FRACREJ,K,NRTRIES)
%       W = D*DKCENTER_DD([],FRACREJ,K,NRTRIES)
%       W = D*DKCENTER_DD(FRACREJ,K,NRTRIES)
% 
% INPUT
%   D         Distance data
%   FRACREJ   Error on the target class (default = 0.1)
%   K         Number of clusters (default = 5)
%   NRTRIES   Number of restarts (default = 25)
%
% OUTPUT
%   W         k-Center model
%
% DESCRIPTION
% Train a K-center method with K prototypes on distance dataset D.
% 
% SEE ALSO
% datasets, mappings, dd_roc, kcenter_dd

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function W = dkcenter_dd(D,fracrej,K,nrtries)
function W = dkcenter_dd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,5,25);

if mapping_task(argin,'definition')
   W = define_mapping(argin,'untrained','D.K-Centers');

elseif mapping_task(argin,'training')

   [D,fracrej,K,nrtries] = deal(argin{:});
	% make sure a is an OC dataset
	if ~isocset(D)
		error('I expect a one-class dataset');
	end
	k = size(D,2);

	% train it:
	D(1:(k+1):end) = 0;  % *sigh* 
	[lab,J] = kcentres(D,K,nrtries);

	% obtain the threshold:
	% set the diagonal to inf:
	%D(1:(k+1):end) = inf;
	d = sqrt(min(D(:,J),[],2));
	thr = dd_threshold(d,1-fracrej);

	%and save all useful data:
	W.J = J;
	W.threshold = thr;
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	W = setname(W,'Dist. K-Centers data description');

elseif mapping_type(argin,'trained execution')

   [D,fracrej] = deal(argin{1:2});
	W = getdata(fracrej);  % unpack
	m = size(D,1);

	%compute:
	newout = [sqrt(min(D(:,W.J),[],2)) repmat(W.threshold,m,1)];

	% store the distance as output:
	W = setdat(D,-newout,fracrej);
	W = setfeatdom(W,{[-inf 0;-inf 0] [-inf 0; -inf 0]});
end
return


