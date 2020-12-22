%BIOMED 194 objects with 5 features in 2 classes
%
%       X = BIOMED;
%
% The biomed dataset to develop screening methods to identify carriers
% of a rare genetic disorder.  Because the disease is rare, there are
% only a few carriers of the disease from whom data are available.
%
%       X = BIOMED(VAL);
%
% Per default the entries with missing values are removed. When you want
% to do something else, use one of the options in missingvalues.m.
% This is the ''biomed' dataset of the StatLib Datasets Archive, see
% http://lib.stat.cmu.edu/datasets/
%
% SEE ALSO 
% DATASETS, MISSINGVALUES

function x = biomed(val)

prdatasets(mfilename,1,'http://prtools.org/prdatasets/biomed.dat');
if nargin<1
	val = 'remove';
end

user.desc = 'The purpose of the analysis is to develop a screening procedure to detect carriers and to describe its effectiveness. ';
user.link = 'http://lib.stat.cmu.edu/datasets/';
cl = {'carrier' 'normal'};
fl = {'age' 'measurement 1' 'measurement 2' 'measurement 3' 'measurement 4'};

a = load('biomed.dat');
x = pr_dataset(a(:,[3 5 6 7 8]),cl(a(:,end)));
x = setfeatlab(x,fl);
x = setname(x,'Biomed');
[x,msg] = prmissingvalues(x,val);
user.desc = [user.desc msg];
x = setuser(x,user);

return
