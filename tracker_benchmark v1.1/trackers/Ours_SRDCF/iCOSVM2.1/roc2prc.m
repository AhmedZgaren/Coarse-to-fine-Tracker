%ROC2PRC Conversion ROC to precision-recall graph
%
%     P = ROC2PRC(R,N)
%
% INPUT
%   R    ROC curve
%   N    Number of objects in each class
%
% OUTPUT
%   P    Precision-recall graph
%
% DESCRIPTION
% Convert ROC curve R into a Precision-Recall graph P.
% This is only possible when you supply the number of positive and
% negative objects in N:
%   N(1): number of positive/target objects
%   N(2): number of negative/outier objects
%
% Although the ROC curve is independent of the class skew, the
% precision-recall is certainly not!
%
% SEE ALSO
% dd_roc, dd_prc, plotroc, roc2hit

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function pnew = roc2prc(r,n)

if length(n)~=2
	error('N should contain a number for each class.');
end

% compute the precision and recall from the True positives and false
% positives
TP = (1-r.err(:,1))*n(1);
FP = r.err(:,2)*n(2);
prec = TP./(TP+FP);
rec = TP/n(1);
er = [prec rec]; er(end,:) = [];

% store the new precision and recall number in a new PRcurve
pnew.type = 'prc';
pnew.op = [];
pnew.err = er(end:-1:1,:);
pnew.thrcoords = [];
pnew.thresholds = [];

