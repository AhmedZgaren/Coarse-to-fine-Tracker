%ISTARGET true if the label is target
%
%   I = ISTARGET(A)
%   I = ISTARGET(LAB)
%
% INPUT
%   A      Dataset
%   LAB    Label vector
%
% OUTPUT
%   I      0/1 vector indicating if objs aren't/are target objects
%
% DESCRIPTION
% Returns 1 for the objects in dataset A which are labeled 'target', and
% 0 otherwise.  It also works when no dataset but a label matrix given.
%
% SEE ALSO
% find_target, isocset, gendatoc, oc_set

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function I = istarget(a)

% Check that we are dealing with a one-class dataset
if ~isocset(a)
	%warning('Dataset is not a one-class dataset');
end
if isdataset(a)
	[nlab,lablist] = getnlab(a);
elseif isa(a,'char')
	[nlab,lablist] = renumlab(a);
else
	error('I cannot handle input variable A');
end

% first find the target objects:
nr_t = strmatch('target',lablist);
if isempty(nr_t)
	if nargout==1
		warning('dd_tools:NoTargetPresent',...
			'Cannot find target objects in dataset.');
	end
	I = zeros(size(nlab,1),1);
else
	I = (nlab==nr_t);
end

return

