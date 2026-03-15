classdef NBIoTNPDCCHScheduler < handle
    %UNTITLED Планировщик отправки DCI

    properties
        parentGrid

        DCI    % Что мы будем отправлять
        DCI0
        DCI1

        currentFrameID
        currentSubframeID
        currentNS
        currentLength1
        currentLength2

        currentDCIID0 = 1;   % Текущий индекс отправляемого DCI
        currentMrep0 = 1;    % Текущее повторение
        currentDCIID1 = 1;   % Текущий индекс отправляемого DCI
        currentMrep1 = 1;    % Текущее повторение
        ended_DCI0 = 1;
        ended_DCI1 = 1;

        untilNextScrambling = 1;    % Скремблинг каждые 4 сабфрейма
        awaitingForLongDCI = 0;     % Ожидаем ли мы передачу длинного DCI
        whereIsLongDCI;
        
        c_init



    end

    methods
        function obj = NBIoTNPDCCHScheduler(parentGrid, DCI)
            %UNTITLED конструктор
            obj.parentGrid = parentGrid;
            obj.DCI0 = DCI(1:floor(length(DCI)/2));
            obj.DCI1 = DCI(ceil(length(DCI)/2):end);

        end

        data = getData(obj, FrameID, SubframeID, length1, length2);
    end
end