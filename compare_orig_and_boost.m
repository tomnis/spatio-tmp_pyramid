addpath ADL_code
load tempfile
whos
train_frac = .6;
[train_inds test_inds] = split(data, train_frac);
[accuracy confn] = orig_method_split(train_inds, test_inds, data, frs, best_s_active, best_s_passive);
