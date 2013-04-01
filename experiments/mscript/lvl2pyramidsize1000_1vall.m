function [] = lvl2pyramidsize1000_1vall(trial_num)
load allpyramidslvl2size1000perm132 
% we track trial numbers starting at zero, so account for this, but
% kinda dirty
[accuracies, all_confns, fs] = run_experiment_1vall(allpyramids, 3, 'poly', trial_num+1);
save(['/u/tomas/thesis/results/pyramidslvl2size1000/', num2str(trial_num+1)], 'accuracies', 'all_confns', 'fs');
