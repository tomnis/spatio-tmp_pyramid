pool_size = 1;
num_levels = 3;
protate = 0;
spatial_cuts = 1;

% create the partition pool
pool = make_pool(pool_size, num_levels, protate);

eqs_to_plot = visualize_partition(pool{1}, spatial_cuts);

ezmesh(eqs_to_plot(1), 400)
colormap([0 0 1])

%{

fh = @(x,y) x.*exp(-x.^2-y.^2);
ezmesh(fh,40)
%}
