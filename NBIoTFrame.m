classdef NBIoTFrame
    %NBIOTFRAME NBIoT Frame class

    % Параметры фрейма
    properties (Access = public)
        frameID;

        frameGrid;      % Сетка фрейма
    end
    properties (Access = protected)
        parentGrid;                 % Родительская сетка

        subframesInFrame = 10;      % Количество субфреймов в одном фрейме
        symbolsInSubframe = 14;     % Количество символов в каждом субфрейме
    end



    methods
        function obj = NBIoTFrame(parentGrid)
            %NBIOTFRAME Конструктор
            obj.parentGrid = parentGrid;        % Передача родительской сетки
        end
    end
end