function [confn] = confusion(actual, predicted, totalnumlabels)
  confn = zeros(totalnumlabels);
  
  assert(length(actual) == length(predicted));

  for i=1:length(actual)
    confn(actual(i), predicted(i)) = confn(actual(i), predicted(i)) + 1;
  end
