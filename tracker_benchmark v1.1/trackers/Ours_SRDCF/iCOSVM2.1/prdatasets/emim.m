%EMIM Load 8-band electron microscope images 
%
%	A = EMIM(N)
%
% Return image N as the dataset A. In this dataset the pixels of an 
% electron-microscope image are represented as objects with 8 features.
% These represent the bands of the EM image. There are 5 images available,
% encoded by N = 31, 32, 33, 34 and 37. Default is N = 31. The first four
% images have size 128x128. The image with N=37 has size 256x256. 
%
% The segmentation of such images has been studied in:
% P. Paclik, R.P.W. Duin, G.M.P. van Kempen, and R. Kohlus, Segmentation of
% multi-spectral images using the combined classifier approach, Image and
% Vision Computing Journal, vol. 21, no. 6, 2003, 473-482.
%
% See also DATASETS, PRDATASETS

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5038, 2600 GA Delft, The Netherlands

function a = emim(n)

if nargin ==0, n=31; end

if all([31,32,33,34,37]~=n)
	error('Images should be coded by N = 31, 32, 33, 34 or 37')
end

name = ['emim' num2str(n)];
prdatasets(mfilename,1,['http://prtools.org/prdatasets/' name '.mat']);
a = pr_dataset(name);
a = setname(a,['EM' num2str(n) ' Image Delft']);

