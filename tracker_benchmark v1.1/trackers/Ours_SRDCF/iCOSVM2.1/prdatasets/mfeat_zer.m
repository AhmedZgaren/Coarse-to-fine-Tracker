%MFEAT_ZER 2000 objects with 47 features in 10 classes
%
%	A = MFEAT_ZER
%
% Load the dataset in A. These are the Zernike moments.
%
% See also DATASETS, PRDATASETS, MFEAT

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = mfeat_zer

prdatasets(mfilename,1);
a = pr_dataset('mfeat_zer');
a = setname(a,'MFEAT Zernike Moments');
