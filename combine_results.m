function [combined_accuracies, all_confns] = combine_results(directory)

files = dir(directory);
files = files(3:end);

for i = 1:length(files)
	load([directory, '/acc_and_confntrial', num2str(i)]);
	
	combined_accuracies(i) = accuracies(i)
end
