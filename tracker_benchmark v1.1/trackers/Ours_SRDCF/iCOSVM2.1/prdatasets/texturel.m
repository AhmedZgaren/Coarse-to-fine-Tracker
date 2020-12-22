%TEXTUREL 128 x 640 objects (pixels) with 7 features in 5 classes
%
%	A = TEXTUREL
%
% Load the dataset in A. These are 5 texture classes each given by 7 
% features which are 7 different filtered versions of 5 different images.
% The objects are the pixels. Filter number 7 is the unity filter, so the
% corresponding featurevalues are the original pixels. The 5 classes are
% stored as 5 horizontally concatenated images. This may be visualized by
% SHOW(A), which shows 7 128*640 images (5*128=640) and the labels.
%
% The dataset TEXTURET deals with a similar texture image given by the same
% texture features but as a composite 256*256 image.
%
% See also DATASETS, PRDATASETS, TEXTURET

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = texturel

prdatasets(mfilename,4);
a = pr_dataset('texturel');
a = setname(a,'Texture Learning Set');
