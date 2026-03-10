function [result, err] = crc_16(seq)
	N = 16;
	% Задание порождающего полинома
	g_crc16 = [16 12 5 0];
	p = create_poly(g_crc16);
	% Дополнение кодовой последовательности нулями в конце
	seq = [seq zeros([1 N])];
	
	window = seq(1:(N + 1));
	i = N + 2;
	err = zeros([1 N]);
	while i <= length(seq)
		% Проверка первого элемента регистра на 0
		if window(1) == 0
			% Если первый элемент равен 0 сдвигаем последовательность
			window = [window(2:end) seq(i)];
			i = i + 1;
		end
		% Запоминаем синдром (для декодирования)
		if i == length(seq) - N + 2
			err = window(1:N);
		end
		if window(1) ~= 0
			% Если первый элемент не равен 0 считаем сумму по модулю 2 с
			% полиномом
			window = xor(window, p);
		end
	end
	result = window(2:end);
end

