% GENDATGRID make grid dataset around a 2D dataset
%
%   GRIDDAT = GENDATGRID(A,NRSTEPS)
%   GRIDDAT = GENDATGRID([],NRSTEPS,MINVAL,MAXVAL);
%   GRIDDAT = GENDATGRID;
%
% INPUT
%   A           One-class dataset
%   NRSTEPS     Size of the grid (default = [gridsize gridsize])
%   MINVAL      Vector with minimum values
%   MAXVAL      Vector with maximum values
%
% OUTPUT
%   GRIDDAT     2D objects on a grid
%
% DESCRIPTION
% Make a grid over the region of data A with number of steps given
% in NRSTEPS (1x2 matrix). Per default the global variable GRIDSIZE
% is used. This works only for 2D datasets A.
%
% When no arguments are given, the axis limits of the current figure
% are used.
%
% The user can supply the minimum and maximum values: MINVAL,MAXVAL.
% Then the dataset is not used.
%
% SEE ALSO
% makegriddat, plotg

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function griddat = gendatgrid(a,nrsteps,minval,maxval);
if nargin<3
	if nargin<1
		% when no arguments are given, look at the current figure:
		V = axis;
		minval = [V(1) V(3)];
		maxval = [V(2) V(4)];
	else
		% use the data from the dataset a:
		minval = min(a);
		maxval = max(a);
	end
	% extract a slightly larger area around the data:
	diff = maxval-minval;
	meanval = (maxval+minval)/2;
	newscale = 0.75 * diff;
	minval = (meanval - newscale);
	maxval = (meanval + newscale);
end

% given the min- and max-values, generate the grid data:
if nargin<2
	griddat = makegriddat(minval(1),maxval(1),minval(2),maxval(2));
else
	if (max(size(nrsteps))==1) %this looks like a hack;-)
		% take the same number of steps in both feature directions
		nrsteps(2) = nrsteps;
	end
	griddat = makegriddat(minval(1),maxval(1),minval(2),maxval(2),...
	nrsteps(1),nrsteps(2));
end

return
