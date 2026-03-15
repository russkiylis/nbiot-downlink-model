classdef Scrambler
	properties
		x1;
		x2;
		cinit = 0
	end
	
	methods
		% Конструктор скремблера
		function obj = Scrambler(NNcellID)
			obj.cinit = NNcellID;
			obj.x1 = [1 zeros([1 30])];
			obj.x2 = str2num(flip(dec2bin(obj.cinit, 31)'))';
			obj.initx();
		end

		% Инициализация последовательностей
		function initx(obj)
			for i = 1:1600
			    next_x1 = mod(obj.x1(4) + obj.x1(1), 2);
			    next_x2 = mod(obj.x2(4) + obj.x2(3) + obj.x2(2) + obj.x2(1), 2);
			    obj.x1 = [obj.x1(2:end) next_x1];
			    obj.x2 = [obj.x2(2:end) next_x2];
			end

		end
		
		% Скремблирование
		function output = scramble(obj, input, nf)
			if mod(nf, 64) == 0
				obj.x2 = str2num(flip(dec2bin(obj.cinit, 31)'))';
				obj.initx();
			end
			output = zeros([1 length(input)]);
			for i = 1:length(input)
				next_x1 = mod(obj.x1(4) + obj.x1(1), 2);
				next_x2 = mod(obj.x2(4) + obj.x2(3) + obj.x2(2) + obj.x2(1), 2);
				obj.x1 = [obj.x1(2:end) next_x1];
				obj.x2 = [obj.x2(2:end) next_x2];
				c = mod(next_x1 + next_x2, 2);
				output(i) = mod(input(i) + c, 2);
			end
		end
	end
end

