function result = freq_error(data)
	T = 13.52;
	x = 0:1/T:(length(data)/T-1/T);
	result = data .* exp(1i*2*pi*x);
end

