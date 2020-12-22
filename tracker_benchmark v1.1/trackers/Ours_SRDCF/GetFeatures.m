%%%%%%%%%%%%%%% vector Layer features %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Alexnet %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% GetFeatures %%%%%%%%%%%%%%%

%function vect=GetFeatures(net,Im,layer,rect)
%%INPUT 
%net : CNN network alexnet,vggnet,.....
%Im : current frame (image)
%layer : CNN layer , it should correspond to the network net
%rect : rectangle position and size , [x y width height]
%%OUTPUT
%vect : the feature vector corresponding to the target located by rect on
 
function vectf=GetFeatures(net,Im,layer,rect,n)

[L,C,ch]=size(Im);
if ch<3
    Im(:,:,2)=Im(:,:,1);
    Im(:,:,3)=Im(:,:,1);
end

%%test rect in image boundaries
if rect(1,1) < 0, rect(1,1)=0 ;end
if rect(1,1) > C-rect(1,3), rect(1,1)=C-rect(1,3) ;end
if rect(1,2) < 0, rect(1,2)=0 ;end
if rect(1,2) > L-rect(1,4), rect(1,2)=L-rect(1,4) ;end

    trMask=imcrop(Im,rect);
    trMask=imresize(trMask,[227 227]); % if AlexNet [224,224]
    data=my_init_trans(trMask,n);
    for z=1:n
         if n==1 
        vect=activations(net,trMask,layer,'OutputAs','Channels');
         elseif n >1
    vect=activations(net,data(:,:,:,z),layer,'OutputAs','Channels');
         end
    
[L,C,kernel]=size(vect);
         act=zeros(1,kernel);
                for k=1:kernel
                   A=vect(:,:,k);
                   B=(A>0).*A;
                   act(1,k)=sum(sum(B.*0.01));
                end
     vectf(z,:)=double(act(1,:));
       
    end
     vectf=double(vectf);
  end