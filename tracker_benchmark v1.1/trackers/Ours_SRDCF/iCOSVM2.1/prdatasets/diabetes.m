%DIABETES 768 objects with 8 features in 2 classes
%
%        X = DIABETES
%
% Pima-indians diabetes database from National Institute of Diabetes and
% Digestive and Kidney Diseases. This is the 'Pima Indians Diabetes' 
% dataset of the UCI Machine Learning Repository, 
% //www.ics.uci.edu/~mlearn/MLRepository.html

function x = diabetes

prdatasets(mfilename,1,'http://prtools.org/prdatasets/diabetes.dat');
user.desc='The Pima Indians Diabetes Database from UCI.';
user.link = 'ftp://ftp.ics.uci.edu/pub/machine-learning-databases/pima-indians-diabetes/';
cl = {'present' 'absent'};
fl = {'NumPregnancies' 'plasmaGlucose' 'diastolicBloodPr' ...
'tricepsSkinfold' '2hrSerumInsulin' 'BodyMassIndex' ...
'DiabetesPedigreeFn' 'Age'};

a = load('diabetes.dat');
x = pr_dataset(a(:,1:(end-1)),cl(a(:,end)+1));
x = setfeatlab(x,fl);
x = setname(x,'Diabetes');
x = setuser(x,user);

return
