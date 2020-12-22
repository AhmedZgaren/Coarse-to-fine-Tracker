%HEART 303 objects with 13 features in 2 classes
%
%       X = HEART;
%
% Heart-Cleveland dataset from the Hungarian Institute of Cardiology.
% Budapest: Andras Janosi, M.D.
%
%       X = HEART(VAL);
%
% Per default the missing values are replaced by -1. When you want to
% do something else, use one of the options in missingvalues.m.
function x = heart(val)

prdatasets(mfilename,1,'http://prtools.org/prdatasets/heart.dat');
if nargin<1
	val = 'remove';
end

user.desc='The Cleveland database from the Heart Disease Databases from UCI.  The class disease-presence is used as target class. ';
user.link = 'ftp://ftp.ics.uci.edu/pub/machine-learning-databases/heart-cleveland/';
cl = {'absent' 'present'};
fl = {'age' 'sex' 'cp' 'trestbps' 'chol' 'fbs' 'restecg' ...
	'thalach' 'exang' 'oldpeak' 'slope' 'ca' 'thal'};
fd = {[0 inf; 0 inf] [0 1] [1 2 3 4] [0 inf; 0 inf] [0 inf; 0 inf]...
[0 1] [0 1 2] [0 inf; 0 inf] [0 1] [0 inf; 0 inf] [1 2 3] [-1 0 1 2 3] [3 6 7]};

a = load('heart.dat');
lab = (a(:,end)>0);
x = pr_dataset(a(:,1:(end-1)),cl(lab+1));
x = setfeatlab(x,fl);
x = setname(x,'Heart Cleveland');
x = setfeatdom(x,fd);
[x,msg] = prmissingvalues(x,val);
user.desc = [user.desc msg];
x = setuser(x,user);

return
