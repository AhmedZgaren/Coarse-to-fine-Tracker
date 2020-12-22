%IS_OCC Test for one-class classifiers
%
%    N = ISOCC(W)
%
% INPUT
%   W    Classifier
%
% OUTPUT
%   N    0/1 if W isn't/is a one-class classifier
%
% DESCRIPTION
% This is exactly the same as IS_OCC, but I made this because I always
% forget if there is an understore or not...
%
% SEE ALSO
% is_occ

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function out = isocc(w)

out = is_occ(w);

