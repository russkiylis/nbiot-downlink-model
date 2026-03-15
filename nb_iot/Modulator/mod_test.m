bits = randi([0 1], 1, 1024);

modulator = my_mod(0.1, 100);
[T, signal, const] = modulator.qam16(bits);

%plot(T, signal);
fig = scatterplot(const, 1, 0, 'g*');

%const = freq_error(const);
const = phase_error(const);
%const = add_noise(const);
%const = phase_noise(const);

hold on;
scatterplot(const, 1, 0, 'y.', fig);
