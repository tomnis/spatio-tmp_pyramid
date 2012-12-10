setup
addpath ADL_code
load tempfile
whos
train_frac = .6;


valid_labels = [1 2 3 4 5 6 9 10 12 13 14 15 17 20 22 23 24 27];

f1 = find(ismember(data.label, valid_labels));
data = sub(data, f1, 2);

[train_inds test_inds] = split(data, train_frac);
[orig_accuracy orig_confn] = orig_method_split(train_inds, test_inds, data, frs, best_s_active, best_s_passive);

[stats] = boost_main(50, 5, train_inds, test_inds);

