%MFEAT_PIX 2000 objects with 240 features in 10 classes
%
%	A = MFEAT_PIX
%
% Load the dataset in A. These are averages of groups of 2x3 pixels.
% The original images can be roughly reconstructed from them.
%
% See also DATASETS, PRDATASETS, MFEAT

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = mfeat_pix

prdatasets(mfilename,1);
a = pr_dataset('mfeat_pix');
a = setname(a,'MFEAT Pixel Features');
