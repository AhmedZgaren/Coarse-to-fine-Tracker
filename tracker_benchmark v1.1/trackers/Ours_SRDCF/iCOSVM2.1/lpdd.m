%LPDD Linear programming distance data description
%
%         W = LPDD(X,NU,S,DTYPE,DPAR)
%         W = X*LPDD([],NU,S,DTYPE,DPAR)
%         W = X*LPDD(NU,S,DTYPE,DPAR)
% 
% INPUT
%   X       Dataset
%   NU      Fraction error on target data (default = 0.1)
%   S       Scale parameter for sigmoid (default = 1)
%   DTYPE   Distance definition (default = 'd')
%   DPAR    Parameter for distance (default = 2)
%
% OUTPUT
%   W       LP distance model
%
% DESCRIPTION
% One-class classifier put into a linear programming framework. From
% the data X the distance matrix is computed (using distance DTYPE,
% see dd_proxm for the possibilities). The distances are then
% transformed using a sigmoidal transformation (with parameter S,
% see the function dissim.m) and on this the linear machine is
% trained. The parameter NU gives the possible error on the target
% class.
%
% This function is basically a wrapper around dlpdd. See dd_ex2 to
% see how it works.
%
% REFERENCE
%@inproceedings{Pekalska2002,
%	author = {Pekalska, E. and Tax, D.M.J. and Duin, R.P.W.},
%	title = {One-class {LP} classifier for dissimilarity representations},
%	booktitle = {Advances in Neural Information Processing Systems},
%	year = {2003},
%	pages = {},
%  editor =       {S.~Becker and S.~Thrun and K.~Obermayer},
%  volume =       {15},
%  publisher = {MIT Press: Cambridge, MA}
%}
% SEE ALSO
% dd_proxm, dissim, dlpdd, dd_ex2

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function W = lpdd(x,nu,s,dtype,par)
function W = lpdd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,1,'d',2);

if mapping_task(argin,'definition')       % Define mapping
   W = define_mapping(argin,'untrained','LpDD');

elseif mapping_task(argin,'training')			% Train a mapping.

   [x,nu,s,dtype,par] = deal(argin{:});
	% Use all different methods:
	% First define the distance mapping:
	wd = dd_proxm(x,dtype,par);
	% Second the distance transformation:
	ws = dissim([],'dsigm',s);
	% And finally do the real work in dlpdd:
	w = dlpdd(x*wd*ws,nu);

	% store the results
	W.wd = wd;
	W.ws = ws;
	W.w = w;
  	% Also set the s explicitly, useful for inspection purposes:
	ww = +ws;
	W.s = +ww{2};
	% Because I promised that all the OCCs have a threshold, it
	% should be given here:
	ww = +w;
	W.threshold = ww.threshold; 

	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),size(x,2),2);
	W = setname(W,'LpDD');
elseif mapping_task(argin,'trained execution') %testing

   [x,nu,s,dtype,par] = deal(argin{:});
	W = getdata(nu);  % unpack
	% and here we go:
	newout = x*W.wd*W.ws*W.w;

	% Copy the output of the dlpdd:
	W = setdat(x,newout,nu);
	W = setfeatdom(W,{[-inf 0;-inf 0] [-inf 0;-inf 0]});
else
   error('Illegal call to lpdd');

end
return



