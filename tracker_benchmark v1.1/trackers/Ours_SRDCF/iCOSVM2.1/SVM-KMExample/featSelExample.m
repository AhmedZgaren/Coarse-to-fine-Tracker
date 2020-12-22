%
%
%   This is a demo file for the variable selection algorithm
%   described in the JMLR paper
%   
%   One can play with the Weston's synthetic non linear problem
%   and try two criteria
%
%   The w^2 criterion with is SVM-RFE criterion if the alpha is keeped fixed
%   and the grad w^2 criterion which seems to be the more consistent criterion
%   
%   Instead of returning a classification error, this demo file returns only
%   the ranked variables
%
%
%  28/03/2003  alain.rakoto@insa-rouen.fr
%


clear all
close all

clc


data='Gaussian';
sigmadata=0.2;
nbtrain=40;
nbspurious=10;



nbfeatureforclassification=2;
nbiter=10;
c = 1000; 
sigma=3;


%-----------------------------------------------------------------------%
%                       Feature Selection Settings                      %
%-----------------------------------------------------------------------%



featseloption.AlphaApprox=1;   % if zero, alpha is calculated at each step 
featseloption.RemoveChunks=1;
featseloption.StopChunks=30;
featseloption.FirstOrderMethod='scal';   %scal is the parameter used in the JMLR paper % or 'grad', 'absscal' 'scal'
%-----------------------------------------------------------------------%
%                       Algorithm                                       %
%-----------------------------------------------------------------------%
margin = 1;
margdif = 1;

%-----------------------------------------------------------------------%
%                       SVM Parameters                                  %
%-----------------------------------------------------------------------%

verbose = 0;

kerneloption = sigma;           
kerneloptionmd=sigma;
kernel='gaussian';
lambda=1e-7;
usefulfeat=[1 2];




%-----------------------------------------------------------------------%
%                       Information Printing                            %
%-----------------------------------------------------------------------%

fprintf('----------------------------------------Settings-------------------------------------------\n');
fprintf('\t\t Data:%s \t Nbtrain:%d \t  USeful features : %d %d \n', data, nbtrain,usefulfeat);
fprintf('---------------------------------------------------------------------------------------------\n\n');
fprintf('-----------------------------------------Feature Selection-----------------------------------\n');
fprintf('\t\t Alpha Approximation: %d \t  NbVarRemoved:%d \t First-Order Method: %s \n',...
    featseloption.AlphaApprox,featseloption.RemoveChunks,featseloption.FirstOrderMethod); 
fprintf('---------------------------------------------------------------------------------------------\n\n');
fprintf('----------------------------------------SVM Setting------------------------------------------\n');
fprintf('Kernel : %s \t  Kerneloption Zero-Order : %2.2f \t Kerneloption First-Order : %2.2f \tC:%d\n'...
    ,kernel,kerneloption,kerneloptionmd,c);
fprintf('---------------------------------------------------------------------------------------------\n\n');

%-----------------------------------------------------------------------%
%                       Initialisation                                  %
%-----------------------------------------------------------------------%




for i=1:nbiter
    tic 
    
    fprintf('%d...',i); 
    
    
    ranking=[];
    [x,y]=datasets(data,nbtrain,0,sigmadata);
    x=[x  randn(nbtrain,nbspurious)];
    [x]=normalizemeanstd(x);
    
    %------------------------------------------------------------------%
    %                       Feature Selection 
    %------------------------------------------------------------------%
    
    if margin
        [rankedmargin(i,:)]=featselmargin(x,y,c,kernel,kerneloption,verbose,1,featseloption);
        ranking=[ranking;rankedmargin(i,:)];
    end;
    if margdif     
        
        [rankedmd(i,:),nbsv(i,:),valuemd]=featselmargdif(x,y,c,kernel,kerneloptionmd,verbose,1,featseloption);  
        ranking=[ranking;rankedmd(i,:)];
        
    end;
    
    
end;

fprintf('\n----------------Two Top Ranked Variables---------------- \n');
rankedmargin(:,1:2)


rankedmd(:,1:2)
