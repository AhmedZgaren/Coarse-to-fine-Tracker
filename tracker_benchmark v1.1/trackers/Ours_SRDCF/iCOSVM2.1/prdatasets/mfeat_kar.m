%MFEAT_KAR 2000 objects with 64 features in 10 classes
%
%	A = MFEAT_KAR
%
% Load the dataset in A. These are the Karhunen-Loeve moments.
%
% See also DATASETS, PRDATASETS, MFEAT

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = mfeat_kar

prdatasets(mfilename,1);
a = pr_dataset('mfeat_kar');
a = setname(a,'MFEAT KL Features');
