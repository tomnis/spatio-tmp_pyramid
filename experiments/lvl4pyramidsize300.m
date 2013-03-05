function [] = lvl4pyramidsize300(trial_num)
load allpyramidslvl4size300perm132;
% we track trial numbers starting at zero, so account for this, but
% kinda dirty
[accuracies all_confns] = run_experiment(allpyramids, 3, 'poly', trial_num+1);
save(['/u/tomas/thesis/results/allpyramidslvl4size300perm132trial', num2str(trial_num)], 'accuracies', 'all_confns');
