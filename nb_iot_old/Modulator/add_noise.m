function result = add_noise(data)
	result = data + ((rand(size(data))-0.5) + 1i*(rand(size(data))-0.5))/5;
end
