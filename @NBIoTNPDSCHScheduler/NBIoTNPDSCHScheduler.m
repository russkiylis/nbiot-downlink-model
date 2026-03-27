classdef NBIoTNPDSCHScheduler < handle
    %NBIOTNPDSCHSCHEDULER Планировщик отправки кодовых слов по каналу
    %NPDSCH
    
    % Параметры планировщика
    properties (SetAccess = protected)
        parentGrid      % Родительская ресурсная сетка

        CW              % Кодовые слова
        RNTI
        NCellID

        currentFrameID
        currentSubframeID
        currentNS

        isNewCW = true              % Передаётся ли новое кодовое слово в данном сабфрейме, или старое
        isNewRep = true             % Будет ли новое повторение
        currentCW                   % Текущее передающееся кодовое слово 
        currentModulatedCW          % Текущее модулированное кодовое слово
        currentModulatedCWRemain    % То что осталось передать
        currentCWID = 1             % Текущее передающееся кодовое слово (ID)
        currentMrep                 % Текущее количество повторений
        currentRepCount = 1         % Сколько уже повторилось
        current_nSF                 % Количество сабфреймов для передачи CW
    end

    methods (Access = public)
        function obj = NBIoTNPDSCHScheduler(parentGrid, Codewords_cell)
            %NBIOTNPDSCHSCHEDULER Конструктор
            obj.parentGrid = parentGrid;
            obj.CW = Codewords_cell;
            obj.RNTI = obj.parentGrid.Config.NPDSCH.RNTI;
            obj.NCellID = obj.parentGrid.Config.NCellID;

            obj.currentCW = obj.CW{obj.currentCWID}.bits;
            obj.currentMrep = min(obj.CW{obj.currentCWID}.Mrep,4);
            obj.current_nSF = obj.CW{obj.currentCWID}.nSF;
        end

        processedData = get_NPDSCH_data(obj, frameID, subframeID, RE_available)
        sendRemainingBits(obj, remainingBits)
    end
end