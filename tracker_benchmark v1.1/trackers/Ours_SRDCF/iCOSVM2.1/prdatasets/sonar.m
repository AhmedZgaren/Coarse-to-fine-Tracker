%SONAR 208 objects with 60 features in 2 classes
%
%       X = SONAR
%
%This is the data set used by Gorman and Sejnowski in their study of the
%classification of sonar signals using a neural network.  The task is to
%train a network to discriminate between sonar signals bounced off a
%metal cylinder and those bounced off a roughly cylindrical rock.

function x = sonar

prdatasets(mfilename,1,'http://prtools.org/prdatasets/sonar.dat');
user.desc = 'The Sonar dataset from the undocumented databases from UCI. The task is to train a network to discriminate between sonar signals bounced off a metal cylinder and those bounced off a roughly cylindrical rock.';
user.link = 'ftp://ftp.ics.uci.edu/pub/machine-learning-databases/undocumented/connectionist-bench/sonar';
cl = {'mines' 'rocks'};
a = load('sonar.dat');

x = pr_dataset(a(:,1:(end-1)),cl(a(:,end)));
x = setname(x,'Sonar');
x = setuser(x,user);


return
