function [] = lvl4pyramidsize100_1vall(trial_num, bias_type)
load allpyramidslvl4size100
% we track trial numbers starting at zero, so account for this, but
% kinda dirty
[accuracies, all_confns, fs] = run_experiment_1vall(allpyramids, bias_type, 'poly', trial_num+1);
save(['/u/tomas/thesis/results/biastype', num2str(bias_type), '/pyramidslvl4size100_1vall/', num2str(trial_num+1)], 'accuracies', 'all_confns', 'fs');
