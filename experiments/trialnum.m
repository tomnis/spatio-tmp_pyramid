setup;
load megapoollvl3-4unequal;

% a bit of dirty hacking.. run experiment expects an extra level of nesting because of 
% bias type
allmegapools{1} = megapool;
allmegapoolss{1} = allmegapools;

[accuracies, all_confns] = run_experiment_trialnum(allmegapoolss, 3, 'poly', trial_num+1);
save(['/u/tomas/thesis/results/trialnum/acc_and_confn', num2str(trial_num+1)], 'accuracies', 'all_confns');
accuracies
