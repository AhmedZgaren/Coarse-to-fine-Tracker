%OCMCC One-class and multi-class class sequential classifier
%
%   V = OCMCC(A,WOCC,W)
%   V = A*OCMCC([],WOCC,W)
%   V = A*OCMCC(WOCC,W)
%
% INPUT
%   A      Multi-class dataset
%   WOCC   Untrained one-class classifier (default = gauss_dd)
%   W      Untrained multi-class classifier (default = ldc)
%
% OUTPUT
%   V      One-class and multi-class seq. classifier
%
% DESCRIPTION
% Train on dataset A a one-class classifier WOCC (given by an untrained
% mapping), and on the objects that are classified as 'target'
% subsequently the supervised classifier W (also given as an untrained
% mapping). The mapping V now evaluates new objects by first applying
% the one-class classifier, and then the multi-class classifier. Objects
% that are classified as outlier by the first classifier will be labeled
% 'outlier' when the class labels are text strings, or will be labeled
% 'max(getlablist(A))+1' when the class labels are numeric.
%
% A typical example is:
% >> a = gendatb;
% >> v = ocmcc(a,gauss_dd,ldc);
%
% Objects in A that are labeled 'outlier' will be used in the training of 
% WOCC, but will be ignored in the training of W.
%
% SEE ALSO
% multic, dd_normc, dd_ex14

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands
  
% function W = ocmcc(a,wocc,w)
function W = ocmcc(varargin)

argin = shiftargin(varargin,'prmapping');
argin = setdefaults(argin,[],gauss_dd,ldc);
  
if mapping_task(argin,'definition')       % Define mapping
   W = define_mapping(argin,'untrained','One-class multiclass');
    
elseif mapping_task(argin,'training')			% Train a mapping.
  
   [a,wocc,w] = deal(argin{:});
   % find if there is outlier data present:
   I = strmatch('outlier',getlablist(a));
   if ~isempty(I)
      [outclass,J] = seldat(a,I);
      a(J,:) = [];
      a = remclass(a);
   else
      outclass = [];
   end
	[n,k] = size(a);

	% Train the one-class classifier: all data is used for training:
	wocc_tr = gendatoc(+a,outclass)*wocc;
	% Find the (training, non-outlier) objects that are accepted by this classifier:
	I = istarget(a*wocc_tr*labeld);
	% Train on this data the supervised classifier:
	w_tr = a(I,:)*w;

	%and save all useful data:
	ll = getlablist(a);
	if ischar(ll)
		newlablist = strvcat(ll,'outlier');
	else
		newlablist = [ll; max(ll)+1];
	end
	W.wocc = wocc_tr;
	W.w = w_tr;
	W = prmapping(mfilename,'trained',W,newlablist,k,size(newlablist,1));
	W = setname(W,'One-class multiclass');

else                               %testing

   [a,wocc] = deal(argin{1:2});
	% Extract the data:
	W = getdata(wocc);
	m = size(a,1);
	p = size(wocc,2);
	out = zeros(m,p);

	% First find which objects are outliers:
	I = istarget(a*W.wocc*labeld);
	out(~I,p) = 1;
	% Then classify the accepted data:
	out(I,1:(p-1)) = +(a(I,:)*W.w);

	% Store the output:
	W = setdat(a,out,wocc);
end
return


