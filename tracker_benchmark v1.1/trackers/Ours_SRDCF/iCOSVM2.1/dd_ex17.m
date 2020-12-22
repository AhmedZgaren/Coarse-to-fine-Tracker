% Show the crossvalidation procedure
%
% Generate some simple data, split it in training and testing data using
% 10-fold cross-validation, and compare several one-class classifiers on
% it.

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

% Standard parameter:
frac = 0.1;
reg = 1e-2;
% Define the classifiers
%optimcon=load(filename);
% w = {incsvc([],'e',5,1)
%      inccosvc([],'cov',5,1)
%      %mog_dd([],frac,5,'full',reg,200)*dd_normc
% 	  incsvdd([],frac,'e',5)*dd_normc
% 	  };
% nrcl = length(w);
% Define the number of cross-validations:
nrbags = 10;
% Generating some OC dataset:
a = oc_set(gendatb([100 60],1.6),'1');

% Set up:
auc = zeros(3,10);
I = nrbags;
    w = {incsvc([],'e',5,1)
     inccosvc([],'cov',20,1)
     %mog_dd([],frac,5,'full',reg,200)*dd_normc
	  incsvdd([],frac,'e',5)*dd_normc
	  };
nrcl = length(w);
% Run over the crossvalidation runs:
for i=1:nrbags
	[x,z,I] = dd_crossval(a,I);

	% Train three classifiers:
	for j=1:3
    		wtr = x*w{j};
		% evaluate the classifiers:
        auc(j,i) = dd_auc(z*wtr*dd_roc);
	end

end

% And the results:
for i=1:nrcl
   cname = getname(w{i});
	fprintf('%35s : %5.3f (%5.3f)\n',cname,mean(auc(i,:),2),std(auc(i,:),[],2));
end
