setup;
load allpyramidslvl4size300perm132;
[accuracies all_confns] = run_experiment(allpyramids, 3, 'poly', 10);
save('/u/tomas/thesis/results/allpyramidslvl4size300perm132', 'accuracies', 'all_confns');
