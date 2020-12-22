function OPE_drawplot(sequences, trackers)
% perfmat (nTrk, nSeq) cell of [1 x nPts]

evalType = 'OPE';

toolkit_path = get_global_variable('toolkit_path');
results_path = fullfile(toolkit_path, 'results', evalType);
perfmat_path = fullfile(toolkit_path, 'perfmat', evalType);
figure_path = fullfile(toolkit_path, 'figs', evalType);

nseq = length(sequences);
ntrk = length(trackers);

thresholdSetOverlap = 0:0.05:1;
thresholdSetError = 0:50;

% load the perfmat
perfmat_file = fullfile(perfmat_path, ['perfplot_curves_' evalType 'full.mat']);
load(perfmat_file); %'success_curve','precision_curve','nameTrkAll'

% Ranking the trackers
AUC = cellfun(@mean, success_curve);
AUC = mean(AUC, 2); % the AUC of each tracker
for itrk = 1:ntrk
    nameTrkAll{itrk} = [nameTrkAll{itrk} ' [' num2str(AUC(itrk),'%.3f') ']'];
end
[~, rank] = sort(AUC, 'descend');


% cell2array
success = reshape(cell2mat(success_curve), ntrk, length(thresholdSetOverlap), nseq);
precision = reshape(cell2mat(precision_curve), ntrk, length(thresholdSetError), nseq);
success = squeeze(mean(success,3));
precision = squeeze(mean(precision,3));


h = figure; hold on;
for itrk = rank'
    plot(thresholdSetOverlap, success(itrk,:), 'lineWidth', 2); hold on;
end

legend(nameTrkAll(rank));
title('Success plot of OPE','fontsize',16);
xlabel('Overlap threshold','fontsize',16);
ylabel('Success rate','fontsize',16);
saveas(h,fullfile(figure_path),'tiff');
hold off;
h1= figure; hold on;
for itrk =1:9
    plot(thresholdSetError, precision(itrk,:), 'lineWidth', 2); hold on;
end

legend(nameTrkAll());
title('Precision plot of OPE','fontsize',16);
xlabel('Location error threshold','fontsize',16);
ylabel('Precision','fontsize',16);
saveas(h1,fullfile(figure_path),'tiff');

end

