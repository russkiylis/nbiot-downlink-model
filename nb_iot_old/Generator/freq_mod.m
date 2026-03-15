classdef freq_mod < abs_mod
	methods
		function result = modulate(obj, signal)
			t = 0:1/obj.fs:((length(signal) - 1)/obj.fs);
			opt = 2*pi*0.001/obj.carry_freq;
			result = sin(2*pi*obj.carry_freq.*t + opt*cumsum(signal));
		end
	end
end
