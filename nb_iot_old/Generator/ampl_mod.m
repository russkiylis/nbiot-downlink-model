classdef ampl_mod < abs_mod
	methods
		function result = modulate(obj, signal)
			t = 0:1/obj.fs:((length(signal) - 1)/obj.fs);
			result = sin(2*pi*obj.carry_freq*t) .* signal;
		end
	end
end
