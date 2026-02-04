classdef NBIoTNPDSCHScheduler < handle
    %NBIOTNPDSCHSCHEDULER Планировщик отправки кодовых слов по каналу NPDSCH.
    
    % Параметры планировщика
    properties (SetAccess = protected)
        parentGrid              % Родительская ресурсная сетка

        CW                      % Кодовые слова
        RNTI
        NCellID

        currentFrameID
        currentSubframeID
        currentNS

        isNewCW = true              % Передаётся новое кодовое слово в сабфрейме или продолжаем старое
        isNewRep = true             % Начинаем ли новое повторение
        currentCW                   % Текущее кодовое слово (биты)
        currentModulatedCW          % Текущее модулированное кодовое слово
        currentModulatedCWRemain    % Что ещё осталось передать
        currentCWID = 1             % ID текущего кодового слова
        currentMrep                 % Текущее число повторений
        currentRepCount = 1         % Сколько повторений уже выполнено
    end

    methods (Access = public)
        function obj = NBIoTNPDSCHScheduler(parentGrid, Codewords_cell)
            %NBIOTNPDSCHSCHEDULER Конструктор.
            obj.parentGrid = parentGrid;
            obj.CW = Codewords_cell;
            obj.RNTI = obj.parentGrid.Config.NPDSCH.RNTI;
            obj.NCellID = obj.parentGrid.Config.NCellID;

            obj.currentCW = obj.CW{obj.currentCWID}.bits;
            obj.currentMrep = min(obj.CW{obj.currentCWID}.Mrep, 4);
        end

        processedData = get_NPDSCH_data(obj, frameID, subframeID)
        sendRemainingBits(obj, remainingBits)
    end
end
