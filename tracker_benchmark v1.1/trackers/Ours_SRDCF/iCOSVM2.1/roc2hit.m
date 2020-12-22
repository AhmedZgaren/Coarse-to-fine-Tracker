%ROC2HIT Conversion ROC to hit-rate/false-alarm curve
%
%     P = ROC2HIT(R,N)
%
% INPUT
%   R    ROC curve
%   N    Number of target and outlier objects
%
% OUTPUT
%   P    Hit-rate/false-alarm curve
%
% DESCRIPTION
% Convert ROC curve R into a Hit-Rate/false-alarm graph P.
% This is only possible when you supply the number of positive and
% negative objects in N:
%   N(1): number of positive/target objects
%   N(2): number of negative/outier objects
%
% SEE ALSO
% roc2prc, dd_roc, dd_prc, plotroc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function rnew = roc2hit(r,n)

if nargin<2
   if isfield(r,'N')
      n = r.N;
   else
      error('N is not defined.');
   end
else
   if length(n)~=2
      error('N should contain a number for each class.');
   end
end

% compute the hit rate:
hitrate = 1-r.err(:,1);
% and the false alarm rate:
FArate = r.N(2)*r.err(:,2)./(r.N(2)*r.err(:,2)+r.N(1)*hitrate);

% store it in a new curve:
rnew.type = 'hit';
rnew.op = [];
rnew.err = [hitrate FArate];
rnew.thrcoords = [];
rnew.thresholds = [];

