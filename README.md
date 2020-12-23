# Coarse-to-fine-Object-Tracking-using-Deep-Features-and-Correlation-Filters

This is the official code release for the paper : Zgaren A., Bouachir W., Ksantini R. (2020) Coarse-to-Fine Object Tracking Using Deep Features and Correlation Filters. In: Bebis G. et al. (eds) Advances in Visual Computing. ISVC 2020. Lecture Notes in Computer Science, vol 12509. Springer, Cham. 

You can access it via arxiv: []()

For any questions or queries, please contact Ahmed Zgaren: ahmed.zgaren84@gmail.com

# Prerequisites

* Matlab R2018a
* Neural Network Toolbox
* VGG16 model
* OpenCV

# Dataset

The dataset used in the paper is from CVlab. It can be dowloaded from [here](http://cvlab.hanyang.ac.kr/tracker_benchmark/datasets.html)

# Getting Started

It is highly recommended to have a machine equipped with a GPU to speed up the tracking result. ( ~6 frame/s)

* Download the dataset
* Modify the file: configSeqs.m
  * on the OTB100 struct.
  * change the path for each sequence ( add your local path where you stored the dataset).
* Results (.mat) for each sequence are stored in the folder: results/results_OPE.
* To execute the tracker, run the file: main_running.m.
* To change the tracker parameters, access the file: tracker_benchmark v1.1\trackers\Ours_SRDCF\run_OURS_SRDCF.m

  
