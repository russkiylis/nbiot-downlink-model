function [signal, fs] = load_signal(filename)
	[y, fs] = audioread(filename, 'native');
	y = cast(y, 'double');
	signal = y ./ 1e6;
end
