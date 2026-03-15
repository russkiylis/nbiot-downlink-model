classdef Plotter
	properties
		fs = 44100;
	end
	
	methods
		function obj = Plotter(fs)
			obj.fs = fs;
		end
		
		function plot_time(obj, data)
			t = 0:1/obj.fs:(length(data)/obj.fs - 1/obj.fs);
			plot(t, data);
			xlabel('time');
			ylabel('amplitude');
		end

		function plot_mag(obj, data)
			len = length(data);
			f = (-len/2:len/2-1)/len * obj.fs;
			mag = abs(fftshift(fft(data, len)))/len;
			plot(f, mag);
			xlabel('frequency');
			ylabel('power');
		end

		function plot_phase(obj, data)
			len = length(data);
			f = (-len/2:len/2-1)/len * obj.fs;
			phase = fftshift(fft(data, len));
			phase(abs(phase) < 1e-6) = 0;
			plot(f, angle(phase));
			xlabel('frequency');
			ylabel('phase');
		end

		function plot_autocorr(obj, data)
			[y, x] = xcorr(data);
			y = y./obj.fs;
			x = x./obj.fs;
			plot(x, y);
		end
	end
end

