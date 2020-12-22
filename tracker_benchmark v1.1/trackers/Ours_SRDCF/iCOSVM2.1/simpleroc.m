%SIMPLEROC Basic receiver-operating characteristic curve
%
%      F = SIMPLEROC(PRED,TRUELAB)
%
% INPUT
%   PRED      Prediction of a classifier
%   TRUELAB   True labels
%
% OUTPUT
%   F         ROC graph
%
% DESCRIPTION
% Compute the ROC curve for the network output PRED, given the true
% labels TRUELAB. TRUELAB should contain 0-1 values. When TRUELAB=0,
% then we should have (PRED<some_threshold) , and when TRUELAB=1, we
% should get (PRED>some_threshold).  Output F contains [FNr FPr].
%
% This version returns a vector of the same length as PRED and
% TRUELAB. Maybe this will be shortened/subsampled in the future.
%
% Some speedups and improvements by G. Bombara <g.bombara@gmail.com>
%
% SEE ALSO
% simpleprc, dd_roc, plotroc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function [f,thr] = simpleroc(netout,truelab)

% Check the size of the netout vector:
if size(netout,2)~=1
	netout = netout';
	if size(netout,2)~=1
		error('Please make netout a column vector');
	end
end

% So all sizes become:
n = size(netout,1);
n_t = sum(truelab);
n_o = n - n_t;

% Sort the network output:
[sout,I] = sort(netout);
% and reorder the true-labels accordingly:
slab = truelab(I);

% Make the index arrays for the target and outlier objects:
slabt = slab;
slabo = slab-1;

% Check if there are identical outputs, and ...
[uout,dummy,J] = unique(sout);
% Change the slab such that the identical values are on top of each other
if size(uout,1)<n
    %warning('dd_tools:NoUniqueROC',...
    %	'There are identical values in NETOUT, the ROC is not uniquely defined.');
    n = size(uout,1);
    slabt2 = zeros(n,1);
    slabo2 = zeros(n,1);
	
    Sidx=1;
    J = [J; -1];
    for j=1:n  % count how many of each of the values occur, and store
        % the approprate number in slabt2 and slabo2:

        Ji=Sidx;
        i = Sidx+1;
        while J(i)==j;
            Ji(end+1) = i;
            i = i+1;
        end
        Sidx=i;
		
        slabt2(j) = sum(slabt(Ji));
        slabo2(j) = sum(slabo(Ji));
    end
	
    slabt = slabt2;
    slabo = slabo2;  

end

% Faster version:
	% number of 1's left from thresh.
	% number of 0's right from thresh.
f = [cumsum(slabt) (n_o+cumsum(slabo))];
% fix the beginning of the curve to (0,n_o)
f = [0 n_o; f];
% fix the end thr of the curve to (1,0)
uout = [uout; uout(end)+10*eps(uout(end))];

% ... and normalize:
f = f./repmat([n_t n_o],n+1,1);

% On request, also the thresholds are returned:
if nargout>1
	thr = uout;
end

end
