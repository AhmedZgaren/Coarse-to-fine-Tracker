%PARZEN_DD Parzen data description.
% 
%       W = PARZEN_DD(A,FRACREJ,H)
%       W = A*PARZEN_DD([],FRACREJ,H)
%       W = A*PARZEN_DD(FRACREJ,H)
% 
% INPUT
%   A         One-class dataset
%   FRACREJ   Error on the target class (default = 0.1)
%   H         Width parameter (default = [])
%
% OUTPUT
%   W         Parzen data description
%
% DESCRIPTION
% Fit a Parzen density on dataset A. The threshold is put such that
% fracrej of the target objects is rejected.
% 
% If the width parameter is known, it can be given as third parameter H,
% otherwise it is optimized using parzenml.
% 
% SEE ALSO
% parzenml, mappings, dd_roc, nparzen_dd

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
  
%function W = parzen_dd(a,fracrej,h)
function W = parzen_dd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,[]);

if mapping_task(argin,'definition')
   W = define_mapping(argin,'untrained','Parzen');

elseif mapping_task(argin,'training')
   [a,fracrej,h] = deal(argin{:});

	% Make sure a is an OC dataset:
	a = target_class(a);
	k = size(a,2);

	% Train it:
	if (nargin<3) || (isempty(h))
		h = parzenml(a);
	end
	%DXD parzendc expects at least 2 classes nowadays, that's ok, we
	%now just have to do it ourselves:
	%w = parzendc(a,h);
	w = prmapping('parzen_map','trained',{a,h}, getlablist(a),k,1);

	% Obtain the threshold:
	d = +(a*w);
	thr = dd_threshold(d,fracrej);

	%and save all useful data:
	W.w = w;
	%(Strictly speaking h is already stored in w, but for inspection
	%reasons I still want to have it here:)
	W.h = h;
	W.threshold = thr;
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	W = setname(W,'Parzen');

elseif mapping_task(argin,'trained execution') %testing

   [a,fracrej] = deal(argin{1:2});
	W = getdata(fracrej);  % unpack
	m = size(a,1);

	%compute:
	out = +(a*W.w);
	newout = [out, repmat(W.threshold,m,1)];

	% Store the density:
	W = setdat(a,newout,fracrej);
	W = setfeatdom(W,{[0 inf;0 inf] [0 inf;0 inf]});
else
   error('Illegal call to parzen_dd');
end
return


