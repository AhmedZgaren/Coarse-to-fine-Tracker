%ROCSQUEEZE Remove redundant points in a ROC curve
%
%      S = ROCSQUEEZE(R)
%   
% INPUT
%   R    ROC curve obtained from DD_ROC
%
% OUTPUT
%   S    Reduced ROC curve
%
% DESCRIPTION
% Reduce the number of points in a ROC curve by removing identical
% points.
%
% SEE ALSO
% dd_roc, plotcosts, simpleroc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
function s = rocsqueeze(r)

% look where steps are made:
df = diff(r.err);
% look where values stay constant:
I0 = (df==0);
% now find where two consequitive values are constant:
I1 = [I0; 0 0];
I2 = [0 0; I0];
I = sum(I1 & I2,2);
I = find(I);

% these values can be removed:
s = r;
s.err(I,:) = [];
s.thrcoords(I,:) = [];
s.thresholds(I,:) = [];

return
