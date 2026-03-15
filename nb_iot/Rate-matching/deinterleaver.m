function output = deinterleaver(input)
	C = 32;
	D = length(input);
	R = ceil(D/C);
	perms = [1, 17, 9, 25, 5, 21, 13, 29, 3, 19, 11, 27, 7, 23, 15, 31, 0, 16, 8, 24, 4, 20, 12, 28, 2, 18, 10, 26, 6, 22, 14, 30];

	% Создаем строку с null-битами в начале 
	nans = [NaN([1 (R*C - D)]) zeros([1 (C - R*C + D)])];
	% Переставляем null-биты в соответствие с perms
	nans_p = zeros([1 C]);
	for i = 1:C
		nans_p(i) = nans(perms(i) + 1);
	end
	nans_p

	% Создаем матрицу с первой строкой с null-битами
	matrix = [nans_p; zeros([(R-1) C])];
	% Записываем последовательность в матрицу по столбцам между null-битами
	i = 1;
	k = 1;
	while k <= D
		j = 1;
		while j <= R
			if ~isnan(matrix(j, i))
				matrix(j, i) = input(k);
				k = k + 1;
			end
			j = j + 1;
		end
		i = i + 1;
	end
    matrix

	% Переставляем столбцы обратно
	new_matrix = zeros([R C]);
	for i = 1:length(perms)
		new_matrix(:, perms(i) + 1) = matrix(:, i);
    end
    new_matrix
	% Читаем последовательность из матрицы по строкам
	output = zeros([1 R*C]);
	for i = 1:R
		output((C*i-(C - 1)):C*i) = new_matrix(i, :);
    end
    output
end

