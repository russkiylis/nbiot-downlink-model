classdef NBIoTFrame < handle
    %NBIOTFRAME NBIoT Frame class

    % Параметры фрейма
    properties (SetAccess = protected)
        parentGrid;                 % Родительская сетка

        frameID;                    % ID фрейма
        subframes NBIoTSubframe;    % Вектор субфреймов в фрейме
        bitsToMap;                  % Биты, готовые для расположения на ресурсной сетке

        frameGrid;                  % Сетка фрейма

        subframesInFrame = 10;      % Количество субфреймов в одном фрейме
    end


    methods
        function obj = NBIoTFrame(parentGrid, frameID)
            %NBIOTFRAME Конструктор
            obj.parentGrid = parentGrid;        % Передача родительской сетки
            obj.frameID = frameID;              % Передача frameID
            
            % Создание последовательности NPBCH для занесения в ресурсную
            % сетку данного сабфрейма
            NCellID = obj.parentGrid.Config.NCellID;
            c_init = (NCellID+1) .* ((mod(obj.frameID,8)+1).^3) .* (2.^9) + NCellID;
            cf = NBIoTScrambler(ones(1,200),c_init,"NPBCH").scramblingSequence;

            K = 100;
            f = mod(obj.frameID,64);
            y = obj.parentGrid.processedBits.NPBCH;

            theta = zeros(1,200);
            yf = zeros(1,100);
            for i = 1:K
                % Создание переменной theta
                if cf(2.*(i-1)+1) == 0 && cf(2.*(i-1)+2) == 0
                    theta(i) = 1;
                elseif cf(2.*(i-1)+1) == 0 && cf(2.*(i-1)+2) == 1
                    theta(i) = -1;
                elseif cf(2.*(i-1)+1) == 1 && cf(2.*(i-1)+2) == 0
                    theta(i) = 1i;
                elseif cf(2.*(i-1)+1) == 1 && cf(2.*(i-1)+2) == 1
                    theta(i) = -1i;
                end
                
                % Создание битов, готовых к занесению
                yf(i) = theta(i) .* y(K.*floor(f./8)+i);
            end
            obj.bitsToMap.NPBCH = yf;

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