function [stats] = compute_accuracy_stats(num_itrs, protate, spatial_cuts)
  setup
  
  show_confn = 0;
  % initially start_frame and end_frame set to dummy values
  dim = struct('start_frame', 1, 'end_frame', 1000, 'xlen', 1280, 'ylen', 960, 'protate', protate);
  dim.spatial_cuts = spatial_cuts;
  load loaded_data;
  
  % set empirically, found that 4 levels overflows memory but
  % if using a more space efficient representation could experiment with this more
  min_num_levels = 3;
  max_num_levels = 3;
  
  accuracy = [];
  
  for object_type = {'passive', 'active_passive'}
  	object_type = object_type{1}
  	dataset = DataSet(data, frs, best_scores, locations, object_type);
  
  	for num_levels = min_num_levels:max_num_levels
  		itr_acc = [];
  		% compute accuracy num_itrs different times given current state
  		for itr = 1:num_itrs
  			pool = make_pool(1, num_levels, protate);	
  			partition = pool{1};
  			hists = dataset.compute_histograms(partition, dim);
  			itr_acc= [itr_acc; train_and_test(dataset, hists, person_ids, show_confn)];
				clear hists;
  		end
  		accuracy = [accuracy itr_acc];
  	end
  end
  
  stats = struct('avg', [], 'stddev', [], 'min', [], 'max', []);
 	accuracy 
  for i=1:size(accuracy,2)
  	stats.avg(i) = mean(accuracy(:,i));
  	stats.stddev(i) = std(accuracy(:,i));
  	stats.min(i) = min(accuracy(:,i));
  	stats.max(i) = max(accuracy(:,i));
  end
end
