function output = interleaver(input)
	C = 32;
	D = length(input);
	R = ceil(D/C);
	perms = [1, 17, 9, 25, 5, 21, 13, 29, 3, 19, 11, 27, 7, 23, 15, 31, 0, 16, 8, 24, 4, 20, 12, 28, 2, 18, 10, 26, 6, 22, 14, 30];
	% Дополняем сообщение null-битами
    if R*C > D
		input = [NaN([1 (R*C - D)]) input];
    end
	% Записываем последовательность в матрицу по строкам
	matrix = zeros([R C]);
    for i = 1:R
		matrix(i, :) = input((C*i-(C-1)):C*i);
    end
	% Изменяем порядок следования столбцов
	new_matrix = zeros([R C]);
    for i = 1:length(perms)
		new_matrix(:, i) = matrix(:, perms(i) + 1);
    end
	% Считываем последовательность из матрицы по столбцам
	output = zeros([1 R*C]);
    for i = 1:C
		output((R*i-(R - 1)):R*i) = new_matrix(:, i);
    end
end

