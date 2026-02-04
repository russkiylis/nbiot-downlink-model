% Тест скремблера: сравнение битов до/после и проверка автокорреляции.
bits = randi([0 1],1,1600);             % Тут уже псевдослучайное, надо бы взять другое для наглядности
bits = (square(1:1600,50)+1)/2;

NCellID = 504;
scrambler = NBIoTScrambler(bits, NCellID, "NPBCH");

figure(name="Биты")
plot(bits);

figure(name="Биты после скремблера")
plot(scrambler.scrambledBits);

% Проверка на хорошую КФ.
figure(name="КФ битов без скремблирования")
tau = 1:2*length(scrambler.bits);
for k = tau
    shifted(k, :) = circshift(scrambler.bits, k);
    pakf(k) = real(sum(scrambler.bits.*conj(shifted(k, :))));
end
plot(pakf);

figure(name="КФ битов со скремблированием")
tau = 1:2*length(scrambler.scrambledBits);
for k = tau
    shifted(k, :) = circshift(scrambler.scrambledBits, k);
    pakf(k) = real(sum(scrambler.scrambledBits.*conj(shifted(k, :))));
end
plot(pakf);

% Дескремблирование.
descrambler = NBIoTScrambler(scrambler.scrambledBits, NCellID, "NPBCH");
difference = sum(bits-descrambler.scrambledBits);
if difference == 0
    disp("Вернулись те же биты!");
end
