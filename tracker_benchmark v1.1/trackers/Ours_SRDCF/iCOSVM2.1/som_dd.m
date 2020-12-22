%SOM_DD Self-Organizing Map data description
%
%           W =  SOM_DD(X,FRACREJ,K,NRRUNS,ETA,H)
%           W =  X*SOM_DD([],FRACREJ,K,NRRUNS,ETA,H)
%           W =  X*SOM_DD(FRACREJ,K,NRRUNS,ETA,H)
%
% INPUT
%   X         One-class dataset
%   FRACREJ   Error on the target class (default = 0.1)
%   K         Size of the map (default = [5 5])
%   NRRUNS    Number of iterations (default = [20 40 40])
%   ETA       Learning rate (default = [0.5 0.3 0.1])
%   H         Width parameter neighborhood function
%             (default = [0.6 0.2 0.01])
%
% OUTPUT
%   W         Self-organising map
%
% DESCRIPTION
% Train a 2D SOM on dataset X. In K the size of the map is defined. The
% map can maximally be 2D. When K contains just a single value, it is
% assumed that a 1D map should be trained.
%
% For further features of SOM_DD, see som.m (for instance, on the parameters
% NRRUNS, ETA and H).
%
% SEE ALSO
% som, plotsom, pca_dd, kmeans_dd

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function W = som_dd(x,fracrej,k,nrruns,eta,h)
function W = som_dd(varargin)

argin = shiftargin(varargin,'definition');
argin = setdefaults(argin,[],0.1,[5 5],[20 40 40],[0.5 0.3 0.1],[0.6 0.2 0.01]);

if mapping_task(argin,'definition')
   W = define_mapping(argin,'untrained','SOMdd');

elseif mapping_task(argin,'training')

   [x,fracrej,k,nrruns,eta,h] = deal(argin{:});
	x = target_class(x);     % only use the target class
	[nrx,dim] = size(x);

	% Now, all the work is being done by som.m:
	w = som(x,k,nrruns,eta,h);
	w = getdata(w);
	% Now map the training data:
	mD = min(sqeucldistm(+x,w.neurons),[],2);
	thresh = dd_threshold(mD,1-fracrej);

	% And save all useful data:
	V.threshold = thresh;  % a threshold should always be defined
	V.k = w.k;  %(only for plotting...)
	V.neurons = w.neurons;
	W = prmapping(mfilename,'trained',V,str2mat('target','outlier'),dim,2);
	W = setname(W,'Self-organising Map data description');
elseif mapping_task(argin,'trained execution')
    
   [x,fracrej] = deal(argin{1:2});
	W = getdata(fracrej); %unpack
	m = size(x,1); 

	% compute the distance to the nearest neuron in the map:
	mD = min(sqeucldistm(+x,W.neurons),[],2);
	newout = [mD repmat(W.threshold,m,1)];

	% Store the distance as output:
	W = setdat(x,-newout,fracrej);
	W = setfeatdom(W,{[-inf 0; -inf 0] [-inf 0; -inf 0]});
else
   error('Illegal call to som_dd');
end

return


