function [] = try_megapool_mult_pats(trial_num)
load megapool_almost_giga_tpyramids

% a bit of dirty hacking.. run experiment expects an extra level of nesting because of 
% bias type
allmegapools{1} = megapool;
allmegapoolss{1} = allmegapools;
[accuracies, all_confns, fs] = run_experiment_mult_pats(allmegapoolss, 1, 'poly', trial_num+1);
save(['/u/tomas/thesis/results/almost_gigapool_mult_pats/acc_and_confntrial', num2str(trial_num+1)], 'accuracies', 'all_confns', 'fs');
