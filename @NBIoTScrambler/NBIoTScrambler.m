classdef NBIoTScrambler < handle
    %NBIOTSCRAMBLER NBIoT Scrambler
    
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
                case "NPDCCH"
                    obj.scramblingSequence = obj.gen_31GoldSequence();
                case "NRS"
                    obj.scramblingSequence = obj.gen_31GoldSequence();                    
            end

            obj.scrambledBits = mod(obj.bits+obj.scramblingSequence,2);
        end

        % Скремблирование с вычитанием скремблирующей последовательности
        function rescrambledBits = scramble_seqsubstract(obj,bits)
            rescrambledBits = mod(bits+obj.scramblingSequence(1:length(bits)),2);
            obj.scramblingSequence(1:length(bits)) = [];
        end

    end
    methods (Access = protected)
        sequence = gen_31GoldSequence(obj);

    end
end