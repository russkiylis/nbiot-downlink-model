% Выбор типа субфрейма
function subframeType = getSubframeType(obj)
    % Руководствуемся такими данными как subframeID
    switch obj.subframeID
        case 0
            subframeType = "NPBCH";

        case 1
            subframeType = "null"; %

        case 2
            subframeType = "null"; %

        case 3
            subframeType = "null"; %

        case 4
            subframeType = "null"; %

        case 5
            subframeType = "NPSS";

        case 6
            subframeType = "null"; %

        case 7
            subframeType = "null"; %

        case 8
            subframeType = "null"; %

        case 9
            % Исходя из документации NB-IoT, NPSS генерируется только в
            % чётных фреймах
            if mod(obj.parentFrame.frameID, 2) == 0     % чётный
                subframeType = "NSSS";
            else    % нечётный
                subframeType = "null"; %
            end
    end