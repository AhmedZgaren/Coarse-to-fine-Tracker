%
%
clear all
close all


clear all
close all

N=100;
moy=linspace(-5,5,N);
n=100;
sigma=0.2;



kernelsetoption.kerneloption=1;
kernelsetoption.method='norm';
oneclassoption.nu=0.3; 
oneclassoption.kernel='gaussian';
oneclassoption.kerneloption=1;



[xapp,yapp]=datasets('gaussian',n,0,sigma);

x1=xapp(find(yapp==1),:);
x2=xapp(find(yapp==-1),:);
A{1}=x1;
for i=1:N
    x2p=x1+ moy(i);  
    B{i}=x2p;
end;


K= kernelset(A,kernelsetoption,oneclassoption,B)
    
    
 
