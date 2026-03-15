function seq = zc_seq(N_zc, q, l)
	n = 0:(N_zc - 1);
	if mod(N_zc, 2) == 0
		seq = exp(-1i*2*pi*q*((n.^3)/2 + l*n)/N_zc);
	else
		seq = exp(-1i*2*pi*q*((n.*(n + 1))/2 + l*n)/N_zc);
    end
end

