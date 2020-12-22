startup;

trackers = configTrackers;
sequences = configSeqs;

trackers = trackers(1:end);
sequences = sequences(1:end);

% perform OPE on the whole benchmark
%OPE_evaluate(sequences, trackers);

% evaluate the results
OPE_perfmat(sequences, trackers);

% draw performance plots
OPE_drawplot(sequences, trackers);

