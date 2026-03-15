N = 16;
reps = 3;

seq = gen_m_seq(N);
c = pcorr(seq, reps, (2^N - 1));
subplot(2, 1, 1);
plot(c);

% seq1 = mlseq((2^N-1))';
% seq1_p = repeat(seq1, reps);
% c1 = xcorr(seq1, seq1_p);
% c1 = c1(left:rigth);
% subplot(2, 1, 2);
% plot(c1);