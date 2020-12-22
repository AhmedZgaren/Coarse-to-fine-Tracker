function [auc]=mygenrocauc(training,testing,method,optimizing,optimcon,kerneloption)
%optimizing,filename,
%method: 1: incSVDD 2: incSVC 3:incCOSVC 


% Soptimcon = 1;

if(method>=1 && method<=2) %use dd_tools
    switch method
        case 1
            w= incsvc ([],'e',kerneloption,1);
        case 2
            w= incsvdd([],0.2,'e',kerneloption)*dd_normc;
    end 
wtr = training*w;
auc = d_auc(testing*wtr*dd_roc);

else
    if optimizing
        conparam=0:0.001:1.0;
        bestres=0;
        for i=1:length(conparam)
            w= inccosvc([],'cov',kerneloption,1,conparam); 
            wtr = training*w;
            auc = dd_auc(testing*wtr*dd_roc);
            
            if auc>bestres
                bestres=auc;
                optimcon=conparam(i);
            end
        end 
        auc=bestres;
        save(filename,'incoptimcon','-ascii');
        %save incoptimcon.txt optimcon -ASCII
    else 
        %optimcon=load(filename);
        w= inccosvc([],'cov',kerneloption,1,optimcon); 
        wtr = training*w;
        auc = dd_auc(testing*wtr*dd_roc);
    end
  
end
