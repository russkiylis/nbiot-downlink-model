M = 11;
seq = zc_seq(M, 5, 0);
signal = zeros([12, 20]);
a = [1, 1, 1, 1, -1, -1, 1, 1, 1, -1, 1, 0];
for i = 0:(M-1)
	signal(1:M, i+1) = ifft(a(i+1)*seq);
end
%signal = ifft(signal);

% for i = 1:10
% 	loss = 0;
% 	noise = randn + 1i*randn;
% 	signal(randi(M), randi(M)) = loss;
% end

%correlate freq
c = [];
for i = 1:12
	[c(:, i), lags_x] = xcorr(fft(signal(1:M, i)), seq);
end

% aperiod to period
for i = 1:(M-1)
	temp = c(i+M, :);
	c(i+M, :) = c(i+M, :) + c(i, :);
	c(i, :) = c(i, :) + temp;
end

% correlate time
c1 = [];
for i = 1:(2*M - 1)
	[c1(i, :), lags_y] = xcorr(c(i, :), a);
end

[X, Y] = meshgrid(lags_y, lags_x);

surf(angle(signal));
%surf(abs(c1));
ylabel('freq');
xlabel('time');