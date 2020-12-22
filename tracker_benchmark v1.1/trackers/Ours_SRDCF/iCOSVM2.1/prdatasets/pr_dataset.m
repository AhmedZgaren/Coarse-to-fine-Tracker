%PR_DATASET  Create DATASET (PRTools4) or PRDATASET (PRTools5)
%
%   A = PR_DATASET(...)

function a = pr_dataset(varargin)

if prversion < 5
  a = dataset(varargin{:});
else
  a = prdataset(varargin{:});
end