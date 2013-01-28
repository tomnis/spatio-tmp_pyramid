% compute the training error. 
% similar to calling boost_main with all indices
function [stats] = compute_boost_stats(pool_size, num_itrs, bias_type, kernel_type)

  setup
  load loaded_data
 

 	regular = 0;
  num_levels = 3;
  protate = 0;
  target_accuracy = .8;
  object_type = 'active_passive';
  spatial_cuts = 1;
  dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate, 'spatial_cuts', spatial_cuts);
	should_boost = 1;
  
  dataset = DataSet(data, frs, best_scores, locations, object_type);
  
	stats = struct('avg', [], 'stddev', [], 'min', [], 'max', []); 
  max_accuracies = [];

	bias = 0;


	if bias
		distr = dataset.compute_obj_distrs(10);
	else
		distr.bx = [];
		distr.by = [];
		distr.bz = [];
	end


	distr
	randrs.x = RandDistr(distr.bx);
	randrs.y = RandDistr(distr.by);
	randrs.z = RandDistr(distr.bz);
  
  for i=1:num_itrs
  	pool = make_pool(pool_size, num_levels, protate, regular, randrs);
  	f = boost(dataset, pool, target_accuracy, dim, kernel_type);
  	max_accuracies = [max_accuracies max(f.accuracies)];
  end
 
 	stats.max_accuracies = max_accuracies;
  stats.avg = mean(max_accuracies);
  stats.stddev = std(max_accuracies);
  stats.min = min(max_accuracies);
  stats.max = max(max_accuracies);
end
