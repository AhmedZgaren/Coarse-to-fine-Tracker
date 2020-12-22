%X80 Handwritten character dataset, 45 objects with 8 features in 3 classes
%
%	A = X80
%
% DESCRIPTION
% Load the dataset in A. This is the 80X dataset, having 3 classes.
% The 8 features are the distances from a bounding box to the 
% pixels of a set of handwritten characters 'X', '8' and '0', measured from
% the corners along the diagonals and from the edge midpoints along the 
% horizontal and vertical central axes.
%
% REFERENCES
% 1. R. Dubes and A.K. Jain, Clustering techniques: The user's dilemma,
% Pattern Recognition, Volume 8, Issue 4, October 1976, Pages 247-260.
% 2. A.K. Jain, R.C. Dubes, C.C. Chen, Bootstrap Techniques for Error Estimation
% IEEE Trans. Pattern Anal. and Mach. Intel., 9(5), pp. 628-633, 1987.
%
% See also DATASETS, PRDATASETS, IMOX

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = x80;

prdatasets('80x',1);
a = pr_dataset('80x');
a = setname(a,'80X Dataset');
a = setlablist(a,str2mat('8','0','X'));
a = setfeatlab(a,str2mat(...
        'diagonal from top-left', ...
        'vertical from top-center', ...
        'diagonal from top-right', ...
		'horizontal from right-center', ...
		'diagonal from bottom-right', ...
		'vertical from bottom-center', ...
		'diagonal from bottom-left', ...
		'horizontal from left-center'));
