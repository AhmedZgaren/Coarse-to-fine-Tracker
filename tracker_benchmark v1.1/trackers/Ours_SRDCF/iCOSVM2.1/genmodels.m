names={'gauss1100.mat','gauss2100.mat','gauss1250.mat','gauss2250.mat','gauss1500.mat','gauss2500.mat','gauss11000.mat','gauss21000.mat','gauss12000.mat','gauss22000.mat'};

mnum=1;
for i=1:size(names,2)
    
    load(strcat('Datasets/',names{i}));
    
    
    for l=1:2
        if l==1
            target=c1;
            outlier=c2;
        else
            target=c2;
            outlier=c1;
        end
        
        target_outtag=false(size(target,1),1);
        target_fraction=floor(size(target,1)/10);%10-fold crossval, each time take 10% of the target class out for testing
        
        for j=1:10
            filename=strcat('Models/','model_d',num2str(mnum),'_j_',num2str(j),'.mat');
            
            valid_set=find(~target_outtag);
            target_out=valid_set(randperm(size(valid_set,1)));
            target_out=target_out(1:target_fraction);
            target_outtag(target_out)=true;
            
            training=target;
            training(target_out,:)=[];
            testing=vertcat(outlier,target(target_out,:));
            testing_tags=vertcat(-1*ones(size(outlier,1),1),ones(size(target(target_out,:),1),1));
            save(filename,'training','testing','testing_tags');
            
            
            
        end
        mnum=mnum+1;
    end
end

