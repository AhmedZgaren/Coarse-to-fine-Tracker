function newNN = initDLT(tmpl, L)
    load pretrain;
    global useGpu;
    newNN = nnsetup([1024 2560 1024 512 256 1]);
    for i = 1 : 4
        if useGpu
            newNN.W{i} = gpuArray(W{i});
        else
            newNN.W{i} = W{i};
        end
    end
    newNN.weightPenaltyL2 = 2e-3;
    newNN.activation_function = 'sigm';
    newNN.learningRate = 1e-1;
    newNN.momentum = 0.5;
    opts.numepochs = 20;
    opts.batchsize = 10;
    
    L(L == -1) = 0;
    
    newNN = nntrain(newNN, tmpl.basis', L, opts);
    clear nn;
end