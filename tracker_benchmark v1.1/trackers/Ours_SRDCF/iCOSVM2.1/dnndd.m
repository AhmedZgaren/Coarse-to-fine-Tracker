%DNNDD Distance nearest neighbour data description method.
% 
%       W = DNNDD(D,FRACREJ)
%
% INPUT
%   D        Distance dataset
%   FRACREJ  Error on target class (default = 0.1)
% 
% OUTPUT
%   W        Distance NN data description
%
% DESCRIPTION
% Calculates the Nearest neighbour data description on distance data D.
% Training only consists of the computation of the resemblance of all
% training objects to the training data using Leave-One-Out.
% 
% SEE ALSO
% dknndd, dkcenter_dd, nndd

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
  
%function W = dnndd(D,fracrej)
function W = dnndd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1);

if mapping_task(argin,'definition')
   W = define_mapping(argin,'untrained','Distance NN description');

elseif mapping_task(argin,'training')
   [D,fracrej] = deal(argin{:});
	[m,k] = size(D);

	% Apply leave-one-out on the training set:
	D(1:m+1:end) = inf;         % set diagonal to inf.
	fit = zeros(m,1);
	for i=1:m
		tmpD = D;
		[minD minI] = min(tmpD(i,:));  % dist. from z to 1NN in A
		tmpD(i,minI) = inf;
		intdist = min(tmpD(:,minI));   % dist. from 1NN to NN(1NN)
		fit(i) = minD./intdist;
	end
	% Now we can obtain the threshold:
	thresh = dd_threshold(fit,1-fracrej);
	% and save all useful data:
	W.threshold = thresh;
	W.fit = fit;
	W.D = min(D,[],2);
	W.scale = mean(fit);
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	W = setname(W,'Nearest neighbour data description');

elseif mapping_task(argin,'trained execution') %testing

   [D,fracrej] = deal(argin{:});
	W = getdata(fracrej);  % unpack
	m = size(D,1);

	%compute:
	[mindist I] = min(D,[],2); % find the closest dist.
	out = [mindist./(W.D(I)) repmat(W.threshold,m,1)];

	% Store the distance as output:
	W = setdat(D,-out,fracrej);
	W = setfeatdom(W,{[-inf 0;-inf 0] [-inf 0;-inf 0]});
else
   error('Illegal call to dnndd.');
end
return
