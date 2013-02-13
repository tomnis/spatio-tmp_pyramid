function [accuracies] = bias_and_obj_type(bias_type, obj_type)
	load(['allpoolslvls2-3size100objtype', num2str(obj_type)]);
	accuracies = highlevel_pool_param(bias_type, 'poly', 5, allpools)
end
