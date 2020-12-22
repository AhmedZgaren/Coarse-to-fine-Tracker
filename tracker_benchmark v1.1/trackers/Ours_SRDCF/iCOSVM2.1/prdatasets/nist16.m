%NIST16 2000 normalised digits given by 16x16 pixels (features) in 10 classes
%
%	A = NIST16
%
% Load the dataset in A. This is a subset of the NIST handprinted digits,
% normalised and sampled on 16x16 pixels.
%
% See also DATASETS, PRDATASETS

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = nist16

prdatasets(mfilename,1);
a = pr_dataset('nist16');
a = setname(a,'NIST16 Normalised Digits');

