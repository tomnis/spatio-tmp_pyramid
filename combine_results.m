function [combined_accuracies, all_confns] = combine_results(directory)

files = dir(directory);
files = files(3:end);

for i = 1:100
	if i == 16
		continue
	end
	if i == 52
		continue
	end
	if i == 94
		continue
	end
	load([directory, '/acc_and_confntrial', num2str(i)]);
	
	combined_accuracies(i) = accuracies(i)
end
