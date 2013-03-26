% combine the results from a leave one out run
function [combined]= combine_loo_results(directory)

files = dir(directory);
files = files(3:end);
for i = 1:length(files)
	load([directory, '/', files(i).name]);
	combined.accuracies(i) = accuracy;
	combined.confns(i, :, :) = confn;
	combined.fs{i} = f;
end
mean_acc = mean(combined.accuracies)
