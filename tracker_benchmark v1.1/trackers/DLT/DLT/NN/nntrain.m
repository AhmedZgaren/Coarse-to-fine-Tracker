function [nn, L]  = nntrain(nn, train_x, train_y, opts, val_x, val_y)
%NNTRAIN trains a neural net
% [nn, L] = nnff(nn, x, y, opts) trains the neural network nn with input x and
% output y for opts.numepochs epochs, with minibatches of size
% opts.batchsize. Returns a neural network nn with updated activations,
% errors, weights and biases, (nn.a, nn.e, nn.W, nn.b) and L, the sum
% squared error for each training minibatch.

% assert(isfloat(train_x), 'train_x must be a float');
assert(nargin == 4 || nargin == 6,'number ofinput arguments must be 4 or 6')
global useGpu;
loss.train.e               = [];
loss.train.e_frac          = [];
loss.val.e                 = [];
loss.val.e_frac            = [];
opts.validation = 0;
if nargin == 6
    opts.validation = 1;
end

fhandle = [];
if isfield(opts,'plot') && opts.plot == 1
    fhandle = figure();
end

m = size(train_x, 1);

batchsize = opts.batchsize;
numepochs = opts.numepochs;

numbatches = m / batchsize;

assert(rem(numbatches, 1) == 0, 'numbatches must be a integer');

if useGpu
    L = gpuArray.zeros(numepochs*numbatches,1);
else
    L = zeros(numepochs*numbatches,1);
end
n = 1;
oldError = 1e9;
for i = 1 : numepochs
    tic;
    kk = randperm(m);
    
    if useGpu
        selection = gpuArray.randn(batchsize, size(train_x, 2))*nn.inputZeroMaskedFraction;
    else
        selection = randn(batchsize, size(train_x, 2))*nn.inputZeroMaskedFraction;
    end
    for l = 1 : numbatches
        if mod(l, 100) == 0
            disp(['Batch ' num2str(l)])
            selection = gpuArray.randn(batchsize, size(train_x, 2))*nn.inputZeroMaskedFraction;
        end
        if useGpu
            batch_x = gpuArray(train_x(kk((l - 1) * batchsize + 1 : l * batchsize), :));
            batch_y = gpuArray(train_y(kk((l - 1) * batchsize + 1 : l * batchsize), :));
        else
            batch_x = train_x(kk((l - 1) * batchsize + 1 : l * batchsize), :);
            batch_y = train_y(kk((l - 1) * batchsize + 1 : l * batchsize), :);
        end
        
        %Add noise to input (for use in denoising autoencoder)
        if(nn.inputZeroMaskedFraction ~= 0)
            batch_x = batch_x + selection;
        end
        
        
        
        if mod(i, 1) == 0
            nn = nnff(nn, batch_x, batch_y, true);
        else
            nn = nnff(nn, batch_x, batch_y);
        end
        nn = nnbp(nn);
        nn = nnapplygrads(nn);
        
        L(n) = nn.L;
        
        n = n + 1;
    end
    
    t = toc;
    
    if ishandle(fhandle)
        if opts.validation == 1
            loss = nneval(nn, loss, train_x, train_y, val_x, val_y);
        else
            loss = nneval(nn, loss, train_x, train_y);
        end
        nnupdatefigures(nn, fhandle, loss, opts, i);
    end
    
    disp(['epoch ' num2str(i) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds' '. Mean squared error on training set is ' num2str(mean(L((n-numbatches):(n-1))))]);
    error = mean(L((n-numbatches):(n-1)));
    oldNN = nn;
    if error > oldError || error < 0.001
        nn = oldNN;
        break;
    end
    oldError = error;
    nn.learningRate = nn.learningRate * nn.scaling_learningRate;
%     save final1 nn;
end
end

