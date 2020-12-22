%CBANDS 12000 objects with 30 features in 24 classes
%
%	A = CBANDS
%
% Load the dataset in A. These are resampled human chromosome banding
% profiles, such that each chromosome is represented by 30 samples. Note
% that these techniques are almost not used anymore.
%
% See also DATASETS, PRDATASETS

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = cbands

prdatasets(mfilename,1);
a = pr_dataset('cbands');
a = setname(a,'Chromosome Bands');
