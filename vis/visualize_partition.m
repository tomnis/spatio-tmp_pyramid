% given a partition, plot all the planes
function [] = visualize_partition(partition, spatial_cuts)

% apply the partition to a dummy space
cut_eqs = apply_partition(partition, 1280, 960, 1, 1000, spatial_cuts);

% we want an array of plane functions to plot
eqs_to_plot = [];
syms x y z;

for lvl = 1:length(cut_eqs)
	level_eqs = cut_eqs(lvl);

	for c = 1:length(level_eqs)



end


function [zplane] = get_zplane(cut
