% Define a meta-classifier in which a classifier parameter or
% regularization parameter is optimized using crossvalidation
%
% A typical call may look like this:
%
% >> opts.nrtries = 25;
% >> opts.nrfolds = 5;
% >> opts.test = dd_auc;
% >> w = dd_optregc(a,'kmeans_dd',opts,'fixed',0.1,'lin',1,10)
%
% There is still a significant drawback, in that for some classifiers we
% have to set non-numeric parameters, like the kernel type in the svc:
% svc(a,'p',1,1). I don't know how to solve that yet.


function w = dd_optregc(a,uname,opts,varargin)

% initialize:
if isempty(opts)
	opts.nrtries = 25;
	opts.nrfolds = 5;
	opts.test = testc;
end
if ~isa(uname,'char')
	error('Please make the classifiername a string');
end
% evaluate the parameter settings:
i = 1;
nrpars = 0;
while (i<=length(varargin)-1)
	switch varargin{i}
	case 'fixed'
		minval = [];
		maxval = varargin{i+1};
		logsample  = 0;
		i = i+2;
	case 'lin'
		minval = varargin{i+1};
		maxval = varargin{i+2};
		logsample = 0;
		i = i+3;
	case 'log'
		minval = varargin{i+1};
		maxval = varargin{i+2};
		logsample = 1;
		i = i+3;
	otherwise
		error('I don''t know what to do with %s.',varargin{i});
	end
	nrpars = nrpars + 1;
	parrange{nrpars,1} = minval;
	parrange{nrpars,2} = maxval;
	[minval maxval logsample];
end
% sample parametersettings from this:
df = parrange(:,2)-parrange(:,1);
pars = rand(opts.nrtries,nrpars);
pars = bsxfun(@plus,bsxfun(@times,pars,df'),parrange(:,1)');
for i=1:nrpars
	if parrange(i,3)
		pars(:,i) = exp(pars(:,i));
	end
end
pars = num2cell(pars);

% do a crossval:
err = repmat(NaN,opts.nrtries,opts.nrfolds);
I = opts.nrfolds;
for f=1:opts.nrfolds
	[x,z,I] = dd_crossval(a,I);
	% go through all the settings:
	for i=1:nrpars
		% train classifier
		w = feval(uname,x,

