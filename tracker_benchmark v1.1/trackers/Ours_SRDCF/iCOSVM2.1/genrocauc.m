function [auc]=genrocauc(training,testing,method,optimizing,optimcon,kerneloption)
%method: 1: incSVDD 2: incSVC 3:incCOSVC 

% auc=0; %dummy

if(method>=1 && method<=8) %use dd_tools
%     training = oc_set(training,1);
%     testing=oc_set(testing,-1);   
    fracrej=0.2; %train such a way that 80% training gets accepted

    switch method
           
        case 1
            w = incsvdd([],fracrej,'e',kerneloption)*dd_normc;
        case 2
            w = incsvc ([],'e',kerneloption,1);
        case 3
            w = svdd([],fracrej,kerneloption);
        case 4
            w = knndd([],fracrej,1);
        case 5
            w = parzen_dd([],fracrej);
        case 6
            w = gauss_dd([],fracrej,0.1);
        case 7
            w = svc([],'cov',kerneloption,1,optimcon);
        case 8
            w = inccosvc ([],'mahal',kerneloption,1,optimcon);
    end
%    [~,~,~,auc]=my_dd_auc(testing*w);
      wtr = training*w;
      auc = dd_auc(testing*wtr*dd_roc);

else
    %kernel='gaussian';
    nu=0.2;
    %    kerneloption=11.3;
    verbose=0;
    
    if method==9
        if optimizing
            conparam=0:0.0001:1.0;
            bestres=0;
            for i=1:length(conparam)
                w = inccosvc ([],'cov',kerneloption,1,conparam(i));
                wtr = training*w;
                auc = dd_auc(testing*wtr*dd_roc);
           
                if auc>bestres
                    bestres=auc;
                    optimcon=conparam(i);
                end
            end 
            auc=bestres;
            save(filename,'optimcon','-ascii');
        else
            %optimcon=load(filename);
             w = inccosvc ([],'cov',kerneloption,1,optimcon);
             wtr = training*w;
             auc = dd_auc(testing*wtr*dd_roc);
         end
    else
       w = svc([],'cov',1);
       wtr = training*w;
       auc = dd_auc(testing*wtr*dd_roc);
    end
end