L = 34;
p = [133 171 165];
ports = 4;
NNcellID = 123;
E = 1600;
nf = 1;

% Create data
data = randi([0 1], 1, L);

% Calculate crc
crc_calc = crc_16(data);
% Apply mask to crc
crc_calc = crc_mask(crc_calc, ports);
% Attach crc to data
data_w_crc = [data crc_calc];
% Encode with TBCC with polynomyals p
data_enc = tbcc(data_w_crc, p);
% Interleave
w = [];
for i = 1:size(data_enc, 1)
	w = [w interleaver(data_enc(i, :))];
end
% Select
e = selector(w, E);

to_src = e(1:200);
% Scramble
s = Scrambler(NNcellID);
data_scr = s.scramble(to_src, nf);

% Descramble
ds = Scrambler(NNcellID);
data_descr = ds.scramble(data_scr, nf);
% Deinterleave
d1 = deinterleaver(data_descr(1:50));
data_deintrvd = [];
for i = 1:51:150
	data_deintrvd = [data_deintrvd deinterleaver(data_descr(i:(i + 50)))];
end
data_selected = selector(data_deintrvd, 3*(L+16));
% Decode TBCC codeword
data_dec = viterbi(data_selected, p);
% Calculate syndrom
[crc_dec, err] = crc_16(data_dec);
n_ports = check_crc_mask(err)
if n_ports ~= -1
	data_dec = data_dec((end-15):end);
else
	data_dec = zeros([1 (length(data_dec) - 16)]);
end

~ismember(0, data_dec == data)