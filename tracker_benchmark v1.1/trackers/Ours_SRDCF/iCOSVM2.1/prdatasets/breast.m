%BREAST 699 objects with 9 features in 2 classes
%
%       X = BREAST;
%
% Breast cancer Wisconsin dataset obtained from the University of Wisconsin
% Hospitals, Madison from Dr. William H. Wolberg.
%
% REFERENCE
% O. L. Mangasarian and W. H. Wolberg: "Cancer diagnosis via linear 
% programming", SIAM News, Volume 23, Number 5, September 1990, pp 1 & 18.
%
%       X = BREAST(VAL);
%
% Per default the missing values are replaced by -1. When you want to
% do something else, use one of the options in missingvalues.m.
function x = breast(val)

prdatasets(mfilename,1,'http://prtools.org/prdatasets/breastorg.dat');
if nargin<1
	val = -1;
end

user.desc='The original database of the Wisconsin Breast Cancer Databases from UCI, containing 699 instances, collected between 1989 and 1991. ';
user.link = 'ftp://ftp.ics.uci.edu/pub/machine-learning-databases/breast-cancer-wisconsin/';
cl = {'benign' 'malignant'};
fl = {'Clump Thickness' 'Uniformity of Cell Size' ...
'Uniformity of Cell Shape' 'Marginal Adhesion' ...
'Single Epithelial Cell Size' 'Bare Nuclei' 'Bland Chromatin' ...
'Normal Nucleoli' 'Mitoses'};

a = load('breastorg.dat');
J = find(a==-1);
a(J) = NaN;
nlab = a(:,end)/2;   % the labels for the classes are (2,4), very strange
x = pr_dataset(a(:,2:(end-1)), cl(nlab) );
x = setfeatlab(x,fl);
x = setname(x,'Breast Wisconsin');
[x,msg] = prmissingvalues(x,val);
user.desc = [user.desc msg];
x = setuser(x,user);

return
