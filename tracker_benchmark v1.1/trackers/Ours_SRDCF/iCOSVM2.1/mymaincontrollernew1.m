optimizing = 0;
I=10;
rbfvals=load('rbfvals.dat');

% aucval = zeros(10,10);
% a=load ('cancer_dataset');

a = oc_set(gendatb([2000 60],2.6),'1'); % banana
%a= oc_set(gendats([4000 100],2,1.3),'1');% gaussian
%a= oc_set(gendatl([100 60],2.3),'1');% Lithuanian

%for m=1:2
    for j=1:1
         [x,z,I] = dd_crossval(a,I);
         for k=1:10
%            
            optfilename=strcat('Params/','paramprop_d',num2str(j),'_j_',num2str(k),'.dat');
%             aucval(1,j) = genrocauc(x,z,1,optimizing,optfilename,rbfvals(k,j));
%             aucval(2,j) = genrocauc(x,z,2,optimizing,optfilename,rbfvals(k,j));
%            aucval(3,j) = genrocauc(x,z,3,optimizing,optfilename,rbfvals(k,j));
%            aucval(4,j) = genrocauc(x,z,4,optimizing,optfilename,rbfvals(k,j));
%            aucval(5,j) = genrocauc(x,z,5,optimizing,optfilename,rbfvals(k,j));
%            aucval(6,j) = genrocauc(x,z,6,optimizing,optfilename,rbfvals(k,j));
%            aucval(7,j) = genrocauc(x,z,7,optimizing,1,rbfvals(k,j));
%             aucval(8,j) = genrocauc(x,z,8,optimizing,0.9,rbfvals(k,j));
            aucval(9,j) = genrocauc(x,z,9,optimizing,0.25,rbfvals(k,j));
        end
    end   

    fprintf('incSVDD  %5.3f (%5.3f)\n',mean(aucval(1,:),2),std(aucval(1,:),[],2));
    fprintf('incSVC   %5.3f (%5.3f)\n',mean(aucval(2,:),2),std(aucval(2,:),[],2));
    fprintf('SVDD     %5.3f (%5.3f)\n',mean(aucval(3,:),2),std(aucval(3,:),[],2));
    fprintf('kNN      %5.3f (%5.3f)\n',mean(aucval(4,:),2),std(aucval(4,:),[],2));
    fprintf('Parzen   %5.3f (%5.3f)\n',mean(aucval(5,:),2),std(aucval(5,:),[],2));
    fprintf('Gauss    %5.3f (%5.3f)\n',mean(aucval(6,:),2),std(aucval(6,:),[],2));
    fprintf('COSVM    %5.3f (%5.3f)\n',mean(aucval(7,:),2),std(aucval(7,:),[],2));
    fprintf('ISVMM    %5.3f (%5.3f)\n',mean(aucval(8,:),2),std(aucval(8,:),[],2));
    fprintf('iCOSVM   %5.3f (%5.3f)\n',mean(aucval(9,:),2),std(aucval(9,:),[],2));
