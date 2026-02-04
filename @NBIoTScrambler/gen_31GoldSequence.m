% Генератор псевдослучайной последовательности
function sequence = gen_31GoldSequence(obj)
    Nc = 1600;
    sequence = zeros(1,length(obj.bits));    % Выделение памяти под последовательность

    % Генерация x1
    x1 = [1 zeros(1,30)];
    for n = 1:length(obj.bits)+Nc
        x1(n+31) = mod(x1(n+3)+x1(n),2);
    end

    % tau = 1:4*length(x1);
    % for k = tau
    %     shifted(k, :) = circshift(x1, k);
    %     pakf(k) = real(sum(x1.*conj(shifted(k, :))));
    % end
    % plot(pakf)

    
    % Генерация x2
    c_init_bin = dec2bin(obj.c_init, 31);
    x2 = fliplr(c_init_bin)-'0';       % Магия вычитания ASCII кодов (переворот чтобы было правильно по разрядам)
    for n = 1:length(obj.bits)+Nc
        x2(n+31) = mod(x2(n+3)+x2(n+2)+x2(n+1)+x2(n),2);
    end

    % tau = 1:4*length(x2);
    % for k = tau
    %     shifted(k, :) = circshift(x2, k);
    %     pakf(k) = real(sum(x2.*conj(shifted(k, :))));
    % end
    % plot(pakf)

    
    % Генерация c (склейка x1/x2).

    for n = 1:length(obj.bits)
        sequence(n) = mod(x1(n+Nc)+x2(n+Nc),2);
    end
end
