classdef gen_sqr < gen
	methods
		function signal = create(obj)
			signal = ones([1 round(obj.duration * obj.fs)]) * obj.ampl;
		end
	end
end
