Thanks for your interest in our work "Online Robust Non-negative Dictionary Learning for Visual Tracking", Naiyan Wang and Dit-Yan Yeung, NIPS2013

If you have any problems with the codes or find bugs in codes, please contact winsty@gmail.com.

=================Usage====================
The provided codes could be either embedded into the benchmark framework of paper "Online Object Tracking: A Benchmark" (CVPR2013) (You can find details here: http://visual-tracking.net/) or run on individual sequence.

To run the benchmark, just put the entire folder into the /trackers folder in the benchmark code base, and modify the configTrackers.m in util folder. DLT gets an AUC of 0.436, which ranks 5th among 26 in the benchmark by 19/03/2014. We don't tune parameters for single sequence in this case, all the parameters are stored in trackparam_DLT.m.

To run on individual video, you need to modify the dataPath and title in run_individual.m.

If you run MATLAB version after 2012, and have a CUDA compatible GPU installed, you may enjoy the fast computation speed by GPU, just set useGPU to true in trackparam_DLT.m and run_individual.m!

=================Acknowledgement==========
The codes are built on the "Incremental Visual Tracking" codes provided by David Ross.

Also the codes related to training of neural network, including offline training and online adaptation are modified from the DeepLearning Toolbox from: https://github.com/rasmusbergpalm/DeepLearnToolbox 

Thanks for the authors' sharing!