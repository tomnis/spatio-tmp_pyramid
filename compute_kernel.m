% given he feature histograms, compute the kernel to be used for svm training
function [K] = compute_kernel(hist1, hist2, type)
	hist1size = size(hist1)
	hist2size = size(hist2)

	if isequal(type, 'chisq')
		K = chi_sq_dist(hist1, hist2);
	elseif isequal(type, 'histintersect')
		K = hist_intersect(hist1, hist2);
	end

	K = [(1:size(K, 1))', K];



%% chi sq dist
function [K] = chi_sq_dist(hist1, hist2)
	K = zeros(size(hist1,1),size(hist2,1));
  
	for i=1:size(hist2,1)
	   d = bsxfun(@minus, hist1, hist2(i,:));
	   s = bsxfun(@plus, hist1, hist2(i,:));
	   K(:,i) = sum(d.^2 ./ (s/2+eps), 2);
	end
	K = 1 - K;



% histogram intersection
function [K] = hist_intersect(hist1, hist2)
	kr = size(hist1,1);
	kc = size(hist2,1);
	K = zeros(kr, kc);

	for i=1:size(K,1)
		for j=1:size(K,2)
			K(i,j) = sum(min(hist1(i,:), hist2(j,:)));
		end
	end
