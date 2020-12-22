%PRDATASETS: PRTools5 Pattern Recognition Datasets
% Version 2.0 6-Aug-2013
%
%The following datasets can be loaded by commands like A = DATASET_NAME.
%Most datasets have options to select classes or objects.
%(m: #samples, k: #features  c:#classes)
%
% name        m     k   c  description
%----------------------------------------------------------
%x80          45    8   3  radial distances of characters
%arrhythmia  420  278   2  presence or absence of cardia arrhythmia
%auto_mpg*	 398    6   2  Car/miles-per-gallon
%malaysia    291    8  20  segment features in utility symbols
%biomed      194    5   2
%breast*     683    9   2  Wisconsion breast cancer dataset
%cbands    12000   30  24  chromosome banding patterns
%chromo     1143    8  24  chromosome blob features
%diabetes*   768    8   2  Pima Indians Diabetes Database
%ecoli*      272    7   3  protein localisation sites
%glass       214    9   4  glass types from chemical components
%heart*      297   13   2  heart disease dataset
%imox        192    8   4  radial distances of characters
%ionosphere* 351   34   2  
%iris        150    4   3  Fisher's Iris dataset
%liver*      345    6   2  liver disorder
%satellite* 6435   36   6
%sonar*      208   60   2  rock / metal sonar features
%soybean1*   266   35  19  large Soybeans
%soybean2*   136   35   4  small Soybeans
%spirals     194    2   2  spirals
%twonorm    7400   20   2  Leo Breiman's two normal example.
%ringnorm   7400   20   2  Leo Breiman's ringnorm example.
%wine*       178   13   3  wine recognition
%mfeat-fac  2000  216  10  Face features in digits dataset
%mfeat-fou  2000   76  10  Fourier features in digits dataset
%mfeat-kar  2000   64  10  Karhunen Loeve features in digits dataset
%mfeat-pix  2000  240  10  Pixel features in digits dataset
%mfeat-zer  2000   53  10  Zernike moments in digits dataset
%mfeat-mor  2000    6  10  Morphological features in digits dataset
%
%   Multi-band images (pixels are objects, bands are features)
%
%emim31   128*128   8   1  8-band EM image
%emim32   128*128   8   1  8-band EM image
%emim33   128*128   8   1  8-band EM image
%emim34   128*128   8   1  8-band EM image
%emim37   256*256   8   1  8-band EM image
%lena     256*256   3   1  full-color image
%texturel 5*128*128 7   5  texture features for 5 different texture images
%texturet 256*256   7   5  composite texture image
%
%    Image datasets (pixels are features, images are objects)
%
%kimia     216   64*64 18  resampled (64*64) Kimia dataset of silhouettes
%nist32   5000   32*32 10  Resampled Nist digits
%nist16   2000   16*16 10  Normalized Nist digits

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5038, 2600 GA Delft, The Netherlands
