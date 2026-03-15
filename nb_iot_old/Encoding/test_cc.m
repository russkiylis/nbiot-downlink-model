L = 8;
data = randi([0 1], 1, L);

p = [5 7];

data_enc = tbcc(data, p)

% pos = randi([1 16], 1, 3);
% for i = 1:length(pos)
% 	data_enc(pos(i)) = xor(data_enc(pos(i)), 1);
% end

data_dec = viterbi(data_enc, p);

in_out_eq = ismember(0, data_dec == data) == 0