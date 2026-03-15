function n_ports = check_crc_mask(syndrom)
	n_ports = -1;
	if ismember(0, syndrom == [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]) == 0
		n_ports = 1;
	elseif ismember(0, syndrom == [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]) == 0
		n_ports = 2;
	elseif ismember(0, syndrom == [0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1]) == 0
		n_ports = 4;
	end
end

