% A = [1 2 3 4 5 6 7 8 9 10];
% B = [4 6 8 9 10];
% A(B) = [];
% A;
% 
% state = 0b100;
% poly = 0b101;
% bitand(state, poly);
% dec2bin(bitand(state, poly)')
% mod(sum( dec2bin(bitand(state, poly)') == '1' ), 2)

A = {1; 2; 3; [1 2 3]; '123'}
A{1} == A{2}