setup;
load megapoolequal

% a bit of dirty hacking.. run experiment expects an extra level of nesting because of 
% bias type
allmegapools{1} = megapool;
allmegapoolss{1} = allmegapools;
[accuracies, all_confns] = run_experiment(allmegapoolss, 1, 'poly', 10);
save('/u/tomas/thesis/results/megapool/acc_and_confn', 'accuracies', 'all_confns');
accuracies
