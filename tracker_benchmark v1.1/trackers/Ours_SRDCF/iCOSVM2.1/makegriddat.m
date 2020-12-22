%MAKEGRIDDAT Make uniform 2D grid.
%
% [GRIDDAT,X,Y] = MAKEGRIDDAT(MINX,MAXX,MINY,MAXY,NRSTEPX,NRSTEPY)
%
% INPUT
%   MINX,MAXX    Minimum and maximum value for X
%   MINY,MAXY    Minimum and maximum value for Y
%   NRSTEPX,
%     NRSTEPY    Number of steps in X and Y
%
% OUTPUT
%   GRIDDAT      Data matrix
%   X            Used X values
%   Y            Used Y values
%
% DESCRIPTION
% Make a uniform 2D grid of objects and store it in a 2xN array. This
% array is not directly a PRTools dataset, but can be used for making
% a 2D plot of a user function:
%
% >> grid = makegriddat(0,10,0,10);
% >> out = f(grid);  % any method f can be applied here.
% >> plotg(grid,out);
%
% This method uses GRIDSIZE when nrstepx and nrstepy are not supplied.
%
% SEE ALSO
% gendatgrid, plotg, meshgrid

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function [griddat,x,y] = makegriddat(minx,maxx,miny,maxy,nrstepx,nrstepy)

global GRIDSIZE;
% when GRIDSIZE is needed, but it is not defined, we have to set it
% ourselves:
if nargin<6
	if isempty(GRIDSIZE)
		nrstepy = 30;
	else
		nrstepy = GRIDSIZE;
	end
end
if nargin<5
	if isempty(GRIDSIZE)
		nrstepx = 30;
	else
		nrstepx = GRIDSIZE;
	end
end

% Now the ranges over x and y can be defined:
stepx = (maxx-minx)/(nrstepx-1);
stepy = (maxy-miny)/(nrstepy-1);

x = minx:stepx:maxx;
y = miny:stepy:maxy;

% To make the grid, we rely on a Matlab function:
[gx,gy] = meshgrid(x,y);
griddat=[reshape(gx,nrstepx*nrstepy,1), reshape(gy,nrstepx*nrstepy,1)];

return
