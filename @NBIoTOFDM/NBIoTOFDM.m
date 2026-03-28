classdef NBIoTOFDM < handle
    %UNTITLED OFDM-модулятор сигнала NB-IoT

    properties
        resourceGrid    % Непосредственно ресурсная сетка
    end

    methods
        function obj = NBIoTOFDM(resourceGrid)
            %UNTITLED Конструктор
            obj.resourceGrid = resourceGrid;
        end


        function [time, signal] = SignalGen(obj)
            %METHOD1 Генератор сигнала

            signal = [];

            % Генерируем сигнал для каждого OFDM-символа
            for l = 1:length(obj.resourceGrid(1,:,1))

                % Для первого OFDM-символа в слоте длина ЦП равна 160
                % отсчётам, иначе - 144
                if mod(l-1,7) == 0
                    n_cp = 160;
                else
                    n_cp = 144;
                end
                
                n_signal = 2048;            % Количество отсчётов непосредственно сигнала
                delta_f = 15e3;             % Частота между поднесущими
                f_s = n_signal.*delta_f;    % Частота дискретизации
                t_s = 1./f_s;               % Период дискретизации

                k = -floor(12/2):ceil(12/2)-1;  % Проход по поднесущим
                
                time_symbol = (0:n_cp+n_signal-1).*t_s;
                
                OFDM_symbol = obj.resourceGrid(:,l,1);

                signal_symbol = OFDM_symbol .* exp(1i.*2.*pi.*(k'+0.5).*delta_f.*(time_symbol-n_cp.*t_s));
                signal_symbol = sum(signal_symbol,1);
                
                % % Добавление CP
                % signal_symbol = [signal_symbol(end-n_cp+1:end) signal_symbol(n_cp+1:end)];
                
                signal = [signal signal_symbol]; %#ok<AGROW>
            end
            
            time = (0:length(signal)-1).*t_s;

        end
    end
end