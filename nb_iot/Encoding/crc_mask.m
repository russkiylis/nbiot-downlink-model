function crc = crc_mask(crc, n_ports)
	if n_ports == 2
		crc = xor(crc, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
	elseif n_ports == 4
		crc = xor(crc, [0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1]);
	end
end

