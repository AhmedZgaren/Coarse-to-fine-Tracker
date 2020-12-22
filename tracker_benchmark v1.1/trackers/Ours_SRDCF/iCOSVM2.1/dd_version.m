%DD_VERSION Version information for dd_tools
%
%        [VER,NR] = DD_VERSION
%        DD_VERSION UPGRADE('upgrade')
%
% OUTPUT
%    VER      Version number of installed DD_tools as string
%    NR       Version number as real number
%
% DESCRIPTION
% Returns the string VER, or the real number NR, containing the version
% number of the currently loaded dd_tools. 
% When the Java virtual machine is running also the most up-to-date
% version of dd_tools is shown.
%
% When you request for an 'upgrade', the user is asked for a directory,
% and the newest version is downloaded in that place.

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function [ver,vernr] = dd_version(dodownload)
if nargin<1
	dodownload = '';
end

%
newver = [];
newl = sprintf('\n');
p = which('gauss_dd');
ddpath = fileparts(p);
% find dd_tools directory name:
I = findstr(ddpath,filesep);
if isempty(I)
	dddir = ddpath;
else
	dddir = ddpath(I(end)+1:end);
end
% open the Contents file and find the current version:
h = help(dddir);
I = findstr(h,'Version');
h = h(I(1)+8:end);
I = findstr(h,' ');
ver = h(1:I(1)-1);

% now go to the standard webpage and extract the URL
if usejava('jvm')
	ddpage = urlread('http://prlab.tudelft.nl/david-tax/dd_tools.html');
	I = strfind(ddpage,'DD_DOWNLOAD');
	if isempty(I)
      newver = [];
   else
      ddurl = ddpage(I(1):I(1)+150);
      I = strfind(ddurl,'"');
      ddurl = ddurl(I(1)+1:I(2)-1);

      % now find the version of this .zip...
      I = strfind(ddurl,'_');
      Idot = strfind(ddurl,'.');
      newver = sprintf('%s.%s.%s',ddurl(I(end-2)+1:I(end-1)-1),...
      ddurl(I(end-1)+1:I(end)-1),ddurl(I(end)+1:Idot(end)-1));

      % shall we update?
      if strcmp(dodownload,'upgrade')
         I = strfind(ddurl,'/');
         ddfile = ddurl(I(end)+1:end);
         [ddname,ddplace] = uiputfile('*','Select place to save dd_tools',ddfile);
         urlwrite(ddurl,fullfile(ddplace,ddfile));
         fprintf('Success!: %s is saved in %s.\n',ddfile,ddplace);
         fprintf('Unzip the file and add the path to your matlab path.\n');
         return
      end
   end
else
	if strcmp(dodownload,'upgrade')
		error('Java Virtual Machine is not running. Please download from http://prlab.tudelft.nl/david-tax/dd_tools.html');
	end
end

% make a pretty print when nargout=0
if nargout==0
	fprintf('Currently installed version is dd_tools %s.\n',ver);
	if ~isempty(newver)
		newvernr = versionscalar(newver);
      vernr = versionscalar(ver);
      if newvernr>vernr
            fprintf('The newest version is %s.\n',newver);
		elseif vernr==newvernr
			fprintf('You are up to date.\n');
		else
			fprintf('You have a dd_tools from the future! (current version %s)\n',...
			newver);
		end
	end

	clear ver;
end

% find also the numerical version if requested:
if nargout>1
   vernr = versionscalar(ver);
end

return

function n = versionscalar(str)
I = find(str=='.');
if isempty(I)
	n = str2num(str);
else
	n = 0;
	base = 1;
	I = [0 I length(str)+1];
	for i=1:length(I)-1
		n = n + str2num(str(I(i)+1:I(i+1)-1))/base;
		base = base*100;
	end
end
return



