function [] = lvl4pyramidsize300split60(trial_num)
load allpyramidslvl4size300perm132;
% we track trial numbers starting at zero, so account for this, but
% kinda dirty
[accuracies all_confns] = run_experiment(allpyramids, 3, 'poly', trial_num+1,1);
save(['/u/tomas/thesis/results/split60/pyramidslvl4size300', num2str(trial_num)], 'accuracies', 'all_confns');
