setup;
load allpyramidslvl3size200perm132;

[accuracies, all_confns, nb_accuracies, all_nb_confns] = test_no_base(allpyramids, 3, 'poly', 5);
save('/u/tomas/thesis/results/testnobase/acc_and_confn', accuracies, all_confns, nb_accuracies, all_nb_confns);
