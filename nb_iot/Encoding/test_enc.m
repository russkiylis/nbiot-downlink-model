L = 34;
p = [133 171 165];
ports = 4;

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


% Channel
% pos = randi([1 16], 1, 3);
% for i = 1:length(pos)
% 	data_enc(pos(i)) = xor(data_enc(pos(i)), 1);
% end


% Decode TBCC codeword
data_dec = viterbi(data_enc, p);
%old_dec = viterbi_old(data_enc, p);
%ismember(0, data_dec == old_dec) == 0
% Calculate syndrom
[crc_dec, err] = crc_16(data_dec);
n_ports = check_crc_mask(err)
if n_ports ~= -1
	data_dec = data_dec((end-15):end);
else
	data_dec = zeros([1 (length(data_dec) - 16)]);
end