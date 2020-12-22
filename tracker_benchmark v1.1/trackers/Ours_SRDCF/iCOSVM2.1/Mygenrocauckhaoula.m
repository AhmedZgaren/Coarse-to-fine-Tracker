function [w,wtr,E,auc]=Mygenrocauckhaoula(training,testing,method,optimizing,optimcon,kerneloption,nu)
%method: 1: incSVDD 2: incSVC 3:incCOSVC 

% auc=0; %dummy

if(method>=1 && method<=8) %use dd_tools
%     training = oc_set(training,1);
%     testing=oc_set(testing,-1);   
    fracrej=0.1; %train such a way that 80% training gets accepted

    switch method
           
        case 1
            w = incsvdd([],fracrej,'r',kerneloption)*dd_normc;
        case 2
            w = incsvc ([],'r',kerneloption,1);
        case 3
            w = svdd([],fracrej,kerneloption);
        case 4
            w = knndd([],fracrej,1);
        case 5
            w = parzen_dd([],fracrej);
        case 6
            w = gauss_dd([],fracrej,0.1);
        case 7
            w = svc([],'r',kerneloption,0.1);
        case 8
            w = inccosvc ([],'mahal',kerneloption,1,optimcon);
       
    end
%     [X,Y,T,auc]=my_dd_auc(testing*w);
       wtr = training*w;
       
       E=testing*wtr*dd_roc;
       auc = dd_auc(E);

else
    %kernel='gaussian';
%     nu=0.1;
    %    kerneloption=11.3;
    verbose=0;
    
    if method==9
        if optimizing
            conparam=0:0.0001:1.0;
            bestres=0;
            for i=1:length(conparam)
                w = inccosvc ([],'cov',kerneloption,1,conparam(i));
                wtr = training*w;
                E=testing*wtr*dd_roc;
                auc = dd_auc(E);
           
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
             E=testing*wtr*dd_roc;
             auc = dd_auc(E);
         end
    else
       w = svc([],'cov',1);
       wtr = training*w;
       E=testing*wtr*dd_roc;
       auc = dd_auc(E);
    end
end