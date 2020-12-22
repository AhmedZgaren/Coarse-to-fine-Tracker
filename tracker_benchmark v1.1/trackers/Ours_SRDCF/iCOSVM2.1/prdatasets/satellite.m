%SATELLITE Satellite dataset 6435 objects with 36 features in 6 classes
%
%	A = SATELLITE
%
% Load the dataset in A. This is the Satellite dataset from the UCI
% Machine Learning Repository, //www.ics.uci.edu/~mlearn/MLRepository.html.
% As the samples are taken from related neighborhoods, it is better to
% avoid cross-validation. Use the first 4435 samples for training and the
% remaining 2000 for testing.
%
% See also DATASETS, PRDATASETS, SOYBEAN1

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = satellite

prdatasets(mfilename,1);
a = pr_dataset('satellite');
a = setname(a,'Satellite dataset');