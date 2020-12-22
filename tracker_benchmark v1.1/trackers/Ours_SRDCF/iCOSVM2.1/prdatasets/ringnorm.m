%RINGNORM 7400 objects with 20 features in 2 classes
%
%	A = RINGNORM
%
% Load the dataset in A. This is an implementation of Leo Breimans ringnorm
% example. It is taken from:
% http://www.cs.toronto.edu/~delve/data/
%
% REFERENCE
% Breiman L. Bias, variance and arcing classifiers. Tech. Report 460, 
% Statistics Department. University of California. April 1996. 
%
% See also DATASETS, PRDATASETS, TWONORM

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = ringnorm

prdatasets(mfilename,1);
a = pr_dataset('ringnorm');
a = setname(a,'Ringnorm Data');

