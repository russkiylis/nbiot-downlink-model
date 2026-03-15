function dec = barr2dec(arr)
	arr = flip(arr);
	dec = 0;
	for i = 0:(length(arr)-1)
		dec = dec + arr(i + 1)*2^i;
	end
end

