


%
%    This example presents the feature selection algorithm
%    of Grandvalet and Canu (2002) based on adaptive scaling
%
%



clear all
close all

clc


data='westontoynonlinear';
nbfeatureforclassification=2;
nbiter=1;
nbtrain=100;




%-----------------------------------------------------------------------%
%                       Initialisation                                  %
%-----------------------------------------------------------------------%


load (data)
nbdata=size(Y,1);   
d=size(X,2);
indpos=find(Y==1);
indneg=find(Y==-1);
nbpos=length(indpos);
nbneg=length(indneg);
nbtest= nbdata -nbtrain;

%--------------------------------------%
% SVM parameters
%--------------------------------------%

lambdaReg    = 1e-10; 
kernel       ='gaussian';
kerneloption = 1;
verbose = 3 ; 
Sigma =0.01*ones(1,d);
C = 10;

% in order to properly reproduce the results presented in the NIPS paper
% one has to select C and Sigma using a span estimate criterion


% sigma tuning

option  = 'lupdate'  ; %['wbfixed','wfixed','lbfixed','lfixed','lupdate'].
pow = 1 ;


%--------------------------------------%
% 
%--------------------------------------%

for i=1:nbiter
   tic 
   load (data)
   fprintf('%d...',i);
   ranking=[];

    sample=randperm(min([nbneg nbpos]));
    indapp=[indpos(sample(1:nbtrain/2));indneg(sample(1:nbtrain/2))];

   x=X(indapp,:);
   y=Y(indapp,:);
   indtest=1:nbdata;indtest(indapp)=[];
   yt=Y(indtest);
   xt=X(indtest,:);
   [x,xt]=normalizemeanstd(x,xt);
   clear X,Y;
    
    %------------------------------------------------------------------%
    %                       Feature Selection and learning
    %------------------------------------------------------------------%
    [Sigma,Xsup,Alpsup,w0,pos,nflops,crit,SigmaH] = svmfit(x,y,Sigma,C,option,pow,verbose);
    nsup=size(Xsup,1);

    ypred = svmval(xt.*repmat(Sigma,nbtest,1),Xsup.*repmat(Sigma,nsup,1),Alpsup,w0,kernel,kerneloption,ones(nbtest,1));
    nberror(i)= sum(sign(ypred)~=yt)/nbtest;
   


    
end;
