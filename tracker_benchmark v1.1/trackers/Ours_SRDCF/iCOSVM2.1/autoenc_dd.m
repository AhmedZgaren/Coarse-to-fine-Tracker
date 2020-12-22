%AUTOENC_DD Auto-Encoder data description.
% 
%   W = AUTOENC_DD(A,FRACREJ,N)
%   W = A*AUTOENC_DD([],FRACREJ,N)
%   W = A*AUTOENC_DD(FRACREJ,N)
% 
% INPUT
%   A        Dataset
%   FRACREJ  Fraction of target objects rejected (default = 0.1)
%   N        Number of hidden units (default = 5)
%
% OUTPUT
%   W        AutoEncoder network
%
% DESCRIPTION
% Train an Auto-Encoder network with N hidden units. The network should
% recover the original data A at its output. The difference between the
% network output and the original pattern (in MSE sense) is used as a
% charaterization of the class. The threshold on this measure is optimized
% such that FRACREJ of the training objects are rejected.
% 
% REFERENCE
%@phdthesis{Tax2001a,
%	author = {Tax, D.M.J.},
%	title = {One-class classification},
%	school = {Delft University of Technology},
%	year = {2001},
%	address = {http://www.ph.tn.tudelft.nl/\~{}davidt/thesis.pdf},
%	month = {June}}
%
% SEE ALSO
% datasets, mappings, dd_roc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function W = autoenc_dd(a,fracrej,N)
function W = autoenc_dd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,5);

if mapping_task(argin,'definition')   % empty mapping
   W = define_mapping(argin,'untrained','Auto-encoder');

elseif mapping_task(argin,'training') 

   [a,fracrej,N] = deal(argin{:});
	a = +target_class(a);     % make sure a is an OC dataset
	[nrx,dim] = size(a);

	% set up the parameters for the network:
% old neural network toolbox settings:
%	minmax = [min(a)' max(a)'];
%	net = newff(minmax,[N dim],{'tansig','purelin'},'trainlm');
	net = newff(a',a',N,{'tansig','purelin'},'trainbfg');
	net = init(net);
	net.trainParam.show = inf;
	net.trainParam.showWindow = false;
	net.trainParam.lr = 0.01;
	net.trainParam.goal = 1e-5;
	net = train(net,a',a');

	% obtain the threshold:
	aout = sim(net,a');
	d = sum((a-aout').^2,2);
	W.threshold = dd_threshold(d,1-fracrej);

	%and save all useful data:
	W.net = net;
	W.scale = mean(d);
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),dim,2);
	W = setname(W,'Auto-encoder (N=%d)',N);

elseif mapping_task(argin,'trained execution')  %testing

   [a,fracrej] = deal(argin{1:2});
	W = getdata(fracrej);  % unpack
	m = size(a,1);

	%compute distance:
	out = sim(W.net,+a')';
	out = [sum((a-out).^2,2) repmat(W.threshold,m,1)];

	%store the distance as output:
	W = setdat(a,-out,fracrej);
	W = setfeatdom(W,{[-inf 0; -inf 0] [-inf 0; -inf 0]});
else
   error('Illegal call to autoenc_dd.');
	
end


