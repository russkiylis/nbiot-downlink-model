function data_dec = viterbi(data, poly)
	poly_dec = oct2dec(poly);
	reg_size = length(dec2bin(poly_dec(1)));
	factor = length(poly_dec);
	result_lat = [];
	% Создаем структуру пути для каждого начального узла
	for i = 0:(2^(reg_size - 1) - 1)
		init_path.init_state = i;
		init_path.state = i;
		init_path.code = 0;
		init_path.metric = 0;
		init_path.hd = 0;
		result_lat = [result_lat init_path];
	end
	% Проходим по всем кодовым словам
	for i = 1:size(data, 2)
		word = data(:, i)';
		% Создаем промежуточный массив путей
		% inter = createArray([1 2^(reg_size)], Like=result_lat(1));
		inter = [];
        % path_count = 1;
		for curr_path = result_lat
			% Создаем 2 ответвления для каждого существующего пути
			for k = 0:1
				new_rank = bitshift(k, reg_size - 1);
				out_state = curr_path.state + new_rank;
				result = zeros([1 factor]);
				for pos = 1:factor
					bits_chosen = bitand(out_state, poly_dec(pos));
					result(pos) = mod(sum( dec2bin(bits_chosen') == '1' ), 2);
				end
				hd = sum(xor(word, result));
				% Обновляем данные о пути
				new_path.init_state = curr_path.init_state;
				new_path.state = bitshift(out_state, -1);
				new_path.code = [curr_path.code k];
				new_path.metric = curr_path.metric + hd;
				new_path.hd = hd;
				% Добавляем путь в промежуточный массив
                % inter(path_count) = new_path;
                % path_count = path_count + 1;
				inter = [inter; new_path];
			end
		end
		j = 1;
		% Выбираем из путей сходящихся в один узел путь с наименьшей метрикой
		while j < length(inter)
			next = 2^(reg_size - 1) + 1;
			if inter(next).hd < inter(j).hd
				inter(j) = inter(next);
			elseif (inter(next).hd == inter(j).hd) && (inter(next).metric < inter(j).metric)
				inter(j) = inter(next);
			end
			inter(next) = [];
			j = j + 1;
		end
		result_lat = inter;
	end
	% Выбираем пути у которых равны начальное и конечное состояния
	result_arr = [];
	for i = 1:length(result_lat)
		if result_lat(i).init_state == result_lat(i).state
			result_arr = [result_arr result_lat(i)];
		end
	end
	% Если подходящих путей не обнаружено возвращаем массив нулей
	if isempty(result_arr)
		data_dec = zeros([1 size(data, 2)]);
		return
	end
	% Выбираем путь с наименьшей суммарной метрикой
	[~, index] = min([result_arr.metric]);
	data_dec = result_arr(index).code;
	data_dec = data_dec(2:end);
end

