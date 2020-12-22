%KIMIA 216 objects given by 32 x 32 pixels (features) in 18 classes
%
% 	A = KIMIA
%
% There are 216 binary images, 18 classes with 12 objects each.
% The original image sizes of 146 x 156 have been reduced to 32 x 32.
% The full images are still available as KIMIA_IMAGES in PRDATAFILES
% The images are taken from:
% http://www.lems.brown.edu/vision/researchAreas/SIID/
%
% See also DATASETS, PRDATASETS, PRDATAFILES, PRDATAFILES/KIMIA_IMAGES

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = kimia;

prdatasets(mfilename,1);
labs = {'bone' 'glass' 'heart' 'misk' 'bird' 'brick' 'camel' ...
	 'car' 'children' 'van' 'elephant' 'head' 'fork' 'fountain' ...
 	 'hammer' 'key' 'ray' 'turtle'};
a = pr_dataset('kimia');
a = setlablist(a,labs);
a = setname(a,'Kimia Dataset');

