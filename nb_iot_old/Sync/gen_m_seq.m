function m_seq = gen_m_seq(n)
	h_table = {1, 1, 1, 1, 2, 1, 1, [6 5 1], 4, 3, 2, [7 4 3], [4 3 1], [12 11 1], 1, [5 3 2]};
	size = 2^n - 1;
	h = h_table{n};
	m_seq = zeros([1 size]);
	m_seq(size) = 1;
	for i = n:(size - 1)
		k = size - i;
		temp = m_seq(k + n);
		for j = 1:length(h)
			temp = xor(temp, m_seq(k + h(j)));
		end
		m_seq(k) = temp;
	end
	m_seq = flip(m_seq) * 2 - 1;
end
