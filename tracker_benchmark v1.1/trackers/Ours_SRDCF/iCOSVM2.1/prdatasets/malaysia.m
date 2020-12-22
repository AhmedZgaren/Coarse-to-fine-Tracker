%MALAYSIA 291 objects with 8 features in 20 classes
%
%	A = MALAYSIA
%
% Load the dataset in A. This dataset concerns simple measurements on
% segments of utility symbols.
%
% See also DATASETS, PRDATASETS

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5038, 2600 GA Delft, The Netherlands

function a = malaysia;

prdatasets(mfilename,1);
a = pr_dataset('malaysia');
a = setname(a,'Malaysia Data');
