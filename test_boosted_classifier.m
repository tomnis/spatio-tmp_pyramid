setup
load tempfile

whos
labels = unique(data.label);
n_label = length(labels);
clear map1
map1(labels+1) = [1:n_label]; %% mapping the action labels to a new label set.
new_labels = map1(data.label+1);

% assume f is already in scope, that is, boosting has already been run
% maybe refactor this later
[max_acc, ind] = max(f.accuracies);

alpha = f.alpha(ind);
min_class_classifiers = f.min_class_classifiers(ind);

classified_labels = strong_classify_all(alpha, min_class_classifiers, data, new_labels);
