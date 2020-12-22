optimizing = 0;
I=10;
rbfvals=load('rbfvals.dat');

aucval = zeros(6,10);

a = oc_set(gendatb([200 60],2.6),'1');
%a= oc_set([gamrnd(14,3,100,2) gamrnd(20,3,100,2)],'1');
b = oc_set(gendats([100 60],2,2.6),'1');

%for m=1:2
    for j=1:10
         [x,z,I] = dd_crossval(a,I);
         %[y,u,I] = dd_crossval(b,I);
        for k=1:10
           
            optfilename=strcat('Params/','paramprop_d',num2str(j),'_j_',num2str(k),'.dat');
            aucval(1,j) = genrocauctime(x,z,1,optimizing,optfilename,rbfvals(k,j));
            aucval(2,j) = genrocauctime(x,z,2,optimizing,optfilename,rbfvals(k,j));
            aucval(3,j) = genrocauctime(x,z,3,optimizing,0.27,rbfvals(k,j));
%             aucval(4,j) = genrocauc(y,u,1,optimizing,optfilename,rbfvals(k,j));
%             aucval(5,j) = genrocauctime(y,u,2,optimizing,optfilename,rbfvals(k,j));
%             aucval(6,j) = genrocauctime(x,z,3,optimizing,0.27,rbfvals(k,j));
            
        end
    end    
%end 

% for j=1:10
%     [x,z,I] = dd_crossval(a,I);
%     %for i=1:10
%     %    optfilename=strcat('Params/','paramprop_d',num2str(i),'_j_',num2str(j),'.dat');
%         aucval(3,j) = mygenrocauc(x,z,3,optimizing,optfilename,5);
%    % end 
% end
        

% for i=1:2
    fprintf('%5.3f (%5.3f)\n',mean(aucval(1,:),2),std(aucval(1,:),[],2));
    fprintf('%5.3f (%5.3f)\n',mean(aucval(2,:),2),std(aucval(2,:),[],2));
    fprintf('%5.3f (%5.3f)\n',mean(aucval(3,:),2),std(aucval(3,:),[],2));
    %fprintf('%5.3f (%5.3f)\n',mean(aucval(4,:),2),std(aucval(4,:),[],2));
% end
