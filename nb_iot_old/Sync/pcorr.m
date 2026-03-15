function c = pcorr(seq, reps, len)
	seq_p = repeat(seq, reps);
	c = xcorr(seq, seq_p);
	left = len - 1;
	rigth = len * reps + 1;
	c = c(left:rigth);
end
