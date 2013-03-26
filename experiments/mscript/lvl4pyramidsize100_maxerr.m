function [] = lvl4pyramidsize100_maxerr(trial_num, biastype)
load allpyramidslvl4size100
% we track trial numbers starting at zero, so account for this, but
% kinda dirty
[accuracies, all_confns, fs] = run_experiment_maxerr(allpyramids, biastype, 'poly', trial_num+1);
save(['/u/tomas/thesis/results/maxerr/b', num2str(biastype), '/pyramidslvl4size100/', num2str(trial_num+1)], 'accuracies', 'all_confns', 'fs');
