clear
addpath third_party/libsvm-mat-3.0-1
path0 = '~/ADLdataset/';  %% root directory

% person_ids = [1:6];  %% persons used in action recognition
person_ids = [7:20];  %% persons used in action recognition

path1 = [path0 'ADL_annotations/action_annotation/'];     %% action annottaion
path2 = [path0 'ADL_detected_objects/testset/active/'];   %% detected active objects
path3 = [path0 'ADL_detected_objects/testset/passive/'];  %% detected passive objects

%feat_type = 'pyramid';
 feat_type = 'bag';

%object_type = 'active_passive';
object_type = 'passive';

%%% reading action annottaion
%%% data.X(i) corresponds to one presegmented video clip

%[data best_s_active best_s_passive frs objects_active objects_passive] = read_data(person_ids, path1, path2, path3);
% save temp_file data best_s_active best_s_passive frs
 load tempfile

%%% assigning best scores to each pre-segmented data point (clip)
for k = 1:length(data.label)
  i = data.person(k);
  f1 = find((frs{i} > data.fr_start(k)) .* (frs{i} < data.fr_end(k)));
  
  data.frs{1, k} = frs{i}(f1);
  
  data.best_s_active{1, k} = best_s_active{i}(:, f1);
  data.best_s_active{1, k} = data.best_s_active{1, k} + 0.7;
  data.best_s_active{1, k}(data.best_s_active{1, k} < 0) = 0;
  
  data.best_s_passive{1, k} = best_s_passive{i}(:, f1);
  data.best_s_passive{1, k} = data.best_s_passive{1, k} + 0.35;
  data.best_s_passive{1, k}(data.best_s_passive{1, k} < 0) = 0;
  
  if isequal(object_type, 'active_passive')
    data.best_s{1, k} = [data.best_s_active{1, k}; data.best_s_passive{1, k}];  %% active + passive objects
  elseif isequal(object_type, 'passive')
    data.best_s{1, k} = [data.best_s_passive{1, k}];  %% passive objects only
  end
end

%%% calculating features
for k = 1:length(data.label)
  
  n_frs = length(data.frs{1, k});
  
  if isequal(feat_type, 'bag')
    data.feat(:, k) = sum(data.best_s{k}, 2) / n_frs;
  elseif isequal(feat_type, 'pyramid')
    mid_fr = (data.fr_start(1, k) + data.fr_end(1, k))/2;
    f1 = find(data.frs{1, k} < mid_fr);
    f2 = find(data.frs{1, k} >= mid_fr);
    data.feat(:, k) = [sum(data.best_s{k}, 2); sum(data.best_s{k}(:, f1), 2); sum(data.best_s{k}(:, f2), 2)] / n_frs;
  end
  
end
data.feat = bsxfun(@rdivide, data.feat, sum(data.feat, 1) + eps); %% normalizing

thr = 0.01;
data.feat(data.feat > thr) = thr;   %% clipping features

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

imagesc(confn)
colormap gray
