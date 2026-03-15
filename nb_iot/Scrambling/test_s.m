data = randi([0 1], 1, 16)
NNcellID = 489;

s = Scrambler(NNcellID);
ds = Scrambler(NNcellID);

scrambled = s.scramble(data, 1)
descrambled = ds.scramble(scrambled, 1)

diff = xor(data, scrambled);

~ismember(0, data == descrambled);
