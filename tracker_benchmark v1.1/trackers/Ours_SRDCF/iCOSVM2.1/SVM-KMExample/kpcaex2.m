%
% This is a modified version of original script of Scholkopf example that make use
% of kernelpca and kernelpcaproj routine
%
% Last Modified : 20/02/2001 AR

% parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rbf_var = 0.1;
xnum = 4;
ynum = 2;
max_ev = xnum*ynum;
% (extract features from the first <max_ev> Eigenvectors)
x_test_num = 15;
y_test_num = 15;
cluster_pos = [-0.5 -0.2; 0 0.6; 0.5 0];
cluster_size = 30;

% generate a toy data set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_clusters = size(cluster_pos,1);
train_num = num_clusters*cluster_size;
patterns = zeros(train_num, 2);
range = 1;
randn('seed', 0);
for i=1:num_clusters,
  patterns((i-1)*cluster_size+1:i*cluster_size,1) = cluster_pos(i,1)+0.1*randn(cluster_size,1);
  patterns((i-1)*cluster_size+1:i*cluster_size,2) = cluster_pos(i,2)+0.1*randn(cluster_size,1);
end
test_num = x_test_num*y_test_num;
x_range = -range:(2*range/(x_test_num - 1)):range;
y_offset = 0.5;
y_range = -range+ y_offset:(2*range/(y_test_num - 1)):range+ y_offset;
[xs, ys] = meshgrid(x_range, y_range);
test_patterns(:, 1) = xs(:);
test_patterns(:, 2) = ys(:);
cov_size = train_num;  % use all patterns to compute the covariance matrix

%---------------------------Kernel PCA-----------------------------------------%
kernel='gaussian';
kerneloption=sqrt(rbf_var/2);
[evecs,evals]=kernelpca(patterns,kernel,kerneloption);
test_features=kernelpcaproj(patterns,test_patterns,evecs,kernel,kerneloption,1:max_ev);
%-------------------------------------------------------------------------------%


figure; clf
for n = 1:max_ev,
  subplot(ynum, xnum, n);
  axis([-range range -range+y_offset range+y_offset]);
  imag = reshape(test_features(:,n), y_test_num, x_test_num);
  axis('xy')
  colormap(gray);
  hold on;
  pcolor(x_range, y_range, imag);
  shading interp
  contour(x_range, y_range, imag, 9, 'b');
  plot(patterns(:,1), patterns(:,2), 'r.')
  text(-1,1.65,sprintf('Eigenvalue=%4.3f', evals(n)));
  hold off;
end
