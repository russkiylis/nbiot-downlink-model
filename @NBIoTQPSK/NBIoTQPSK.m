classdef NBIoTQPSK
    %NBIoTQPSK NBIoT QPSK modulator

    properties (SetAccess = protected)
        bits;
        modulatedBits;
    end

    methods
        function obj = NBIoTQPSK(bits)
            %NBIoTQPSK Конструктор
            obj.bits = bits;
            obj.modulatedBits = obj.mod_QPSK();
        end
    end
    
    methods (Access = protected)
        modulatedBits = mod_QPSK(obj); % Модуляция QPSK
    end
end