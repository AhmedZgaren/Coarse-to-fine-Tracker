%
%    OUT = CHECKPRVERSION
%
% Check the version of Prtools, and see if it is good enough for
% dd_tools. If you pass the test, OUT=1, otherwise OUT=0.

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function out = checkprversion;

out = 1; %everything OK...
minversion = 5.0;
% Generate a newline:
if strcmp(computer,'MAC2')
   newln = char(13);
else
   newln = char(10);
end
% For fun, some color:
if ~usejava('desktop')
	clr_on = [char(27) '[1;31m'];
	clr_off = [char(27) '[0;0m'];
else
	clr_on = [];
	clr_off = [];
end
% check if prtools exist
if ~exist('prversion')
	error([clr_on '  !! Cannot find Prtools. Please put Prtools in your path.' clr_off]);
end
% And do the check:
if prversion<minversion
	str = sprintf('This version of Dd_tools requires >= Prtools %3.1f!',...
	       minversion);
	error([clr_on newln '---- ' str ' ----' clr_off]);
	out = 0;
end

return
