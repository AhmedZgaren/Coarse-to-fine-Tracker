%
%  Exemple jouet de regression semiparametraique
%


clear all;
close all;

%-------------------Creation des donnees et trace du graphe----------------
magik=magic(3);
x=[magik(:,1),magik(:,2);6,7];
x1=x(:,1);
x2=x(:,2);
y=3*x1 +4*x2 -x1.*x2;

%----------------------Phase d'apprentissage -------------------
C = 1; 
lambda = 1e-7; 
epsilon = 0.1;%largeur de "chaussette" de regression
kerneloption = [5,5];%parametre de reglage du noyau choisi
kernel='gaussian';%choix du noyau
verbose=0;%mode silencieux : impresssion de tous les calculs
T=phispan(x,'linear')
T=[];
[xsup,ysup,w,w0] = svmreg(x,y,C,epsilon,kernel,kerneloption,lambda,verbose);


%---------------------Traitement et trace du graphe de la fonction de regression--------
[xtesta1,xtesta2]=meshgrid([0:0.1:10],[0:0.1:10]);
[na,nb]=size(xtesta1);
xtest1=reshape(xtesta1,1,na*nb);
xtest2=reshape(xtesta2,1,na*nb);
xtest=[xtest1;xtest2]';
%ypred = svmval(xtest,xsup,[],w0,kernel,kerneloption,T);
ypred= svmval(xtest,xsup,w,w0,kernel,kerneloption);
ypredmat=reshape(ypred,na,nb);
%ypredmat=ypred


%--------------------------------------------------------
mesh(xtesta1,xtesta2,ypredmat);

meshc(xtesta1,xtesta2,ypredmat);
xlabel('x');
ylabel('y');
title('Regression a points supports');





