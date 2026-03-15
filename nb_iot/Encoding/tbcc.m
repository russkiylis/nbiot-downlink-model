function stream = tbcc(data, poly)
	p = [];
	% Создаем последовательности коэффициентов полиномов из восьмиричных чисел
	for i = 1:length(poly)
		p = [p; flip(str2num(dec2bin(oct2dec(poly(i)))')')];
	end
	% Выходной поток
	stream = zeros([size(p,1) length(data)]);
	% Регистр сдвига
	reg = data((end - size(p,2) + 1):end);
	for i = 1:length(data)
		% Сдвигаем регистр
		reg = [reg(2:end) data(i)];
		temp = zeros([1 size(p,1)]);
		% Суммируем по модулю 2
		for j = 1:size(p,1)
			temp(j) = mod(sum( p(j, :) & reg ), 2);
		end
		% Записываем результат в выходной поток
		stream(:, i) = temp';
	end
end

