classdef NBIoTFrame < handle
    %NBIOTFRAME NBIoT Frame class

    % Параметры фрейма
    properties (SetAccess = protected)
        parentGrid;                 % Родительская сетка

        frameID;                    % ID фрейма
        subframes NBIoTSubframe;    % Вектор субфреймов в фрейме
        frameGrid;                  % Сетка фрейма

        subframesInFrame = 10;      % Количество субфреймов в одном фрейме
    end


    methods
        function obj = NBIoTFrame(parentGrid, frameID)
            %NBIOTFRAME Конструктор
            obj.parentGrid = parentGrid;        % Передача родительской сетки
            obj.frameID = frameID;              % Передача frameID
            
            % Создание вектора субфреймов
            for subframeID = 0:obj.subframesInFrame-1
                obj.subframes(subframeID+1) = NBIoTSubframe(obj, subframeID);
            end
            
            % Набор сеток субфреймов
            grids = {obj.subframes.subframeGrid};
            obj.frameGrid = cat(2, grids{:});
            
        end
    end
end