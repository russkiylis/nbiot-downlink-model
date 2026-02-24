function result = zeroTrimmer(vec, type)
    % Функция для обрезки лишних нулей
    
    if isempty(vec)
        error("EssentialsPack:EmptyZeroTrimmerVector", "Вектор пустой! Откуда мне обрезать нули?")
    end

    if type == "first"  % Обрезаем первые нули
        firstNotZeroID = find(vec,1,"first");
        result = vec(firstNotZeroID:length(vec));

    elseif type == "last"   % Обрезаем последние нули
        lastNotZeroID = find(vec,1,"last");
        result = vec(1:lastNotZeroID);
    
    elseif type == "both"   % Обрезаем первые и последние нули
        firstNotZeroID = find(vec,1,"first");
        lastNotZeroID = find(vec,1,"last");
        result = vec(firstNotZeroID:lastNotZeroID);

    else
        error("EssentialsPack:WrongZeroTrimmerOperationType", "Неправильный тип работы триммера! Должно быть first/last/both")
    
    end


    if isempty(result)
        result = [];
    end
    
end