L = 50;
E = 1600;

d = randi([0 1], 3, L);
v1 = interleaver(d(1, :));
v2 = interleaver(d(2, :));
v3 = interleaver(d(3, :));
w = [v1 v2 v3];
e = selector(w, E);

data = d(1, :)
v1;
b1 = e(1:L);
b1di = deinterleaver(b1);
deinterleaved = selector(b1di, L)

%~ismember(0, b1di == d(1, :));