%MPM_DD Minimax prob. machine.
%
%      W = MPM_DD(X,FRACREJ,SIGMA,LAMBDA,NU,RHO)
%      W = X*MPM_DD([],FRACREJ,SIGMA,LAMBDA,NU,RHO)
%      W = X*MPM_DD(FRACREJ,SIGMA,LAMBDA,NU,RHO)
%
% INPUT
%   X          One-class dataset
%   FRACREJ    Error on the target class (default = 0.1)
%   SIGMA      Width param. in the RBF kernel (default = 1)
%   LAMBDA     Regul. param. for inverse of cov. matrix (default = 1e-6)
%   NU         Regul. param. for moving the mean (default = 0)
%   RHO        Regul. param. for varying the cov.matrix (default = 0)
%
% OUTPUT
%   W          Minimax probability machine
%
% DESCRIPTION
% Computes the minimax probability machine of Lanckriet, using the RBF
% kernel with kernel-width SIGMA and quantile FRACREJ. It tries to find
% the linear classifier that separates the data from the origin,
% rejecting maximally FRACREJ of the target data. Unfortunately, it does
% not really work, and the rejection threshold is actually re-derived
% from the target data.
%
% For this method an inverse of the covariance matrix is required, and
% that might be regularized. This regularisation constant is LAMBDA.
%
% The method can be made a bit more robust by introducing NU>0 and RHO>0
% that allow to move the mean and covariance matrix around a bit. (See
% their paper in NIPS2002)
%
% REFERENCE
%@inproceedings{LanElGJor2002,
%	Author = {Lanckriet, G.R.G. and El Ghaoui, L. and Jordan, M.I.},
%	Booktitle = {Advances in Neural Information Processing Systems},
%	Editor = {S.~Becker and S.~Thrun and K.~Obermayer},
%	Note = {E,},
%	Publisher = {MIT Press: Cambridge, MA},
%	Title = {Robust Novelty Detection with Single-Class MPM},
%	Volume = {15},
%	Year = {2003}}
%
% SEE ALSO
% svdd, lpdd

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

%function W = mpm_dd(a,fracrej,sigm,ep,nu,rho)
function W = mpm_dd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,1,1e-6,0,0);
  
if mapping_task(argin,'definition')       % Define mapping
   W = define_mapping(argin,'untrained','Minimax prob.machine');
    
elseif mapping_task(argin,'training')			% Train a mapping.
  
   [a,fracrej,sigm,ep,nu,rho] = deal(argin{:});
	a = target_class(a);     % only use the target class
	[m,dim] = size(a);

	% train it:
	wk = dd_proxm(a,'r',sigm);
	kalf = sqrt(fracrej/(1-fracrej));
	K = +(a*wk);
	k = mean(K,1);
	L = (K- repmat(k,m,1))/sqrt(m);
	M = L'*L + rho*K;
	if ep>0
		invM = inv(M + ep*eye(m));
	else
		invM = pinv(M);
	end
	tmp = invM*k';
	xi = sqrt(k*tmp);
	gamma = tmp/(xi*(xi-kalf-nu));

	% probably we have to recompute the threshold, because this sucks:
	d = sum(repmat(gamma',m,1).*K,2);
	b = dd_threshold(d,fracrej);
	
	%and save all useful data in a structure:
	W.wk = wk;
	W.gamma = gamma;
	W.threshold = b;  % a threshold should *always* be defined
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),dim,2);
	W = setname(W,'Minimax probability machine');

elseif mapping_task(argin,'trained execution')  %testing

   [a,fracrej] = deal(argin{1:2});
   % Unpack the mapping and dataset:
   W = getdata(fracrej);
   [m,k] = size(a); 

   % Compute the output:
   Kz = +(a*W.wk);
   out = sum(repmat(W.gamma',m,1).*Kz,2);

   newout = [out repmat(W.threshold,m,1)];

   % Fill in the data, keeping all other fields in the dataset intact:
   W = setdat(a,newout,fracrej);
   W = setfeatdom(W,{[0 inf;0 inf] [0 inf;0 inf]});
end
return


