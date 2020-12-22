function [f,thr] = simpleprc(netout,truelab)
%SIMPLEPRC Basic precision-recall characteristic curve
%
%      F = SIMPLEPRC(NETOUT,TRUELAB)
%
% Compute the PR curve for the network output NETOUT, given the true
% labels TRUELAB. TRUELAB should contain 0-1 values, where 0 is the
% correct output if (netout < some_threshold) and 1 when the
% (netout > some_threshold). Output F contains [Prec Rec].
%
% This version returns a vector of the same length as NETOUT and
% TRUELAB. Maybe this will be shortened/subsampled in the future.
%
% Some speedups and improvements by G. Bombara <g.bombara@gmail.com>
%
% See also: dd_roc, plotroc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

% Check the size of the netout vector
if size(netout,2)~=1
	netout = netout';
	if size(netout,2)~=1
		error('Please make netout a column vector.');
	end
end

% Collect all sizes:
n = size(netout,1);
n_t = sum(truelab);

% Sort the netout:
[sout,I] = sort(-netout);
% and therefore also reorder the true labels accordingly
slab = truelab(I);

% Make the index arrays for the target and outlier objects:
slabt = slab;
slabo = ~slab;

% Check if there are identical outputs, and ...
[uout,~,J] = unique(sout);
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

%slabt   1110011101 0001001000000
%slabo   0001100010 1110110111111
%    + <-----------+-------------
%TP=     111  111 1
%FP=        11   1
%FN=                   1  1
%
% precision = TP/(TP+FP)
% recall =    TP/(TP+FN)

cslabt = cumsum(slabt);
cslabo = cumsum(slabo);

prec = cslabt./(cslabt+cslabo);
rec = cslabt/n_t;
f = [prec rec];

% fix beginning of the curve
uout = [uout(1)-10*eps(uout(1)); uout];
f = [NaN 0 ; f];

% reorder and flip sign of vectors to have a consistent output with simpleroc
f = flipud(f);
uout = flipud(-uout);

% On request, also the thresholds are returned:
if nargout>1
	thr = uout;
end

end

