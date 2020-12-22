%IONOSPHERE 351 objects, 34 features, 2 classes
%           Johns Hopkins University ionosphere dataset
%
%	A = IONOSPHERE
%	A = IONOSPHERE(M,N)
%
% Load the dataset in A. This is the Johns Hopkins University ionosphere
% dataset from the UCI Machine Learning Repository, 
% //www.ics.uci.edu/~mlearn/MLRepository.html
%
% See also DATASETS, PRDATASETS

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = ionosphere

prdatasets(mfilename,1);
% the stats toolbox has a ionosphere.mat file too, avoid it
pp = fileparts(which(mfilename));
a = pr_dataset(fullfile(pp,'ionosphere'));
a = setname(a,'Ionosphere Dataset');
a = setlablist(a,{'good','bad'});

