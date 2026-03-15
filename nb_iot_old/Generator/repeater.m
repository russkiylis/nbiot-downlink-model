function result = repeater(signal, fs, offset, period, qty)
	len = round(offset*fs + period*qty*fs);
	result = zeros([1 len]);
	for i=1:qty
		begin = round(offset*fs + period*fs*(i-1));
		if begin+length(signal) >= len
			result(( begin + 1 ):end) = result((begin + 1):end) + signal(1:(len - begin));
			result = [result signal((len - begin + 1):end)];
		else
			result(( begin + 1 ):( begin+length(signal) )) = result((begin + 1):(begin+length(signal))) + signal;
		end
	end
end
