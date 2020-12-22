%HEPATITIS 155 objects with 19 features in 2 classes
%
%             X = HEPATITIS
%
% The hepatitis database from UCI to predict if the patient will live or
% die.
%
%             X = HEPATITIS(VAL);
%
% Per default the missing values are replaced by the mean value of the
% corresponding feature. When you want to do something else, use one of
% the options in missingvalues.m.
function x = hepatitis(val);

prdatasets(mfilename,1,'http://prtools.org/prdatasets/hepatitis.dat');
if nargin<1
	val = 'mean';
end

user.desc = 'The hepatitis database from UCI to predict if the patient will live or die.';
user.link = 'ftp://ftp.ics.uci.edu/pub/machine-learning-databases/hepatitis/';
cl = {'die' 'live'};
fl = {'age' 'sex' 'steroid' 'antivirals' 'fatigue' 'malaise' ...
'anorexia' 'liver big' 'liver firm' 'spleen palpable' 'spiders' ...
'ascites' 'varices' 'bilirubin' 'alk phosphate' 'sgot' 'albumin' ...
'protime' 'histology'};

a = load('hepatitis.dat');
x = pr_dataset(a(:,2:end),cl(a(:,1)));
x = setfeatlab(x,fl);
x = setname(x,'Hepatitis');
[x,msg] = prmissingvalues(x,val);
user.desc = [user.desc msg];
x = setuser(x,user);
