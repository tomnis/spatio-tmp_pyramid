function [] = try_megapool(trial_num)
load allpyramidslvl4size100

% a bit of dirty hacking.. run experiment expects an extra level of nesting because of 
% bias type
allmegapools{1} = megapool;
allmegapoolss{1} = allmegapools;
[accuracies, all_confns, fs] = run_experiment_checkpools(allmegapoolss, 1, 'poly', trial_num+1);
save(['/u/tomas/thesis/results/pyramidslvl4size100/acc_and_confntrial', num2str(trial_num+1)], 'accuracies', 'all_confns', 'fs');
