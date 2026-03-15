%configuration
amplitude = 10;
duration = 2*pi*0.1;
offset = 0;
period = 2*duration;
quantity = 3;
carry_frequency = 10;


gen = gen_tri(amplitude, duration);
signal1 = gen.create();
signal2 = gen.create();

signal1 = repeater(signal1, gen.fs, offset, period, quantity);
signal2 = repeater(signal2, gen.fs, offset, period, quantity);

mod1 = phase_mod(carry_frequency, gen.fs);
signal1_mod = mod1.modulate(signal1);

mod2 = freq_mod(carry_frequency, gen.fs);
signal2_mod = mod2.modulate(signal2);

plotter = Plotter(gen.fs);

subplot(1, 2, 1);
plotter.plot_time(signal1_mod);
hold on;
yyaxis right;
plotter.plot_time(signal1)
subplot(1, 2, 2);
plotter.plot_time(signal2_mod);
hold on;
yyaxis right;
plotter.plot_time(signal2);
