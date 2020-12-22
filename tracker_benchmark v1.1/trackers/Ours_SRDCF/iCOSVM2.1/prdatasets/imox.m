%IMOX Handwritten character dataset, 192 objects, 8 features, 4 classes
%
%	A = IMOX
%
% Load the dataset in A. The features are the distances from a bounding box
% to the pixels of a set of handwritten characters 'I', 'M', 'O', and 'X',
% measured form the corners along the diagnoals and from the edge midpoints
% along the horizontal and vertical central axes.
%
% See also DATASETS, PRDATASETS, X80

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = imox;

prdatasets(mfilename,1);
a = pr_dataset('imox');
a = setname(a,'IMOX Dataset');
a = setlablist(a,str2mat('I','M','O','X'));
a = setfeatlab(a,str2mat(...
        'diagonal from top-left', ...
        'vertical from top-center', ...
        'diagonal from top-right', ...
		'horizontal from right-center', ...
		'diagonal from bottom-right', ...
		'vertical from bottom-center', ...
		'diagonal from bottom-left', ...
		'horizontal from left-center'));
