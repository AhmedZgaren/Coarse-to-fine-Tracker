% Show the crossvalidation procedure on a kernel classifier
%
% Generate some simple data, split it in training and testing data using
% 10-fold cross-validation, and compare several one-class classifiers on
% it.

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

% Define the classifier
w = libsvc([],0);
% Define the number of cross-validations:
nrbags = 10;
% Generating some OC dataset:
a = oc_set(gendatb([100 60],1.6),'1');
% predefine the kernel
K = a*dd_proxm(a);

% Set up:
auc = zeros(1,nrbags);
I = nrbags;
% Run over the crossvalidation runs:
for i=1:nrbags
	[Kx,Kz,I,Itr] = dd_crossval(K,I);
   % Fix the kernel:
   Kx = Kx(:,Itr);
   Kz = Kz(:,Itr);

	% Train the classifier:
   wtr = Kx*w;
   % evaluate the classifier:
   auc(i,i) = dd_auc(Kz*wtr);

end

% And the results:
mean(auc)
