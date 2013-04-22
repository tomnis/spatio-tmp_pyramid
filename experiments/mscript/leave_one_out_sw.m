function [] = leave_one_out_sw(savedir, pool, left_out_ind)
	setup;
	load loaded_data;
	object_type = 'active_passive';
	d = DataSet(data, frs, best_scores, locations, object_type);
	
  person_ids = [7:20]
	left_out_ind = left_out_ind +1;

	[accuracy, confn, f] = leave_one_out_single(d, pool, person_ids, left_out_ind);

	save([savedir, 'trial', num2str(left_out_ind)], 'accuracy', 'confn', 'f');
