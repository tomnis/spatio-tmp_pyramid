% call this to use the boosing classifier
% pools is cell array of pools
% traindata is a DataSet object
% testdata is a DataSet object
% kernel_type is 'poly', 'chisq', 'histintersect'
function [d] = boost_main_1vall(pools, traindata, testdata, kernel_type, dim, num_rounds)
	num_itrs = length(pools);
  fprintf(1, '1vall mode enabled\n');

	target_accuracy = .9;
  if ~exist('num_rounds')
    num_rounds = 30;
  end
  
  
  n_label = length(unique(traindata.label));
  orig_label = traindata.label;

	accuracies = [];
  disp (['boost_main trial ' num2str(1) ' of ' num2str(num_itrs)]);
  % create the partition pool
  pool = pools{1};
  
  % create boosted binary classifiers for each class vs the rest
  for c = 1:n_label
    fprintf(1, '(training for %d)\n', c); 
    % get the relevant training data
    ctraininds = find(orig_label == c);
    resttraininds = find(orig_label ~= c);
    
    traindata.label(ctraininds) = 1;
    traindata.label(resttraininds) = -1;

    [f, partitioned_feats] = boost_1vall(traindata, pool, target_accuracy, dim, kernel_type, num_rounds);
    classifiers{1}{c} = f;
    prt_fts{1}{c} = partitioned_feats;
  end
  fprintf(1, '\ndone creating classifiers');
  
  % restore the original labels
  traindata.label = orig_label;
  % now for each training point,
  % classify using each of the binary classifiers
  % concatenate the output of each of the binary classifiers
  % to form a new vector, to train the 'hack svm'
  d_train = zeros(n_label, traindata.num_clips);
  for c=1:n_label
     strong_classifications = strong_classify_all(classifiers{1}{c}, prt_fts{1}{c}, [-1,1]);
     d_train(c,:) = strong_classifications;
  end
  % train the 'hack svm'
  fprintf(1, '\nready to train the hack svm');
  x_train = d_train;
  y_train = traindata.label;
  %%% repeat samples to be balanced
  f3 = [];
  for j = 1:n_label
    l = traindata.label(j);
    f1 = find(y_train == l);
    f1_n = length(f1);
    if f1_n == 0
      continue
    end
    
    f2 = repmat(f1, [1 ceil(100/f1_n)]);
    f3 = [f3 f2(1:100)];
  end

  % select the training examples to use
  x_train1 = x_train(:, f3);
  y_train1 = y_train(:, f3);
  
  x_train1 = x_train;
  y_train1 = y_train;

  if isequal(kernel_type, 'poly')
    fprintf(1, ' training... (polynomial kernel,  ex:%d) ', length(y_train1));
    svm = svmtrain(y_train1', x_train1', '-c 1 -t 0 -q');
  else 
    fprintf(1, ' precomputing %s kernel...', kernel_type);
    K = compute_kernel(x_train1', x_train1', kernel_type);
    fprintf(1, ' training... (ex:%d)', length(y_train1));
    trains{prt_num} = x_train1;
    svm = svmtrain(y_train1', K, '-q -t 4');
  end
  
  % we don't need these anymore
  clear prt_fts;
  clear d_train;

  % now test (we need the classifications from all the binary classifiers to form
  % the new vectors
  d_test = zeros(n_label, testdata.num_clips);
  for c = 1:n_label
    f = classifiers{1}{c};
    % get application of each partition scheme to be used by the classifier
    % todo this can be made more efficient
    % this is also compute in boost.m i believe
    for pat_ind = 1:length(f.min_pat_inds)
      pool_num = f.min_pat_inds(pat_ind);
      partition = pool{pool_num};
      partitioned_feats{pool_num} = testdata.compute_histograms(partition, dim); 
    end

    d_test(c, :) = strong_classify_all(f, partitioned_feats, [-1,1], testdata.num_clips);
    fs{1}{c} = f;
  end 
 
  x_test = d_test;
  y_test = testdata.label;
  dtestsize = size(d_test)
  ytestsize = size(y_test) 
  strong_classifications = svmpredict(y_test', x_test', svm);
  % need strong classifications here

  strong_classifications = strong_classifications';
  assert(isequal(size(strong_classifications), size(testdata.label)));
  strong_class_indicator = (strong_classifications == testdata.label);
  boost_main_accuracy = mean(strong_class_indicator)
  accuracies = boost_main_accuracy;
  confn = confusionmat(testdata.label, strong_classifications);
  clear partitioned_feats;
  
  f = {};
	d.accuracies = accuracies;
	d.confns = confn;
  for i=1:length(fs{1})
    f{i}.min_pat_inds = fs{1}{i}.min_pat_inds;
  end
	d.fs = f;
