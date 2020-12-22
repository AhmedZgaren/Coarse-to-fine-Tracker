function [auc]=genrocauc(training,testing,method,optimizing,optimcon,kerneloption)
%method: 1: incSVDD 2: incSVC 3:incCOSVC 

% auc=0; %dummy

if(method>=1 && method<=2) %use dd_tools

    fracrej=0.2; %train such a way that 80% training gets accepted
    switch method
        case 1
            tic
            w = incsvdd([],fracrej,'e',kerneloption)*dd_normc;
            auc = toc;
        case 2
            w = incsvc ([],'e',kerneloption,1);
            auc= toc;
    end
    %[~,~,~,auc]=my_dd_auc(testing*w);
%     wtr = training*w;
%     auc = dd_auc(testing*wtr*dd_roc);
else
    %kernel='gaussian';
    
    nu=0.2;
    %    kerneloption=11.3;
    verbose=0;
    
    if method==3
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
            tic
             w = inccosvc ([],'cov',kerneloption,1,optimcon);
             auc=toc;
             wtr = training*w;
%              auc = dd_auc(testing*wtr*dd_roc);
        end
    else
        kernel = 'gaussian';
        nu=0.2;
        verbose=0;
        optimcon=load(filename);
        [sup,alpha,rho,pos]=svmoneclassmine(training,kernel,kerneloption,nu,verbose,optimcon);
            %             ypred=svmoneclassval(training,sup,alpha,rho,kernel,kerneloption);
            %             sum(ypred<0)/length(ypred)s
         ypred=svmoneclassval(testing,sup,alpha,rho,kernel,kerneloption);
         [~,~,~,auc]=perfcurve(testing_tags,ypred,1);
    end
end