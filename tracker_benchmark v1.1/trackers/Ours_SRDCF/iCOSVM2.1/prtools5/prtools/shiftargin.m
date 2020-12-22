%SHIFTARGIN Shift input arguments conditionally
%
%  ARGOUT = SHIFTARGIN(ARGIN,CONDITION)
%
% INPUT
%   ARGIN      Cell array with function input arguments (VARARGIN)
%   CONDITION  Type of first argument ('double','char','prmapping')
%
% OUTPUT
%   ARGOUT     ARGIN if condition is false, {[],ARGIN{:}) if true

function argout = shiftargin(argin,type)

if isempty(argin)
  argout = argin;
  return
end

shift = false;
if iscell(type)
  for j=1:numel(type)
    if isa(argin{1},type{j})
      shift = true;
    end
  end
elseif isa(argin{1},type)
  shift = true;
end

if shift
  argout = {[],argin{:}};
else
  argout = argin;
end