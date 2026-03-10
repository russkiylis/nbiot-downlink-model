L = 34;
data = randi([0 1], 1, L);

crc_calc = crc_16(data)
blkcrc = nrCRCEncode(data','16');
nrcrc = logical(blkcrc((end-15):end)')
crc_eq_check = ~ismember(0, blkcrc((end-15):end)' == crc_calc);
crc_calc = crc_mask(crc_calc, 2);
crc_w_mask = crc_calc;

data1 = [data crc_calc];

[blk, err] = nrCRCDecode(data1','16');
blk = blk';
err = str2num(dec2bin(err, 16)')';
[crc_dec, err1] = crc_16(data1);
err1;

err_eq_check = ~ismember(0, err == err1);