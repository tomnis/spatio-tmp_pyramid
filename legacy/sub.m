function ss  = sub(s, I, D)
% s = sub(s,I)
% Returns a subset of the structure s

if ~exist('D')
  D = 1;
end

if ~isempty(s),
  n = fieldnames(s);
  for i = 1:length(n),
    f = n{i};
    if isequal(class(s.(f)), 'double')
      if D == 1
        ss.(f) = s.(f)(I, :);
      elseif D == 2
        ss.(f) = s.(f)(:, I);
      end
    elseif isequal(class(s.(f)), 'cell')
      if D == 1
        for j = 1:length(I)
          ss.(f){j, 1} = s.(f){I(j), 1};
        end
      elseif D == 2
        for j = 1:length(I)
          ss.(f){1, j} = s.(f){1, I(j)};
        end
      end
    end
  end
end

