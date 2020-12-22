%MFEAT_FAC 2000 objects with 216 features in 10 classes
%
%	A = MFEAT_FAC
%
% Load the dataset in A. These are the face features (projection on
% horizontal and vertical axes).
%
% See also DATASETS, PRDATASETS, MFEAT

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = mfeat_fac

prdatasets(mfilename,1);
a = pr_dataset('mfeat_fac');
a = setname(a,'MFEAT Face Features');
