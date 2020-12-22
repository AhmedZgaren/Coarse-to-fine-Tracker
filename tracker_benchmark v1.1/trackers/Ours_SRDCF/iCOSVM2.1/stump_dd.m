%STUMP_DD Threshold one dim. one-class classifier
% 
%       W = STUMP_DD(A,FRACREJ,DIM)
%
% INPUT
%   A         One-class dataset
%   FRACREJ   Error on the target class (default = 0.1)
%   DIM       Feature number (default = 1)
%
% OUTPUT
%   W         Decision stump
% 
% DESCRIPTION
% Put a threshold on one of the feature dimensions DIM of dataset A. The
% threshold is put such that a fraction FRACREJ of the targets is
% rejected.
%
% SEE ALSO
% dd_threshold, dd_roc, dd_error

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function W = stump_dd(a,fracrej,dimnr)
function W = stump_dd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,1);

if mapping_task(argin,'definition')
   W = define_mapping(argin,'untrained','Stump OCC');

elseif mapping_task(argin,'training')

   [a,fracrej,dimnr] = deal(argin{:});
	fd = getfeatdom(a);
	a = target_class(a);     % only use the target class
	[m,k] = size(a);

	% test if the dimension exist
	if (dimnr<1) || (dimnr>k)
		error('Feature dimension %d does not exist.',dimnr);
	end
	% get the threshold:
	% (how to check that we are working with densities or densities??)
	if ~isempty(fd) && ~isempty(fd{dimnr})
		if all(fd{dimnr}==[-inf 0])
			W.threshold = dd_threshold(+a(:,dimnr),1-fracrej);
		else
			W.threshold = dd_threshold(+a(:,dimnr),fracrej);
		end
	else  % I don't know what outputs I am looking at, fall back to the
		% default setting:
		W.threshold = dd_threshold(+a(:,dimnr),fracrej);
	end
	W.dim = dimnr;
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	W = setname(W,'Threshold one-class classifier');

elseif mapping_task(argin,'trained execution') %testing

   [a,fracrej] = deal(argin{1:2});
	% Unpack the mapping and dataset:
	W = getdata(fracrej);
	[m,k] = size(a); 

	% This classifier only contains the threshold, nothing more.
	thr = W.threshold;
	newout = [+a(:,W.dim) repmat(thr,m,1)];

	% Fill in the data, keeping all other fields in the dataset intact:
	W = setdat(a,newout,fracrej);

	% Invent what the feature domain of the dataset should be:
	fd = getfeatdom(a);
	if ~isempty(fd) && ~(isa(fd,'cell') && isempty(fd{1}))
		W = setfeatdom(W,fd);
	else
		% Just guess from the sign of the label.
		% This is a terrible hack of course...
		if thr<0
			W = setfeatdom(W,{[-inf 0; -inf 0] [-inf 0; -inf 0]});
		else
			W = setfeatdom(W,{[0 inf; 0 inf] [0 inf; 0 inf]});
		end
	end
else
   error('Illegal call to stump_dd.');
end
return


