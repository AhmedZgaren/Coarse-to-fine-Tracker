%PLOT_MST Plot minimum spanning tree
%
%    PLOT_MST(A,TREE,STR,LWIDTH)
% 
% INPUT
%   A        dataset
%   TREE     list of edges
%   STR      color (default = 'k')
%   LWIDTH   linewidth (default = 1)
%
% DESCRIPTION
% Plots the edges of a minimum spanning tree, defined by the nodes A and
% TREE. The tree will be plotted with linewidth LWIDTH and color STR
% (e.g. 'k','m' or [0.9 0.1 0.7]).
% 
% SEE ALSO
% mst_dd, datasets, mappings

%  Copyright: Piotr Juszczak, p.juszczak@tudelft.nl
%  Information and Communication Theory Group,
%  Faculty of Electrical Engineering, Mathematics and Computer Science,         
%  Delft University of Technology, The Netherlands

function plot_mst(a,tree,c,lwidth)

if (nargin<4)
   lwidth = 1;
end
if (nargin<3)
   c = 'k';
end
if (nargin<2), error('At least 2 inputs expected');end
m = size(a,1);
mt = size(tree);
if ((m-1)~=mt), error('The size of dataset does not much number of edges.'); end

i=0;
if ~ishold, hold on; i=1; end

for k=1:size(tree,1)
    plot([+a(tree(k,1),1),+a(tree(k,2),1)],[+a(tree(k,1),2),+a(tree(k,2),2)],...
        'linestyle','-','linewidth',lwidth,'color',c);
end

if i==1, hold off; end

return;

