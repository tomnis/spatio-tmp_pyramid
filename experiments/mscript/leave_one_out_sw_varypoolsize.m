% alternate version: call the boost version that has 5 boost rounds
% for pool vals in 1, 10.... 100
function [] = leave_one_out_sw_varypoolsize(savedir, pool, left_out_ind)
	setup;
	load loaded_data;
	object_type = 'active_passive';
	d = DataSet(data, frs, best_scores, locations, object_type);
	
	left_out_ind = left_out_ind +1;

  pool_sizes = [10:10:100];
  pool_sizes = [1, pool_sizes]
  
  accuracies = [];

  for i = 1:length(pool_sizes)
    pool_size = pool_sizes(i);
    % now get the first pool_size partitions
	  clear train_pool;
	  % get the first pool_size_for_train pools
		train_pool = pool(1:pool_size);
    train_pool
    length(train_pool)
  	[accuracy, confn, f] = leave_one_out_single_vp(d, train_pool, person_ids, left_out_ind);
    accuracies(i) = accuracy;
    confns{i} = confn;
  end
  % we dont care about f in this case
	save([savedir, 'trial', num2str(left_out_ind)], 'accuracies', 'confns');
