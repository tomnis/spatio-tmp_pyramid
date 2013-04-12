function [] = leave_one_out_sw_noactive_vp(savedir, pool, left_out_ind)
	setup;
	load loaded_data;
	object_type = 'passive'
	d = DataSet(data, frs, best_scores, locations, object_type);
	
	left_out_ind = left_out_ind +1;

  pool = pool(1:70)

	[accuracy, confn, f] = leave_one_out_single_vp(d, pool, 7:20, left_out_ind);

	save([savedir, 'trial', num2str(left_out_ind)], 'accuracy', 'confn', 'f');
