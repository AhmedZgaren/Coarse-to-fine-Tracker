%DD_DELTA_AIC compute the difference in AIC for MoG
%
%       E = DD_DELTA_AIC(X,W)
%
% INPUT
%   X     Dataset
%   W     Mixture of Gaussians model
%
% Compute the (difference in) Akaike Information Criterion of a
% trained model w on data x. In this version we compute:
%
%     e = -2 LL + 2 #param
%
% where LL is the loglikelihood on the set x, and *not* the deviance
% between two models. In order to make it true AIC, you have to
% subtract the LL for the saturated model.
%
% ALSO SEE
% dd_aic, dd_error, dd_roc, dd_auc

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function e = dd_delta_aic(x,w)

% first check if the order of input parameters is correct:
if isdataset(w) && ismapping(w)
   % swap!
   tmp = x; x = w; w = tmp;
end

[W,labl,map,d] = prmapping(w);
if ~is_occ(w)
	error('DD_AIC: this AIC is only defined for one-class classifiers');
end

p = x*w; p = +p(:,1);

switch map
case 'gauss_dd'
	 nrparam = d + d*(d+1)/2;  %mean and cov.matrix

 case 'mog_dd'
	 c = size(W.m,1);
	 [n,d] = size(x);
	 covtype = ndims(W.c);
	 if ((covtype==2)&&(size(W.c,2)==1)), covtype = 1; end

		 % the number of parameters
		 % for all covariance versions, the priors and the means are the same:
		 nrparam = c + c*d;
		 switch covtype
		 case 1
			 nrparam = nrparam + c;
		case 2
			nrparam = nrparam + c*d;
		case 3
			nrparam = nrparam + c*d*(d+1)/2;
		otherwise
			error('Type of covariance matrix not recognized')
	 end
 otherwise
	 error('AIC cannot be computed for this mapping!');
end

% For the loglikelihood:
e = -2*sum(log(p)) + 2*nrparam;
%strangely this one does not seem to work!:
%e = -2*sum(log(sum(p,2))) + 2*nrparam/n;

return
