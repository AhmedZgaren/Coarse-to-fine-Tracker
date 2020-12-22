%DISSIM Dissimilarity transformations
%
%    B = DISSIM(A,TTYPE,PAR)
%    W = DISSIM([],TTYPE,PAR)
%
% INPUT
%   A       Dataset
%   TTYPE   Dissimilarity type (default = 'd2s')
%   PAR     Additional parameters for dissimilarity (default = 1)
%
% OUTPUT
%   B       Dissimilarity dataset
%   W       Dissimilarity mapping
%
% DESCRIPTION
% Define a mapping for a 1-to-1 transformation.
% Possible transformations TTYPE are:
% 
%      TTYPE
%  'identity','i'  out = in;
%  'd2s','s2d'     out = 1-in;                     D->S->D
%  'diag','g'      out_ij = in_ii+in_jj-2in_ij        S->D
%  'sqrt','q'      out = sqrt(1-in)                   D->S
%  'rbf','r'       out = exp(-in*in/(par(1)*par(1)))  D->S
%  'exp','e'       out = exp(-in/par(1))              D->S
%  'mlog','m'      out = -log(in/par(1))
%  'sigm','s'      out = 2/(1+exp(-in/par(1))) - 1    D->D
%  'dsigm','d'     out = 4par(1)/(1+exp(-in/par(1))) - 2par(1)    D->D
%                  ('d' is similar to 's', only a scaled version)
%
% If a dataset A is supplied, the data is directly mapped (and thus
% no mapping is defined).
%
% Note: I agree that the name is not very fortunate, but I didn't
% have enough inspiration for a good one:-)
%
% SEE ALSO
% dd_proxm, proxm, sqeucldistm

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function w = dissim(a,ttype,p)
function w = dissim(varargin)

argin = shiftargin(varargin,'char');
argin = setdefaults(argin,[],'d2s',1);

if mapping_task(argin,'definition')
   w = define_mapping(argin,'fixed','Dissim.transf.');

elseif mapping_task(argin,'fixed execution')

   [a,ttype,p] = deal(argin{:});
   switch ttype
   case {'identity','i'}
       w = a;
   case {'d2s','s2d'}
       w = 1-a;
   case {'diag','g'}
      n1 = size(a,1); n2 = size(a,2);
      if (n1~=n2), error('Dataset A should be square!'); end
      w = repmat(diag(+a),1,n1) + repmat(diag(+a)',n1,1) - 2*a;
   case {'sqrt','q'}
       w = sqrt(1-a);
   case {'rbf','r'}
       w = exp(-a.*a/(p(1)*p(1)));
   case {'exp','e'}
       w = exp(-a/(p(1)*p(1)));
   case {'mlog','m'}
       w = -log(a/p(1));
   case {'sigm','s'}
       w = 2./(1+exp(-a/p(1))) - 1;
   case {'dsigm','d'}
       w = (4*p(1))./(1+exp(-a/p(1))) - 2*p(1);
   otherwise
       error('Transformation is unknown');
   end
else
   error('Illegal call to dissim');
end
return

