% leave one out train and test
function [accuracy, confn, f] = leave_one_out_single_1vall(dataset, pool, person_ids, left_out_ind, num_boost_rounds)
%%% leave one out train and test


	protate = 0;
	spatial_cuts = 1;
	dim = struct('start_frame', 0, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);


labels = unique(dataset.label);
n_label = length(labels);
assert(n_label == length(dataset.valid_labels));

conf = zeros(n_label, n_label);

left_out = person_ids(left_out_ind);

  f1 = find(dataset.person ~= left_out);
	traindata = dataset.sub(f1);
  y_train = traindata.label;
  
  f1 = find(dataset.person == left_out);
	testdata = dataset.sub(f1);
  y_test = testdata.label;


  % 4/3 we don't need this, sample repetition is also done in boost
  %{
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
  %}

	% train...
  pools{1} = pool;
	d = boost_main_1vall(pools, traindata, testdata, 'poly', dim, num_boost_rounds);
	
  conf1 = d.confns;

%confn = bsxfun(@rdivide, conf, sum(conf, 2) + eps); %% normalize the confusion matrix
%accuracy = sum(diag(confn)/sum(confn(:)))
confn = conf1;
accuracy = sum(diag(conf1)) / sum(conf1(:));
f = d.fs;
