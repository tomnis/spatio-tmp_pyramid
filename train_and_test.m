function [accuracy] = train_and_test(data, person_ids, show_confn)
%%% leave one out train and test

valid_labels = [1 2 3 4 5 6 9 10 12 13 14 15 17 20 22 23 24 27];

f1 = find(ismember(data.label, valid_labels));
data = sub(data, f1, 2);

labels = unique(data.label);
n_label = length(labels);
clear map1
map1(labels+1) = [1:n_label]; %% mapping the action labels to a new label set.

assert(n_label == length(valid_labels));

conf = zeros(n_label, n_label);

for left_out = person_ids
  f1 = find(data.person ~= left_out);
  x_train = data.feat(:, f1);
  y_train = data.label(:, f1);
  y_train = map1(y_train+1);
  
  f1 = find(data.person == left_out);
  x_test = data.feat(:, f1);
  y_test = data.label(:, f1);
  y_test = map1(y_test+1);

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
  x_train1 = x_train(:, f3);
  y_train1 = y_train(:, f3);

 	size(y_train) 
 	size(y_train1) 
  
	svm1 = svmtrain(y_train1', x_train1', '-c 1 -t 0');
  y_pred = svmpredict(y_test', x_test', svm1);
  
  conf1 = zeros(n_label, n_label);
  
  for j = 1:length(y_test)
    conf1(y_test(j), y_pred(j)) = conf1(y_test(j), y_pred(j)) + 1;
  end
  conf = conf + conf1;
  [left_out sum(diag(conf1))/sum(conf1(:))]
end

confn = bsxfun(@rdivide, conf, sum(conf, 2) + eps); %% normalize the confusion matrix
accuracy = sum(diag(confn)/sum(confn(:)))

if show_confn
	imagesc(confn)
	colormap gray
end
