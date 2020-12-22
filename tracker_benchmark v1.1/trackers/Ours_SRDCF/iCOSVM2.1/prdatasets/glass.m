%GLASS Glass Identification Dataset, 214 objects,9 features, 4 classes
%
%	A = GLASS
%
% Load the dataset in A. This is a 4-class version of the originally
% 7-class dataset describing the chemical components in several types of
% glasses. The original class 4 is not available and we combined the
% classes 5-7 as 'Other'.
% BuildingFloat:   -- building_windows_float_processed
% BuildingNonFloat:-- building_windows_non_float_processed
% Car:             -- vehicle_windows_float_processed
% Other:           -- containers tableware headlamps
%
% REFERENCE: http://www.ics.uci.edu/~mlearn/databases/glass/glass.names
%
% See also DATASETS, PRDATASETS

% Copyright: R.P.W. Duin, r.p.w.duin@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function a = glass

prdatasets(mfilename,1);
a = pr_dataset('glass');
a = setname(a,'Glass Identification Dataset');
a = setlablist(a,str2mat('BuildingFloat','BuildingNonFloat','Car','Other'));
a = setfeatlab(a,str2mat(...
        'refractive index', ...
        'sodium', ...
        'magnesium', ...
		'aluminium', ...
		'silicon', ...
		'potassium', ...
		'calcium', ...
		'barium', ...
		'iron'));
