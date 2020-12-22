%
%   Launch this in order to check if everything is ok
%
%


exclass             ;%              | 2D SVM Classification problem 
                                 
exclass1            ;%              | 2D SVM Classification problem with different C
                                 
exclass2            ;%              | Comparing Gaussian Kernel and Polynomial Kernel on 2D
                                 
exclass3            ;%              | 2D SVM Classification with Semiparametric models
                                  
exclassalphainit    ;%              | Example of initialization of the Lagragian
                                 
                                
                                 
exclassls                    ;%     | Example of large-scale classification problem
                                  
exclassnpa                   ;%     | Example of SVM Classification Using NPA algorithm
                                  
exclassrn                    ;%     | Regularization Networks for classifying the CheckerBoard
                                  
exclassrn1                   ;%     | SemiParametric Regularization Networks 
                                  
exmulticlass                 ;%     | Example of multiclass problem using
                                  
exmulticlass1                ;%     | Treating the example presented by Lin & Wahba and analysing
                                  
                                  
exmulticlass1v1              ;%     | Example of multiclass problem using
                                  
exmulticlassall              ;%     | M-SVM algorithm for treating the multiclasse problem
                                  
exmulticlassall2             ;%     | Another M-SVM examples with assymetric penalization coefficients

%------------------------- Regression---------------------------
exreg1d                      ;%     | 1D SVM Regression problem    
                                  
exreg2d                      ;%     | 2D SVM Regression problem 

exreg1dls                    ;%     | Large Scale SVM regression

%-------------------------- Feature Selection -------------------
FeatSelAdaptScal             ;%     | Demo of the SVM adaptive scaling method of GrandValet & Canu
                                  
FeatSelAdaptScal1            ;%     | Example of adaptive scaling as described in the NIPS paper  

FeatSelExample               ;%     | Demo of the SVM based Variable Selection in Rakotomamonjy et al.
                                  
%---------------------------Kernel PCA -------------------------
kpcaex1                        ;%     | Simple Example of Kernel PCA on a artificial datasets
                                      
kpcaex2                        ;%     | Example of KPCA. this is a B.Scholkopf modified routine  
                                  
kpcaex3                        ;%     | Example of Multilayer SVM with a KPCA as a first stage

%------------------------- Wavelet Kernels ---------------------
%
% Need Wavelab Toolbox

clc %

fprintf('------------------------------------------------------------------------------------------------\n')
fprintf(' FOR THE LAST 2 EXAMPLES, YOU NEED TO HAVE INSTALL THE WAVELAB TOOLBOX OF DAVID DONOHO et al\n');
fprintf(' If you want to use the wavelet kernel, you have to install it otherwise dont worry about the errors\n');
fprintf(' press key to continue\n');
fprintf('------------------------------------------------------------------------------------------------\n')
pause
exclasscheckershaarkernel;%         | Comparing Haar Kernel and Gaussian Kernel on
extensorwavkernel            ;%     | Example of the different possibility of wavelet kernel
                                  