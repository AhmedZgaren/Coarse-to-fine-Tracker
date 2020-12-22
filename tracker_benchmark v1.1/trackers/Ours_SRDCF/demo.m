
% This demo script runs the SRDCF tracker on the included "Couple" video.

% Load video information
video_path = 'D:/data_seq/OTB100/Couple';
[seq, ~] = load_video_info(video_path);

% Run SRDCF
results = run_Ours_SRDCF(seq);