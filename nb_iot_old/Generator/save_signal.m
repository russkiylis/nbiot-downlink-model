function save_signal(filename, signal, fs)
	y = signal .* 1e6;
	y = cast(y, 'int32');
	audiowrite(filename, y, fs, "BitsPerSample", 32);
end
