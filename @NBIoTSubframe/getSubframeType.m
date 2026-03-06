% Выбор типа субфрейма
function subframeType = getSubframeType(obj)
    % Руководствуемся такими данными как subframeID
    switch obj.subframeID
        case 0
            subframeType = "NPBCH";

        case 1
            if obj.parentFrame.parentGrid.Config.NPDSCH.Map(2) == 1
                subframeType = "NPDSCH";
            elseif obj.parentFrame.parentGrid.Config.NPDCCH.Map(2) == 1
                subframeType = "NPDCCH";
            else
                subframeType = "null";
            end

        case 2
            if obj.parentFrame.parentGrid.Config.NPDSCH.Map(3) == 1
                subframeType = "NPDSCH";
            elseif obj.parentFrame.parentGrid.Config.NPDCCH.Map(3) == 1
                subframeType = "NPDCCH";
            else
                subframeType = "null";
            end

        case 3 %% ТУТ МОЖЕТ БЫТЬ SIB1-NB
            if obj.parentFrame.parentGrid.Config.NPDSCH.SIB1NBGen == false
                if obj.parentFrame.parentGrid.Config.NPDSCH.Map(4) == 1
                    subframeType = "NPDSCH";
                elseif obj.parentFrame.parentGrid.Config.NPDCCH.Map(4) == 1
                    subframeType = "NPDCCH";
                else
                    subframeType = "null";
                end
            end

        case 4 %% ТУТ МОЖЕТ БЫТЬ SIB1-NB
            if obj.parentFrame.parentGrid.Config.NPDSCH.SIB1NBGen == false
                if obj.parentFrame.parentGrid.Config.NPDSCH.Map(5) == 1
                    subframeType = "NPDSCH";
                elseif obj.parentFrame.parentGrid.Config.NPDCCH.Map(5) == 1
                    subframeType = "NPDCCH";
                else
                    subframeType = "null";
                end
            end

        case 5
            subframeType = "NPSS";

        case 6
            if obj.parentFrame.parentGrid.Config.NPDSCH.Map(7) == 1
                subframeType = "NPDSCH";
            elseif obj.parentFrame.parentGrid.Config.NPDCCH.Map(7) == 1
                subframeType = "NPDCCH";
            else
                subframeType = "null";
            end

        case 7
            if obj.parentFrame.parentGrid.Config.NPDSCH.Map(8) == 1
                subframeType = "NPDSCH";
            elseif obj.parentFrame.parentGrid.Config.NPDCCH.Map(8) == 1
                subframeType = "NPDCCH";
            else
                subframeType = "null";
            end

        case 8
            if obj.parentFrame.parentGrid.Config.NPDSCH.Map(9) == 1
                subframeType = "NPDSCH";
            elseif obj.parentFrame.parentGrid.Config.NPDCCH.Map(9) == 1
                subframeType = "NPDCCH";
            else
                subframeType = "null";
            end

        case 9
            % Исходя из документации NB-IoT, NSSS генерируется только в
            % чётных фреймах
            if mod(obj.parentFrame.frameID, 2) == 0     % чётный
                subframeType = "NSSS";
            else    % нечётный
                if obj.parentFrame.parentGrid.Config.NPDSCH.Map(10) == 1
                    subframeType = "NPDSCH";
                elseif obj.parentFrame.parentGrid.Config.NPDCCH.Map(10) == 1
                    subframeType = "NPDCCH";
                else
                    subframeType = "null";
                end
            end
    end