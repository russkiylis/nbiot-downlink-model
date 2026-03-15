classdef(Abstract) gen

    properties
		ampl = 0;
		duration = 0;

		fs = 44100;
	end
    
	methods
		function obj = gen(A, T)
			obj.ampl = A;
			obj.duration = T;
		end

		signal = create(obj)
	end
end