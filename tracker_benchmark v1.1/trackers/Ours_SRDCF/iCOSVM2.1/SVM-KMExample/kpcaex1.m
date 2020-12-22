  
%
% Example of Kernel PCA on artificial data
%   
%

close all
clear all

x1=0.2*randn(100,1)+0.5;
x2=x1+0.2*randn(100,1)+0.2;
x=[x1 x2];
y1=1*randn(100,1)+0.5;
y2=-y1.^2+0.05*randn(100,1)+0.2;
y=[y1 y2];
xpca=[x;y];


xpca=randn(100,2)*[0.2 0.001; 0.001 0.05];


vect=[-1:0.05:1];
nv=length(vect);
[auxx,auxy]=meshgrid(vect);
xtest=[reshape(auxx,nv*nv,1) reshape(auxy,nv*nv,1)];

kernel='poly';
kerneloption=1;
max_eigvec=8;
[eigvect,eigval]=kernelpca(xpca,kernel,kerneloption);
max_eigvec=min([length(eigval) max_eigvec]);
feature=kernelpcaproj(xpca,xtest,eigvect,kernel,kerneloption,1:max_eigvec);

figure; 
title('Data and IsoValues on the different eigenvectors');
for n = 1:max_eigvec,
  subplot(2,max_eigvec/2, n);
  axis([-1 1 -1 1]);
  imag = reshape(feature(:,n), nv, nv);
  axis('xy')
  colormap(gray);
  hold on;
  %pcolor(vect, vect, imag);
  %shading interp
  [c,h]=contour(vect, vect, imag, 9,'b');
  clabel(c,h);
  plot(xpca(:,1), xpca(:,2), 'r.')
  text(-1,1.05,sprintf('Eigenvalue=%4.3f', eigval(n)));
  hold off;
end
