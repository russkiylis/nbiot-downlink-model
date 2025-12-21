classdef NBIoTSubframe
    %NBIOTSUBFRAME NBIoT Subframe Class

    % Параметры субфрейма
    properties (Access = public)
        subframeID;          % Номер субфрейма
        subframeType;        % Тип субфрейма

        subframeGrid;        % Сетка субфрейма
    end
    properties (Access = protected)
        parentFrame;         % Родительский фрейм

        slotsInSubframe = 2;
        symbolsInSlot = 7;
        symbolsInSubframe;

        totalSubcarriers = 12;
    end


    methods (Access = public)
        function obj = NBIoTSubframe(parentFrame)
            %NBIOTSUBFRAME Construct an instance of this class
            obj.parentFrame = parentFrame;          % Передача родительского фрейма
            obj.symbolsInSubframe = obj.symbolsInSlot .* obj.slotsInSubframe;
            
            % Создание пустой сетки
            obj.subframeGrid = zeros(obj.totalSubcarriers, obj.symbolsInSubframe);
            obj.subframeGrid(:,:,2) = ones(obj.totalSubcarriers, obj.symbolsInSubframe);

            obj.subframeType = obj.getSubframeType();
        end
    end
    methods (Access = protected)
        function subframeType = getSubframeType(obj)
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
                    if mod(obj.parentFrame.frameID, 2) == 0     % чётный
                        subframeType = "NSSS";
                    else    % нечётный
                        subframeType = "null"; %
                    end
            end
        end
    end
end