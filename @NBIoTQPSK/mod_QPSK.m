% Модуляция QPSK
function modulatedBits = mod_QPSK(obj)
    bits = obj.bits;
    if mod(length(bits),2) ~= 0
        error("Ошибка QPSK: количество битов нечётное!");       % QPSK надобно делать для чётного количества битов
    end

    modulatedBits = zeros(1, length(bits)./2);      % Предварительное выделение памяти
    
    a = 1;
    for i = 1:2:length(bits)
        if bits(i) == 1
            if bits(i+1) == 1
                % 11
                modulatedBits(a) = (-1-1i)./sqrt(2);
            else
                % 10
                modulatedBits(a) = (1-1i)./sqrt(2);
            end
        else
            if bits(i+1) == 1
                % 01
                modulatedBits(a) = (-1+1i)./sqrt(2);
            else
                % 00
                modulatedBits(a) = (1+1i)./sqrt(2);
            end
        end
        a = a + 1;
    end
end