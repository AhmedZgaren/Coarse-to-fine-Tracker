%TEXTURET 256 x 256 objects (pixels) with 7 features in 5 classes
%
%	A = TEXTURET
%
% Load the dataset in A. These are 5 texture classes each given by 7 
% features which are 7 different filtered versions of 5 different images.
% The objects are the pixels. Filter number 7 is the unity filter, so the
% corresponding featurevalues are the original pixels. The 5 classes are
% stored as 5 a composite 256x256 images. This may be visualized by
% SHOW(A), which shows the 7 images for the 7 features and a label image.
%
% The dataset TEXTUREL deals with a similar texture image given by the same
% texture features.
%
% See also DATASETS, PRDATASETS, TEXTUREL

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = texturet

prdatasets(mfilename,4);
a = pr_dataset('texturet');
a = setname(a,'Texture Test Set');
