len = 11;
reps = 3;

seq = zc_seq(len, 2, 0);
c = xcorr(seq, seq);
for i = (len+1):(2*len - 1)
	c(i) = c(i) + c(i - len);
end
c = c(len:(2*len - 1));
c = [c c c];
c = pcorr(seq, reps, len);
plot(abs(c));