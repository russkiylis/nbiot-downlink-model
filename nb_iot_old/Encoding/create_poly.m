function poly = create_poly(powers)
	N = powers(1);
	poly = zeros([1 (N + 1)]);
	for i = 1:(N + 1)
		for j = 1:length(powers)
			if (N + 1) - i == powers(j)
				poly(i) = 1;
			end
		end
	end
end

