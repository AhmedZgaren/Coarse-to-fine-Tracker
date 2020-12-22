%GETROCW Retrieve mapping from an ROC plot
%
%      W = GETROCW(H)
%
% INPUT
%   H      Figure handle
%
% OUTPUT
%   W      Trained mapping
%
% DESCRIPTION
% Retrieve the mapping that was changed using PLOTROC from the figure.
% The figure handle H should be supplied.
%
% SEE ALSO
% dd_roc, plotroc, dd_setfn

function w = getrocw(h)

UD = get(h,'userdata');
if isempty(UD)
	% maybe it is in the parent?
	h2 = get(h,'parent');
	if ~isempty(h2)
		w = getrocw(h2);
	else
		UD
		error('No userdata is defined, is a correct handle H supplied?');
	end
else
	if ~isfield(UD,'w')
		error('No field "w" is defined in the userdata.');
	end

	w = UD.w;
end

return

