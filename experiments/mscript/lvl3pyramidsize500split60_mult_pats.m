function [] = lvl3pyramidsize500split60_mult_pats(trial_num)
load allpyramidslvl3size500perm132
% we track trial numbers starting at zero, so account for this, but
% kinda dirty
[accuracies, all_confns, fs] = run_experiment_mult_pats(allpyramids, 3, 'poly', trial_num+1, 1);
save(['/u/tomas/thesis/results/split60/pyramidslvl3size500multpats/', num2str(trial_num+1)], 'accuracies', 'all_confns', 'fs');
