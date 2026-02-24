function [result, remainder] = divide(a,b)
    % Функция GF2-деления полиномов
    
    % Для начала обрежем ненужные нули с конца векторов, а затем к
    % короткому добавим нули до их равенства
    a = EssentialsPack.zeroTrimmer(a,"last");
    b = EssentialsPack.zeroTrimmer(b,"last");
    if length(a)>length(b)
        b = [b zeros(1,length(a)-length(b))];
    elseif length(a)<length(b)
        a = [a zeros(1,length(b)-length(a))];
    end

    if isempty(b)
        error("GF2Pack:DivisionByZeroPoly", "Деление на нулевой полином!");
    end
   
    % Выделяем место для результата
    result = zeros(1,length(a));

    % Задаём остатку значение делимого
    remainder = a;

    while true
        % Будем выполнять операции покуда степень делителя не будет больше степени остатка
        diff = find(fliplr(b),1)-find(fliplr(remainder),1);
        if diff <0
            break;
        end
        if isempty(diff)
            break;
        end
        
        result(diff+1) = 1;
        
        b_ = [zeros(1,diff) b(1:length(b)-diff)];
        remainder = mod(remainder+b_, 2);

        if diff <=0
            break;
        end
    end

    % Обрежем лишние нули у результата и делителя
    remainder = EssentialsPack.zeroTrimmer(remainder, "last");
    result = EssentialsPack.zeroTrimmer(result, "last");

    % Проверка на пустоту
    if isempty(remainder)
        remainder = 0;
    end
    if isempty(result)
        result = 0;
    end


end