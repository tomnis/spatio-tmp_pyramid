load tempfile

partitions = rand(15, 1)
target_accuracy = .95;


f = boost(data, partitions, target_accuracy);
