function [] = leave_one_out_sw_ga_vp(savedir, pool, left_out_ind)
	setup;
	load loaded_gatech;
	object_type = 'active'
  fprintf(1, 'using gatech dataset, limited boosting rounds\n');
	d = DataSet(data, frs, best_scores, locations, object_type);
	
	left_out_ind = left_out_ind +1;

	[accuracy, confn, f] = leave_one_out_single_vp(d, pool, [1:3], left_out_ind);

	save([savedir, 'trial', num2str(left_out_ind)], 'accuracy', 'confn', 'f');
