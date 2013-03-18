function [combined]= combine_results(directory)

files = dir(directory);
files = files(3:end);
for i = 1:length(files)
	load([directory, '/', files(i).name]);
	combined.accuracies(i) = accuracies(length(accuracies));
	combined.confns(i, :, :) = all_confns{length(all_confns)}{1}{1}; 
	combined.fs{i} = fs{length(fs)}{1}{1};
end
