% leave one out train and test
function [accuracy confn] = leave_one_out(dataset, pool, person_ids)
%%% leave one out train and test


	protate = 0;
	spatial_cuts = 1;
	dim = struct('start_frame', 0, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);


labels = unique(dataset.label);
n_label = length(labels);
assert(n_label == length(dataset.valid_labels));

conf = zeros(n_label, n_label);

for left_out = person_ids
  f1 = find(dataset.person ~= left_out);
	traindata = dataset.sub(f1);
  y_train = traindata.label;
  
  f1 = find(dataset.person == left_out);
	testdata = dataset.sub(f1);
  y_test = testdata.label;

  %%% repeat samples to be balanced
  f3 = [];
  for i = 1:n_label
    f1 = find(y_train == i);
    f1_n = length(f1);
    if f1_n == 0
      continue
    end
    
    f2 = repmat(f1, [1 ceil(100/f1_n)]);
    f3 = [f3 f2(1:100)];
  end
	traindata = traindata.sub(f3);

	% train...
	f = boost(traindata, pool, .8, dim, 1);
	% get application of each partition scheme to be used by the classifier
	for pat_ind = 1:length(f.min_pat_inds)
		pool_num = f.min_pat_inds(pat_ind);
		partition = pool{pool_num};
		partitioned_feats{pool_num} = testdata.compute_histograms(partition, dim); 
	end


	% now test
	y_pred = strong_classify_all(f, partitioned_feats, dataset.valid_labels);
	
  conf1 = zeros(n_label, n_label);
  
  for j = 1:length(y_test)
    conf1(y_test(j), y_pred(j)) = conf1(y_test(j), y_pred(j)) + 1;
  end
  conf = conf + conf1;
  [left_out sum(diag(conf1))/sum(conf1(:))]
	clear partitioned_feats;
end

confn = bsxfun(@rdivide, conf, sum(conf, 2) + eps); %% normalize the confusion matrix
accuracy = sum(diag(confn)/sum(confn(:)))
