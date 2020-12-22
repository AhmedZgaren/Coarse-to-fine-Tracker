% Generate augmented patches from the original target
% Translation, rotation and scale 
%%Input:
%I : target patch
%nop : number of new augmented patches to be generated

%%Output:
%imtrans :  a nop-batch of new patches 4D-vector

function imtrans=my_init_trans(I,nop)
    if nop ==1 
        imtrans(:,:,:,1)=I(:,:,:);
    else
        for i=1:nop
            low = -(3); high = (3);
            angle_rot = low + (high-low) * rand;
            low = 0.5; high = 1.5;
            scale = low + (high-low) * rand;
            low = -10; high = 10;
            x_shift = fix(low + (high-low) * rand);
            y_shift = x_shift ;
            pertIm = affineTransform(I, [x_shift y_shift], angle_rot, [scale scale], [1 1] );
           
            imtrans(:,:,:,i)=pertIm(:,:,:);
        end
    end
end

