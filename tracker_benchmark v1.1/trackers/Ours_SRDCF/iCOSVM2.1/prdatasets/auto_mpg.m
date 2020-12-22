%AUTO_MPG Car/miles-per-gallon, 398 objects, 6 features, 2 classes
%
%	A = AUTO_MPG
%
% Load the dataset in A. This is the 'auto-mpg' dataset of the UCI
% Machine Learning Repository, //www.ics.uci.edu/~mlearn/MLRepository.html
%
% See also DATASETS, PRDATASETS

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

% $Id: auto_mpg.m,v 1.1.1.1 2003/05/16 11:20:35 bob Exp $

function a = auto_mpg;

prdatasets(mfilename,1);
a = pr_dataset('auto_mpg');
a = setname(a,'Car/miles-per-gallon');

a = setlablist(a,str2mat('< 25 mpg ','> 25 mpg'));
a = setfeatlab(a,str2mat(...
        'cylinders: multi-valued discrete', ...
        'displacement: continuous', ...
        'weight: continuous', ...
        'acceleration: continuous', ...
	'model year: multi-valued discrete', ...
	'origin: multi-valued discrete'));
