function output = selector(input, E)
	output = zeros([1 E]);
	Kw = length(input);

	k = 1;
	j = 1;
	while (k <= E)
		if ~isnan( input( mod(j, Kw) + 1 ) )
			output(k) = input( mod(j, Kw) + 1 );
			k = k + 1;
		end
		j = j + 1;
	end
end

