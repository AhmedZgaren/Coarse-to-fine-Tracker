%MFEAT 2000 objects with 649 features in 10 classes
%
%	A = MFEAT
%
% Load all MFEAT datasets in A. This dataset consists of features of 
% handwritten numerals (`0'--`9') extracted from a collection of Dutch 
% utility maps. Six different feature sets are extracted and stored 
% separately. This command loads them all, in the following order:
%
% MFEAT_FAC, MFEAT_FOU, MFEAT_KAR, MFEAT_MOR, MFEAT_PIX, MFEAT_ZER
%
% The corresponding feature vectors are concatenated.
%
% REFERENCES
% [1] A.K. Jain, R.P.W. Duin, and J. Mao, Statistical Pattern Recognition:
% A Review, IEEE Transactions on Pattern Analysis and Machine Intelligence,
% vol. 22, no. 1, 2000, 4-37.
% [2] R.P.W. Duin and D.M.J. Tax, Experiments with Classifier Combining
% Rules, in: J. Kittler, F. Roli (eds.), Multiple Classifier Systems ,
% LNCS, vol. 1857, Springer, Berlin, 2000, 16-29.
%
% See also DATASETS, PRDATASETS, 

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = mfeat

a = mfeat_fac;
a = [a mfeat_fou];
a = [a mfeat_kar];
a = [a mfeat_mor];
a = [a mfeat_pix];
a = [a mfeat_zer];

a = setname(a,'MFEAT Combined Features');
