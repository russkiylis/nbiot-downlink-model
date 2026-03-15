function result = repeat(arr, n)
	result = zeros([1 (length(arr) * n)]);
	for i = 0:(n - 1)
		result((i * length(arr) + 1):((i + 1) * length(arr))) = arr;
	end
end

