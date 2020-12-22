%DD_THRESHOLD Find percentile value for dataset
%
%      THR = DD_THRESHOLD(D,FRAC)
%
% INPUT
%   D      Vector of real values
%   FRAC   Quantile value
%
% OUTPUT
%   THR    Threshold value
%
% DESCRIPTION
% Find the threshold for the data D. The lowest  FRAC*100%  of the
% data is rejected. This method is therefore first aimed at thresholds
% for density estimates. When the highest  FRAC*100%  of the data
% should be rejected, you have to use:   THR = -THRESHOLD(-D,FRAC).
% (prctile in the statistics toolbox can also be used)
%
% SEE ALSO
% prctile

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function [thr,frac] = dd_threshold(d,fracrej)
[nr,dim] = size(d);
if (dim>1)
	error('dd_threshold is expecting a 1D array.');
end
if length(fracrej)>1
	error('FRAC should be a scalar value.');
end
if ((fracrej<0)||(fracrej>1))
	error('FRAC in threshold should be between 0 and 1.');
end
d = sort(d);
frac = round(fracrej*nr);
if (frac==0)
	frac = 1;
	thr = d(frac);
else
	if (frac==nr)
		thr = d(frac);
	else
		thr = (d(frac) + d(frac+1))/2;
	end
end

return
