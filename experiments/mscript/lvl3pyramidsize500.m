function [] = lvl3pyramidsize500(trial_num)
load allpyramidslvl3size500perm132
% we track trial numbers starting at zero, so account for this, but
% kinda dirty
[accuracies, all_confns, fs] = run_experiment(allpyramids, 3, 'poly', trial_num+1);
save(['/u/tomas/thesis/results/pyramidslvl3size500/', num2str(trial_num+1)], 'accuracies', 'all_confns', 'fs');
