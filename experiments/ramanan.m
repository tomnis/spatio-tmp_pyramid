function [accuracies] = ramanan(kernel_type, num_trials)
	setup
	load loaded_data

	object_type = 'active_passive';
	dataset = DataSet(data, frs, best_scores, locations, object_type);
	n_label = length(unique(dataset.label));

	protate = 0;
	spatial_cuts = 1;
	dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);

	load split
	load allpools


	for i=1:num_trials
		disp (['trial ' num2str(i) ' of ' num2str(num_trials)])
		
		rhists = dataset.compute_ramanan_histograms('pyramid');
		x_train = rhists(:, split.train{i});
		y_train = dataset.label(:, split.train{i});
		
		%%% repeat samples to be balanced
		f3 = [];
		for j = 1:n_label
			f1 = find(y_train == j);
			f1_n = length(f1);
			if f1_n == 0
				continue
			end
				
			f2 = repmat(f1, [1 ceil(100/f1_n)]);
			f3 = [f3 f2(1:100)];
		end
		
		%select the training examples to use
		x_train = x_train(:, f3);
		y_train = y_train(:, f3);
		
		if isequal(kernel_type, 'poly')
 			disp 'training with polynomial kernel...'
 		  svm = svmtrain(y_train', x_train', '-c 1 -t 0 -q');
		else 
			disp (['precomputing the ' kernel_type ' kernel...']);
			K = compute_kernel(x_train', x_train', kernel_type);
 			disp 'training...'
			svm = svmtrain(y_train', K, '-q -t 4');
		end
		disp 'done.'

		x_test = rhists(:, split.test{i});
		y_test = dataset.label(:, split.test{i});

		if isequal(kernel_type, 'poly')
			y_pred = svmpredict(y_test', x_test', svm);
		else
			xtest = compute_kernel(x_test', x_train', kernel_type);
			y_pred = svmpredict(y_test', xtest, svm);
		end

		ind = (y_pred' == y_test);
		acc = mean(ind)
		accuracies(i) = acc;
	end

	mean(accuracies)
