classdef NBIoTScrambler < handle
    %NBIOTSCRAMBLER NBIoT Scrambler
    % Универсальный скремблер: по типу сигнала выбирает нужную последовательность.
    
    properties (SetAccess = protected)
        bits;
        c_init;
        signal_type;
        
        scramblingSequence;
        scrambledBits;
    end

    methods
        function obj = NBIoTScrambler(bits,c_init,signal_type)
            %UNTITLED Конструктор
            obj.bits = bits;
            obj.c_init = c_init;
            obj.signal_type = signal_type;

            switch obj.signal_type
                case "NPBCH"
                    obj.scramblingSequence = obj.gen_31GoldSequence();
                case "NPDSCH"
                    obj.scramblingSequence = obj.gen_31GoldSequence();
            end

            % Скремблирование по модулю 2.
            obj.scrambledBits = mod(obj.bits+obj.scramblingSequence,2);
        end


    end
    methods (Access = protected)
        sequence = gen_31GoldSequence(obj);
    end
end
