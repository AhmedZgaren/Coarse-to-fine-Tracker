%MST_DD Minimum Spanning Tree Data Description.
% 
%       [W,TREE,A] = MST_DD(A,FRACREJ,N)
%
% INPUT
%   A         one-class dataset
%   FRACREJ   fraction rejection [0,1]; (default 0.1)
%   N         complexity parameter equals a number of
%             paths of max length; (default 0, entire mst) 
%
% OUTPUT
%   W         one-class classifier
%   TREE      [m-1 2] list of edges in mst
%   A         m x m weighted adjacency matrix of mst
%
% DESCRIPTION
% Train a minimum spanning tree on dataset A, and use the distance from
% a point Z to the closest edge or point as indicator if Z is outlier or
% not.
%
% SEE ALSO
% plot_mst, datasets, mappings

%  Copyright: Piotr Juszczak, p.juszczak@tudelft.nl
%  Information and Communication Theory Group,
%  Faculty of Electrical Engineering, Mathematics and Computer Science,         
%  Delft University of Technology,            
%  The Netherlands

%function [W,tree,A] = mst_dd(a,thr,N)
function W = mst_dd(varargin)

argin = shiftargin(varargin,'scalar');
argin = setdefaults(argin,[],0.1,0);
  
if mapping_task(argin,'definition')       % Define mapping
   W = define_mapping(argin,'untrained','Minimum Spanning Tree');
    
elseif mapping_task(argin,'training')			% Train a mapping.
  
   [a,thr,N] = deal(argin{:});
%============================ training ============================ 
  
	% Make sure a is a OC dataset:
	if ~isocset(a), error('one-class dataset expected'); end
	
	a = target_class(a);
	[m,k] = size(a);
	d = sqrt(sqeucldistm(+a,+a));

	[tree,A] = mst(d); % compute minimum spanning tree 

	if N > 0
		[dummy,paths] = m_paths(A,N);
		tree = [];
		for i=1:N
			tree = [tree; [paths{i,1}(1:end-1)' paths{i,1}(2:end)']];
		end
	end

	al = a(tree(:,1),:); %al,bl objects with edges in a  
	bl = a(tree(:,2),:);
    
% compute norm	
	nn = +[al - bl];
	nn(nn==0) = 10e-10; % nn~=0 as we divide by nn  
	normn = sqrt(sum(nn.*nn,2));
	n = nn./repmat(normn,1,k);
	
	lambda_thr = (bl - al)./n;
	lambda_thr = +lambda_thr(:,1);
	
	W.a = a(unique(tree(:)),:);
	W.so = al;
	W.norm = n;
	W.lambda_thr = lambda_thr; 
	W.threshold = 'thr';
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);

%======== set threshold ======================================================

	if N > 0
		tmp = (setdiff(1:m,unique(tree(:))))';
		
		if ~isempty(tmp) % there are objects in the training set but not in the the tree
			w  = prmap(a(tmp,:),W); % map ~support objects on segments	
			dist_tmp = sort([zeros(m-size(tmp,1),1);w.data(:,2)]);
			thr = dist_tmp(m*(1-thr),1);
			
			if (thr==0)
				prwarning(1,'threshold = 0, percent of rejected objects is larger than percent of objects not in the tree');
			end
			
		else
			AA = triu(A);
   		dist_tmp = sort(AA(AA~=0));
   		nr = round(size(dist_tmp,1)*(1-thr));
   		if (nr==0)
   			thr = 0;
   		else
   			thr = dist_tmp(nr,1);
   		end																					  
		end
	else
		AA = triu(A);
		dist_tmp = sort(AA(AA~=0));
		nr = round(size(dist_tmp,1)*(1-thr));
		if (nr==0)
			thr = 0;
		else
			thr = dist_tmp(nr,1);
		end																					  
	end

%====================================================================

	W = getdata(W);
	W.threshold = thr;
	W = prmapping(mfilename,'trained',W,str2mat('target','outlier'),k,2);
	W = setname(W,'MST Data Description');	

elseif mapping_task(argin,'trained execution')

   [a,thr] = deal(argin{1:2});
%============================ testing ============================
	W = getdata(thr);
	
	m = size(W.so,1);
	[mm,k] = size(a);
	out = zeros(mm,1);
	
%=========memory checking ==========================	
	mem = 20000000;
	loops = ceil((m*mm*k)/mem);
	
	if loops > 1
		x = floor(linspace(1,mm,loops+1));
	else
		x = [1 mm]';
	end
% ==================================================	
ind = zeros(mm,1);

	for i=1:loops
		sep = [x(i) + (1*(i~=1)):x(i+1) + (1*(i~=loops))]';
		mmm = size(sep,1);
		
		[dnn nn_ind]  = min(sqrt(sqeucldistm(+a(sep,:),W.a)),[],2);
		
		zz = repmat(reshape(+a(sep,:),mmm,1,k),[1,m,1]);
		alal = repmat(reshape(+W.so,1,m,k),[mmm,1,1]);
		nn = repmat(reshape(W.norm,1,m,k),[mmm,1,1]);
		
		zhat = alal + repmat(sum(nn.*(zz-alal),3),[1,1,k]).*nn;	
		dd = sqrt( sum((zz - zhat).*(zz - zhat),3));
		lambda = (zhat - alal)./nn;
		
		lambda_thr = repmat(+W.lambda_thr',mmm,1);
		lambda  = +lambda(:,:,1);
		tmp = ( abs(lambda) <= abs(lambda_thr) ) & ((lambda.* lambda_thr) >= 0);
		dd(~tmp) = inf;

		[out(sep,:) ind_tmp] = min([dnn,dd],[],2);

		ind_1 = ind_tmp==1;
		ind_tmp(ind_1) = nn_ind(ind_1)-1;
		ind_tmp(~ind_1) = ind_tmp(~ind_1)-1;
		ind_tmp(ind_tmp == 0) = 1;
		ind(sep,:) = ind_tmp;		
	
	end
	
	if ischar(W.threshold) 				%setting threshold during training of mst_dd
		W = setdat(a,[ind out]);
	else
		newout = -[out, repmat(+W.threshold(:,1),mm,1)];	
		W = setdat(a,newout,thr);
	end			
else
   error('Illegal call to MST_DD.');
end		
return;
