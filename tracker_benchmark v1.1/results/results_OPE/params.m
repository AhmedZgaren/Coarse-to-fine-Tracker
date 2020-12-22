params.ThreCOSVM = 0.5;                 % The threshold for iCOSVM Learning
params.threCF = 0.0;                    %the threshold for CF Learning

%iCOSVM parameters
   %CNN
params.net =vgg16;
params.layer ='conv5_3'; %depends on the network
params.pad = 0.9;  % extra area of the target bb
 %Kernel parameter
params.C = [1;1];
params.ktype = 'cov';
params.Kpar = 1000;
params.conparam = 0.1;
params.Rayon = 20;
0.624/20 part/0.05