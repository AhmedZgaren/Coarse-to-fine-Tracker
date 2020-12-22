%ISOCSET True for one-class datasets
%
%     N = ISOCSET(A)
%
% INPUT
%   A      Dataset
%
% OUTPUT
%   N      0/1 if A isn't/is a one-class dataset
%
% DESCRIPTION
% Exactly the same as IS_OCSET, so that you can use it with or without
% underscore in the name.
%
% SEE ALSO
% is_ocset

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function out = isocset(a)

if nargout>0
   out = is_ocset(a);
else
   is_ocset(a);
end
