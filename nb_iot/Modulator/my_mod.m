classdef my_mod
	properties
		symbol_dur = 1;
		freq = 100;
		fs = 1000;
	end
	
	methods
		function obj = my_mod(sym_dur, f)
			obj.symbol_dur = sym_dur;
			obj.freq = f;
		end
		
		function [T, signal, const] = bpsk(obj, sequence)
			seq = sequence * 2 - 1;
			signal = [];
			t = 0:1/obj.fs:(obj.symbol_dur - 1/obj.fs);
			for i = seq
				signal = [signal i*sin(2*pi*obj.freq*t)];
			end
			const = seq;
			T = 0:1/obj.fs:(obj.symbol_dur*length(sequence) - 1/obj.fs);
		end

		function [T, signal, const] = qpsk(obj, sequence)
			seq = sequence * 2 - 1;
			if mod(length(seq), 2) ~= 0
				seq = [seq -1];
			end
			I = [];
			Q = [];
			t = 0:1/obj.fs:(obj.symbol_dur - 1/obj.fs);
			for i = 1:2:(length(seq))
				I = [I seq(i)];
				Q = [Q seq(i+1)];
			end
			const = I + 1i*Q;
			signal = (kron(I, sin(2*pi*obj.freq*t)) + kron(Q, cos(2*pi*obj.freq*t))) / sqrt(2);
			T = 0:1/obj.fs:(obj.symbol_dur*length(seq)/2 - 1/obj.fs);
		end

		function [T, signal, const] = qam16(obj, sequence)
			seq = sequence;
			if mod(length(sequence), 4) ~= 0
				seq = [seq zeros([1 (4 - mod(length(sequence), 4))])];
			end
			I = [];
			Q = [];
			t = 0:1/obj.fs:(obj.symbol_dur - 1/obj.fs);
			for i = 1:4:(length(seq) - 3)
				I = [I (seq(i) * 2 - 1)*(seq(i + 1) * 2 + 1)];
				Q = [Q (seq(i + 2) * 2 - 1)*(seq(i + 3) * 2 + 1)];
			end
			const = I + 1i*Q;
			signal = (kron(I, sin(2*pi*obj.freq*t)) + kron(Q, cos(2*pi*obj.freq*t))) / sqrt(2);
			T = 0:1/obj.fs:(obj.symbol_dur*length(seq)/4 - 1/obj.fs);
		end
	end
end

