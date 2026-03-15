function result = phase_noise(data)
	result = data .* exp(1i*((rand(size(data))-0.5)/5));
end

