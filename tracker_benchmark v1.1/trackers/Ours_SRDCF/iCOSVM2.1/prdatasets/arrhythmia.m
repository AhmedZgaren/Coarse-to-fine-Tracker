%ARRHYTHMIA 420 objects with 278 features in 12 classes
%
%        X = ARRHYTHMIA(CLASS,VAL)
%
% The aim is to distinguish between the presence and absence of cardiac
% arrhythmia and to classify it in one of the 16 groups. Class 01 refers
% to 'normal' ECG classes 02 to 15 refers to different classes of
% arrhythmia and class 16 refers to the rest of unclassified ones. 
%
%       X = ARRHYTHMIA(VAL);
%
% Per default the entries with missing values are removed. When you want
% to do something else, use one of the options in missingvalues.m.
function x = arrhythmia(val);

prdatasets(mfilename,1,'http://prtools.org/prdatasets/arrhythmia.dat');
if nargin<1
	val = 'remove';
end

user.desc='The Arrhymthmia database from UCI. The aim is to distinguish between the presence and absence of cardiac arrhythmia and to classify it in one of the 16 groups.';
user.link = 'ftp://ftp.ics.uci.edu/pub/machine-learning-databases/arrhythmia';

fl = {'age' 'sex' 'height' 'weight' 'QRS duration' 'P-R interval' ...
'Q-T interval' 'T interval' 'P interval' 'QRS' 'T' 'P' 'QRST' ...
'J' 'heartrate'};
fl1 = {'Q wave width' 'R wave width' 'S wave width' 'R'' wave width' ...
'S'' wave width' 'number of intrinsic deflections' ...
'ragged R wave' 'diphasic derivation of R wave' ...
'ragged P wave' 'diphasic derivation of P wave' ...
'ragged T wave' 'diphasic derivation of T wave'};
fl = [fl strcat('DI-',fl1) strcat('DII-',fl1) strcat('DIII-',fl1) ...
strcat('AVR-',fl1) strcat('AVL-',fl1) strcat('AVF-',fl1) ...
strcat('V1-',fl1) strcat('V2-',fl1) strcat('V3-',fl1) ...
strcat('V4-',fl1) strcat('V5-',fl1) strcat('V6-',fl1)];
fl2 = {'JJ wave ampl' 'Q wave ampl' 'R wave ampl' ...
'S wave ampl' 'R'' wave ampl' 'S'' wave ampl' 'P wave ampl' ...
'T wave ampl' 'QRSA sum' 'QRSTA'};
fl = [fl strcat('DI-',fl2) strcat('DII-',fl2) strcat('DIII-',fl2) ...
strcat('AVR-',fl2) strcat('AVL-',fl2) strcat('AVF-',fl2) ...
strcat('V1-',fl2) strcat('V2-',fl2) strcat('V3-',fl2) ...
strcat('V4-',fl2) strcat('V5-',fl2) strcat('V6-',fl2)];

a = load('arrhythmia.dat');
x = pr_dataset(a(:,1:(end-1)),a(:,end));
x = setfeatlab(x,fl);
x = setname(x,'Arrhythmia normal');
x(:,14) = [];  % there are so many missing values, that I just remove this
[x,msg] = prmissingvalues(x,val);
user.desc = [user.desc msg];
x = setuser(x,user);
x = setlablist(x);
return
