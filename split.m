% given the datapoints
%				a scalar specifying what fraction of the data should be selected for training
% select a subset to be used as training data
% the other subset is used as t
% return 
function [traininds testinds] = split(data, train_frac)
	assert( 0 <= train_frac && train_frac <= 1)
	traininds = [];
	testinds = [];

	% get all the unique labels
	uniq_labels = unique(data.label);

	for	i = 1:length(uniq_labels)
		% get all the clips with label i
		cur_label = uniq_labels(i);
		clips_with_label = find(data.label == cur_label);

		% only one clip with this label type
		if length(clips_with_label) == 1
			continue;
		end
		
		% how many clips with this label should we select?
		num_sampledclips = round(train_frac * length(clips_with_label));

		if num_sampledclips == length(clips_with_label)
			num_sampledclips = num_sampledclips -1
		end
		
		% get a sample to use
		sampled_inds = sort(randsample(length(clips_with_label), num_sampledclips));
		not_sampled_inds = setdiff([1:length(clips_with_label)], sampled_inds);

		train_inds_from_data = clips_with_label(sampled_inds);
		test_inds_from_data = clips_with_label(not_sampled_inds);

		% sanity check that we only select clips that have the correct label type
		assert(length(find(data.label(train_inds_from_data) ~= cur_label)) == 0);
		assert(length(train_inds_from_data) > 0);
		assert(length(find(data.label(test_inds_from_data) ~= cur_label)) == 0);
		assert(length(test_inds_from_data) > 0);

		traininds = [traininds train_inds_from_data];
		testinds = [testinds test_inds_from_data];
	end
