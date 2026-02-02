classdef NBIoTNPDSCHScheduler
    %NBIOTNPDSCHSCHEDULER Планировщик отправки кодовых слов по каналу
    %NPDSCH
    
    % Параметры планировщика
    properties (SetAccess = protected)
        parentGrid      % Родительская ресурсная сетка
    end

    methods (Access = public)
        function obj = NBIoTNPDSCHScheduler(parentGrid)
            %NBIOTNPDSCHSCHEDULER Конструктор
            obj.parentGrid = parentGrid;
        end
    end
end