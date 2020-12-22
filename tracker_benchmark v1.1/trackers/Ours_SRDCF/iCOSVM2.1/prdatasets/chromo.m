%CHROMO 1143 objects with 8 features in 24 classes
%
%	A = CHROMO
%
% Load the dataset in A. The features are blob characteristics of
% thresholded chromosomes. This technique is outdated.

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = chromo

prdatasets(mfilename,1);
a = pr_dataset('chromo');
a = setname(a,'Chromosome Features');
