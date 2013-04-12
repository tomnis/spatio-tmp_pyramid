% use the ground truth annotations from the adl dataset
function [accuracy confn] = leave_one_out_gt()
  setup;
  load loaded_data_gt;
  person_ids = 7:20

  object_type = 'active_passive';
  d = DataSet(data, frs, best_scores, locations, object_type, 0);
  
  n_label = length(unique(d.label));

  conf = zeros(n_label, n_label);

  feat = d.compute_ramanan_histograms('pyramid');

  size(feat)
  person_ids
  
  for left_out = person_ids
    f1 = find(d.person ~= left_out);
    x_train = feat(:, f1);
    y_train = d.label(:, f1);
    
    f1 = find(d.person == left_out);
    x_test = feat(:, f1);
    y_test = d.label(:, f1);
    
    %%% repeat samples to be balenaced
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
    x_train1 = x_train(:, f3);
    y_train1 = y_train(:, f3);
    
    svm1 = svmtrain(y_train1', x_train1', '-c 1 -t 0');
    y_pred = svmpredict(y_test', x_test', svm1);
    
    conf1 = zeros(n_label, n_label);
    
    for j = 1:length(y_test)
      conf1(y_test(j), y_pred(j)) = conf1(y_test(j), y_pred(j)) + 1;
    end
    conf = conf + conf1;
    [left_out sum(diag(conf1))/sum(conf1(:))]
  end

confn = bsxfun(@rdivide, conf, sum(conf, 2) + eps); %% normalize the confussin matrix
accuracy = sum(diag(confn)/sum(confn(:)))
