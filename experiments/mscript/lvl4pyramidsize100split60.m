function [] = lvl4pyramidsize100(trial_num)
load allpyramidslvl4size100
% we track trial numbers starting at zero, so account for this, but
% kinda dirty
[accuracies, all_confns, fs] = run_experiment(allpyramids, 3, 'poly', trial_num+1, 1);
save(['/u/tomas/thesis/results/split60/pyramidslvl4size100/', num2str(trial_num+1)], 'accuracies', 'all_confns', 'fs');
