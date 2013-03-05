function [] = try_gigapool(trial_num)
load gigapool

% a bit of dirty hacking.. run experiment expects an extra level of nesting because of 
% bias type
allgigapools{1} = gigapool;
allgigapoolss{1} = allgigapools;
[accuracies, all_confns] = run_experiment(allgigapoolss, 1, 'poly', trial_num+1);
save(['/u/tomas/thesis/results/gigapool/acc_and_confntrial', num2str(trial_num+1)], 'accuracies', 'all_confns');
