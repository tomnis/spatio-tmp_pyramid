function [] = leave_one_out_sw_gt(savedir, pool, left_out_ind)
	setup;
	load loaded_data_gt;
  fprintf(1, 'using adl ground truth\n');
	object_type = 'active_passive';
	d = DataSet(data, frs, best_scores, locations, object_type);
	
	left_out_ind = left_out_ind +1;
  %pool = pool(1)
  pool = pool(1:50)
	[accuracy, confn, f] = leave_one_out_single(d, pool, [7:20], left_out_ind);

	save([savedir, 'trial', num2str(left_out_ind)], 'accuracy', 'confn', 'f');
