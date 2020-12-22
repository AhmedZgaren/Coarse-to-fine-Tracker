%MFEAT_ALL Load all MFEAT datasets in a cell array
%
%	A = MFEAT
%
% This command loads all MFEAT datasets in the following order:
%
% MFEAT_FAC, MFEAT_FOU, MFEAT_KAR, MFEAT_MOR, MFEAT_PIX, MFEAT_ZER.
%
% A = returned as a cell array of datasets.
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

function a = mfeat_all

a = cell(1,6);
a{1} = mfeat_fac;
a{2} = mfeat_fou;
a{3} = mfeat_kar;
a{4} = mfeat_mor;
a{5} = mfeat_pix;
a{6} = mfeat_zer;