%IM_STAT Computation of some image statistics
%
%	B = IM_STAT(A,STAT)
%	B = A*IM_STAT(STAT)
%
% INPUT
%   A        Dataset with object images dataset (possibly multi-band)
%   STAT     String cell array or series of statistics
%
% OUTPUT
%   B        Dataset with statistics replacing images (possibly multi-band)
%
% DESCRIPTION
% For all images in the dataset A the statistics as defined in the 
% cell array STAT are computed. The following statistics are supported:
% (order is arbitrary)
%
%	'mean',  'row_mean',  'col_mean',  'std', 'row_std','col_std',
%	'min',   'row_min',   'col_min,    'max', 'row_max','col_max,
%	'median','row_median','col_median','size','sum'
%
% Default STAT = {'mean','var','min','max','size'}
%
% SEE ALSO
% DATASETS, DATAFILES

% Copyright: R.P.W. Duin, r.p.w.duin@37steps.com
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function b = im_stat(varargin)

  if nargin == 0, varargin = {[]}; end
  if ischar(varargin{1}) || iscell(varargin{1}), varargin = {[] varargin{:}}; end
  if isempty(varargin{1})
    b = prmapping(mfilename,'fixed',varargin(2:end));
    b = setname(b,'Image statistics');
    return
  end

  % now we have: im_sata(data,command)
  % data might be dataset, datafile, cell array, double, structure array
  argin = setdefaults(varargin,[],{'mean','std','min','max','size'});
  a = argin{1};
  stats = argin(2:end);
	if iscell(stats{1})
		stats = stats{1};
  end
  
	if isa(a,'prdataset') % allows datafiles too
		isobjim(a);
		outsize = [size(stats,1)*getfeatsize(a,3)];
    b = filtim(a,mfilename,{stats},outsize);
  elseif isa(a,'numeric') || isa(a,'logical') || isa(a,'dip_image') % here we have a single image
		a = double(a);
		n = length(stats);
		b = [];
		for i=1:n
			switch stats{i}
				case 'mean'
				b = [b mean(a(:))];
			case 'std'
				b = [b std(a(:))];
			case 'min'
				b = [b min(a(:))];
			case 'max'
				b = [b max(a(:))];
			case 'median'
				b = [b median(a(:))];
			case 'row_mean'
				b = [b mean(a,2)'];
			case 'row_std'
				b = [b std(a,2)'];
			case 'row_min'
				b = [b min(a,[],2)'];
			case 'row_max'
				b = [b max(a,[],2)'];
			case 'row_median'
				b = [b median(a,2)'];
			case 'col_mean'
				b = [b mean(a,1)];
			case 'col_std'
				b = [b std(a,1)];
			case 'col_min'
				b = [b min(a,[],1)];
			case 'col_max'
				b = [b max(a,[],1)];
			case 'col_median'
				b = [b median(a,1)];
			case 'size'
				b = [b size(a)];
			case 'sum'
				b = [b sum(a(:))];
			otherwise
				error('Desired statistics not supported')
			end
		end
	end
return