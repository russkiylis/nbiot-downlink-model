classdef gen_tri < gen
	methods
		function signal = create(obj)
			x = 1:round(obj.duration*obj.fs);
			y = -abs(2*obj.ampl/obj.duration*(x/obj.fs) - obj.ampl) + obj.ampl;
			signal = ones([1 round(obj.duration * obj.fs)]) .* y;
		end
	end
end
