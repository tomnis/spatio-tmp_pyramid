% num_prts lets us use control how many of the partitions are used
function [] = leave_one_out_sw_1vall(savedir, pool, left_out_ind, num_prts, num_boost_rounds)
	setup;
	load loaded_data;
	object_type = 'active_passive';
  person_ids = [7:20]
	d = DataSet(data, frs, best_scores, locations, object_type);
	
	left_out_ind = left_out_ind +1;

  
  if exist('num_prts')
    pool = pool(1:num_prts);
  end
  fprintf('pool size: %d\n', length(pool));
 
	[accuracy, confn, f] = leave_one_out_single_1vall(d, pool, person_ids, left_out_ind, num_boost_rounds);
  save([savedir, 'trial', num2str(left_out_ind)], 'accuracy', 'confn', 'f');
