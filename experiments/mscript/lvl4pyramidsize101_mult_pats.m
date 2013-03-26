function [] = lvl4pyramidsize101_mult_pats(trial_num)
load allpyramidslvl4size100andR
% we track trial numbers starting at zero, so account for this, but
% kinda dirty
[accuracies, all_confns, fs] = run_experiment_select_first_mult_pats(allpyramids, 3, 'poly', trial_num+1);
save(['/u/tomas/thesis/results/pyramidslvl4size101multpats/', num2str(trial_num+1)], 'accuracies', 'all_confns', 'fs');
