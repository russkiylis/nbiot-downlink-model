classdef NBIoTSubframe < handle
    %NBIOTSUBFRAME NBIoT Subframe Class
    % Здесь выбирается тип сабфрейма и строится локальная сетка.

    % Параметры субфрейма
    properties (SetAccess = protected)
        parentFrame;            % Родительский фрейм

        subframeID;             % Номер субфрейма
        subframeType;           % Тип субфрейма

        subframeGrid;           % Сетка субфрейма

        slotsInSubframe = 2;    % Количество слотов в субфрейме
        symbolsInSlot = 7;      % Количество OFDM-символов в слоте
        symbolsInSubframe;      % Количество символов в субфрейме (посчитается в конструкторе)

        totalSubcarriers = 12   % Всего поднесущих
    end


    methods (Access = public)
        function obj = NBIoTSubframe(parentFrame, subframeID)
            %NBIOTSUBFRAME Конструктор
            obj.parentFrame = parentFrame;                                      % Передача родительского фрейма
            obj.symbolsInSubframe = obj.symbolsInSlot .* obj.slotsInSubframe;   % Подсчёт OFDM-символов в субфрейме
            obj.subframeID = subframeID;                                        % Передача subframeID
            
            % Создание пустой сетки
            obj.subframeGrid = zeros(obj.totalSubcarriers, obj.symbolsInSubframe);          % Первое измерение - информация
            obj.subframeGrid(:,:,2) = ones(obj.totalSubcarriers, obj.symbolsInSubframe);    % Второе измерение - "раскраска"

            obj.subframeType = obj.getSubframeType();   % Выбор типа субфрейма
            obj.subframeGrid = obj.gridGen();           % Генерация ресурсной сетки субфрейма
        end
    end
    methods (Access = protected)
        subframeType = getSubframeType(obj)     % Выбор типа субфрейма
        subframeGrid = gridGen(obj)             % Генерация ресурсной сетки субфрейма

        % Далее функции генерации разнообразных сигналов
        subframeGrid = gen_NPSS(obj)
        subframeGrid = gen_NSSS(obj)
        subframeGrid = gen_NPBCH(obj)
        subframeGrid = gen_NPDSCH(obj)
        subframeGrid = gen_NPDCCH(obj)

    end
end
