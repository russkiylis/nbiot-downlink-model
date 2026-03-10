signal1 = gen(1, 4, 1000, 1);
signal1 = signal1.create_sqr();
signal1.save_signal("signal1.wav")
signal1 = signal1.load_signal("signal1.wav");

subplot(1, 2, 1);
signal1.plot_time();
subplot(1, 2, 2);
signal1.plot_autocorr();


%{
signal2 = gen(1, 1, 10, 1);
signal2 = signal2.create_sqr();
subplot(2, 2, 3);
signal2.plot_time();
subplot(2, 2, 4);
signal2.plot_mag();
%}
