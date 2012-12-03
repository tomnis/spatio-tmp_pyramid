% given the data struct and a selection of indices,
% select only those indices to make a new struct
% TODO pretty hacky at this point
function [newdata] = applysplit(data, inds)
	newdata.person = data.person(inds);
	newdata.fr_start = data.fr_start(inds);
	newdata.fr_end = data.fr_end(inds);
	newdata.label = data.label(inds);
	newdata.frs = data.frs(inds);
	newdata.best_s_active = data.best_s_active(inds);
	newdata.best_s_passive = data.best_s_passive(inds);
	newdata.best_s = data.best_s(inds);
	newdata.locs = data.locs(inds);
