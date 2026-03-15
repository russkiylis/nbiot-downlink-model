classdef(Abstract) abs_mod
	properties
		carry_freq
		fs
	end
	
	methods
		function obj = abs_mod(carry_freq, fs)
			obj.carry_freq = carry_freq;
			obj.fs = fs;
		end

		result = modulate(obj, signal)
	end
end

