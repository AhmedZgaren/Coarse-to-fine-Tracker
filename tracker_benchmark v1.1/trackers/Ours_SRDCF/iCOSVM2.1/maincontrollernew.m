optimizing=0;
aucval=zeros(16,6);
rbfvals=load('rbfvals.dat');

for i=11:16
    auc=zeros(10,6);
    for j=1:10
        filename=strcat('Models/','model_d',num2str(i),'_j_',num2str(j),'.mat');
        load(filename);
        %optfilename=strcat('Params/','paramprop_d',num2str(5),'_j_',num2str(j),'.dat');
        [auc(j,1)]=mygenrocauc(training,testing,1,optimizing,0,rbfvals(i,j));
    end
        
 end
    aucval(i,:)=[mean(auc(:,1)) std(auc(:,1))];
%     %save(strcat('aucvals_',num2str(i),'.dat'),'aucval','-ascii');
%     aucval
%     save('aucvals_ff.dat','aucval','-ascii');
    
