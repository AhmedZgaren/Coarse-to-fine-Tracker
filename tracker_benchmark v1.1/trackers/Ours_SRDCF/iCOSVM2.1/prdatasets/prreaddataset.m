function [x,strvals] = prreaddataset(fname,strtype)
%     [X,STRVALS] = PRREADDATASET(FNAME)
%
% Read the dataset from the text file FNAME. It can process categorical
% features, or features for which categories are given in text. A matrix
% X is returned containing the numerical values, or integers. The
% integers point to the entry in STRVALS containing for each
% (categorical) feature its string members.
%
%     X = PRREADDATASET(FNAME,STRTYPE)
%
% The user can supply a vector STRTYPE that indicates for each feature
% if it is numerical (0) or string/categorical (1).
%
%     X = PRREADDATASET(FNAME,STRTYPE,DELIMITER)
%
% For datasets that have a strange delimiter (not comma or space), you
% have to supply it.
if nargin<3
	delimiter = ',';
end
if nargin<2
	strtype = [];
end

% try to open the file
[fid,message] = fopen(fname,'r');
if fid==-1
	disp(message)
	error('I cannot open file %s.',fname);
end
% get the first line:
dline = fgetl(fid);
% check if the delimiter is present:
I = find(dline==delimiter);
if isempty(I)
	delimiter = ' ';
	I = find(dline==delimiter);
	if isempty(I)
		error('Cannot determine the delimiter');
	end
end

% now run over all elements in the line:
I = [0 I length(dline)+1];
w = {};
for i=1:length(I)-1
	w{i} = dline((I(i)+1):(I(i+1)-1));
end

% remove the empty entries:
I = zeros(length(w),1);
for i=1:length(w)
	if isempty(w{i})
		I(i) = 1;
	end
end
w(find(I)) = [];
n = length(w);
x = [];

% see if we have strings or numbers, and put the result in the matrix:
strvals = {};
if isempty(strtype)
	for i=1:n
		num = str2double(w{i});
		if isnan(num)   % the feature is string
			strtype(i) = 1;   % remember that it is a string
			strvals{i}{1} = w{i}; % put it to the collection
			x(1,i) = 1;
		else               % feature is a number, life is simple
			strtype(i) = 0;
			x(1,i) = num;
		end
	end
else
	for i=1:n
		strtype(i) = 1;   % remember that it is a string
		strvals{i}{1} = w{i}; % put it to the collection
		x(1,i) = 1;
	end
end
% now run over the other lines:
nrx = 1;
while 1
	dline = fgetl(fid);
	if ~ischar(dline), break, end  %end of file...

	% now process this line:
	nrx = nrx+1;
	% find delimiters again:
	I = find(dline==delimiter);
	% cut out the words:
	I = [0 I length(dline)+1];
	w = {};
	for i=1:length(I)-1
		w{i} = dline((I(i)+1):(I(i+1)-1));
	end
	% remove the empty entries:
	I = zeros(length(w),1);
	for i=1:length(w)
		if isempty(w{i})
			I(i) = 1;
		end
	end
	w(find(I)) = [];
	% check:
	if length(w)~=n
		error('I cannot find enough values on line %d.',nrx);
	end
	% fill the values in the matrix
	for i=1:n
		if strtype(i)==0 % we have a number:
			tmp = str2double(w{i});
			if isnan(tmp)
				error('It seems that feature %d is not numeric (encountered "%s" on line %d).',i,w{i},nrx);
			end
			x(nrx,i) = tmp;
		else
			% we have to find matching strings for feature i:
			I = strmatch(w{i},strvals{i});
			if ~isempty(I)  % it is found
				x(nrx,i) = I;
			else  % we have to add this entry:
				x(nrx,i) = length(strvals{i})+1;
				strvals{i}{end+1} = w{i};
			end
		end
	end
end

fclose(fid);
