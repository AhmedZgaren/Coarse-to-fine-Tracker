optimizing = 0;
I=10;
rbfvals=load('rbfvals.dat');

aucval = zeros(8,10);

for i=1:16
    auc=zeros(10,6);
    for j=1:10
        filename=strcat('Models/','model_d',num2str(i),'_j_',num2str(j),'.mat');
        load(filename);
        
        for m=3:6%1:knn 2:parzen 3:gaussian 4:mcd gaussian 5:one-class SVM 6: proposed
            
            optfilename=strcat('Params/','paramprop_d',num2str(5),'_j_',num2str(j),'.dat');
            
            aucval(m,j) = genrocauc(training,testing,m,optimizing,optfilename,rbfvals(i,j));
        end
            aucval(7,j) = genrocauc(training,testing,7,optimizing,0.2,rbfvals(i,j));
   end
        
    
end


% for j=1:10
%     [x,z,I] = dd_crossval(a,I);
%     for k=1:10
%         optfilename=strcat('Params/','paramprop_d',num2str(j),'_j_',num2str(k),'.dat');
%         for m=1:6
%             aucval(m,j) = genrocauc(x,z,m,optimizing,optfilename,rbfvals(k,j));
%         end
%             aucval(7,j) = genrocauc(x,z,7,optimizing,0.2,rbfvals(k,j));
%     end
% end
    
    for m=1:7
    fprintf('%5.3f (%5.3f)\n',mean(aucval(m,:),2),std(aucval(m,:),[],2));
    end
%     fprintf('%5.3f (%5.3f)\n',mean(aucval(2,:),2),std(aucval(2,:),[],2));
%     fprintf('%5.3f (%5.3f)\n',mean(aucval(3,:),2),std(aucval(3,:),[],2));
%     fprintf('%5.3f (%5.3f)\n',mean(aucval(4,:),2),std(aucval(4,:),[],2));
%     fprintf('%5.3f (%5.3f)\n',mean(aucval(5,:),2),std(aucval(5,:),[],2));
%     fprintf('%5.3f (%5.3f)\n',mean(aucval(6,:),2),std(aucval(6,:),[],2));
%     fprintf('%5.3f (%5.3f)\n',mean(aucval(7,:),2),std(aucval(7,:),[],2));
%     fprintf('%5.3f (%5.3f)\n',mean(aucval(8,:),2),std(aucval(8,:),[],2));


