%MFEAT_FOU 2000 objects with 76 features in 10 classes
%
%	A = MFEAT_FOU
%
% Load the dataset in A. These are the Fourier features.
%
% See also DATASETS, PRDATASETS, MFEAT

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = mfeat_fou

prdatasets(mfilename,1);
a = pr_dataset('mfeat_fou');
a = setname(a,'MFEAT Fourier Features');
