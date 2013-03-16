function [] = lvl4pyramidsize300_mult_pats(trial_num)
load allpyramidslvl4size300perm132;
% we track trial numbers starting at zero, so account for this, but
% kinda dirty
[accuracies all_confns fs] = run_experiment_mult_pats(allpyramids, 3, 'poly', trial_num+1);
save(['/u/tomas/thesis/results/lvl4size300/trial', num2str(trial_num+1)], 'accuracies', 'all_confns', 'fs');
