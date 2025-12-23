classdef NBIoTFrame
    %NBIOTFRAME NBIoT Frame class

    % Параметры фрейма
    properties (Access = public)
        parentGrid;                 % Родительская сетка

        frameID;
        subframes NBIoTSubframe;
        frameGrid;      % Сетка фрейма
    end
    properties (Access = protected)


        subframesInFrame = 10;      % Количество субфреймов в одном фрейме
    end



    methods
        function obj = NBIoTFrame(parentGrid, frameID)
            %NBIOTFRAME Конструктор
            obj.parentGrid = parentGrid;        % Передача родительской сетки
            obj.frameID = frameID;
            
            for subframeID = 0:obj.subframesInFrame-1
                obj.subframes(subframeID+1) = NBIoTSubframe(obj, subframeID);
            end

            grids = {obj.subframes.subframeGrid};
            obj.frameGrid = cat(2, grids{:});
            
        end
    end
end