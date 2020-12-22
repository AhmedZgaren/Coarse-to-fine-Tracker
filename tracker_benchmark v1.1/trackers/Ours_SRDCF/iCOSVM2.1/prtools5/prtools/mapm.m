%MAPM Mapping to execute arbitray Matlab function on dataset
%
%    [B,OUT] = MAPM(A,COMMAND,PAR1,PAR2,....)
%    [B,OUT] = A*MAPM(COMMAND,PAR1,PAR2,....)
%
% INPUT
%    A               Dataset or datafile or double
%    COMMAND         String with function name
%    {PAR1,...}      Cell array with optional parameters for COMMAND
%
% OUTPUT
%    B               Resulting dataset, datafile or double array
%    OUT             (only for datasets or doubles) possible additional
%                    outputs
%
% DESCRIPTION
% On the data in A, the double array A the following command is executed
%
%    [B,OUT] = COMMAND(DATA,PAR1,PAR2,....)
%
% If A is a dataset then B is converted to a similar dataset. If A is a
% cell array, then results are combined into a cell array as well.
%
% This command differs from the similar command FILTM which operates object
% by object (row by row). The COMMAND in MAPM operates on the entire data
% matrix.
%
% EXAMPLES
% argmin = mapm('min')*out2; 
% % A*argmin returns for every column the row indices of the minimum
% % A'*argmin returns for every row the column indices of its minimum
% 
% nexpm = mapm('uminus')*mapm('exp');
% % A*nexpm returns exp(-A), useful incombination with other commands
%
% SEE ALSO
% DATASETS, DATAFILES, IM2OBJ, DATA2IM, FILTM, FILTIM, OUT2

% Copyright: R.P.W. Duin, r.p.w.duin@37steps.com
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

function [b,varargout] = mapm(varargin)

  if nargin == 0
    error('No command found')
  end
  varargin = shiftargin(varargin,'char');
  if isempty(varargin{1})
    b = prmapping(mfilename,'fixed_cell',varargin(2:end));
    b = setname(b,'AnyMap');
    return
  end

  % now we have: mapm(data,command,pars)
  % data might be dataset, datafile, cell array, double, structure array
  pars = cell(1,nargin-2);     % input pars
  [a,command,pars{:}] = deal(varargin{:}); % use nice names
  if numel(pars) > 1 % allow argument list as cell array or not.
   pars = {pars}
  end
  varargout = repmat({[]},[1, max((nargout-1),0)]);
    
  if isdatafile(a)               % for datafiles processing is stored
        
    if isempty(getpostproc(a)) & ~ismapping(command)
                                 % as preprocessing (if no postproc defined)
      b = addpreproc(a,command,pars);
    else                         % or as mapping as postprocessing
      v = prmapping(mfilename,'fixed',{command,pars});
      v = setname(v,mapname);
      b = addpostproc(a,v);      % store mapping
    end
    return
    
  elseif isdataset(a) % are executed here
    
    try
      [b,varargout{:}] = my_feval(command,a,pars);
    catch me
      [b,varargout{:}] = my_feval(command,+a,pars);
      if size(b,1) == size(a,1)
        b = setdata(a,b);
      else
        b = prdataset(b);
        b = setuser(b,getuser(a));
      end
    end
    
  elseif iscell(a)
    
    b = cell(numel(a));
    varargout = cell(numel(a),numel(varargout));
    n = numel(b);
    s = sprintf('Processing %i objects: ',n);
    prwaitbar(n,s);
    for i=1:n
      prwaitbar(n,i,[s int2str(i)]);
      [b{i},varargout{i,:}] = my_feval(mfilename,a{i},command,pars);
    end
    prwaitbar(0);
    
  else % doubles
    
    [b,varargout{:}] = my_feval(command,a,pars{:});
    
  end
  
return

function [b,varargout] = my_feval(command,a,pars)
  varargout = cell(1,nargout-1);
  if isempty(pars)
    [b,varargout{:}] = feval(command,a);
  elseif iscell(pars)
    [b,varargout{:}] = feval(command,a,pars{:});
  else
    [b,varargout{:}] = feval(command,a,pars);
  end
return