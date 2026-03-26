classdef NBIoTResourceGrid < handle
    %NBIoTResourceGrid NBIoT Resource grid class

    % Параметры ресурсной сетки
    properties (Access = public)
        Config;         % Конфиг
        frames NBIoTFrame;
        NPDSCHScheduler NBIoTNPDSCHScheduler;
        NPDCCHScheduler NBIoTNPDCCHScheduler;
        processedBits;  % Обработанные биты, готовые к засовыванию в ресурсную сетку
        resourceGrid;   % Непосредственно ресурсная сетка
        NRS_shift = 0;              % Сдвиг NRS

        % Сигнал после OFDM
        time;
        signal;
    end
    properties (Access = protected)
        subframesInFrame = 10;          % Количество субфреймов в одном фрейме
        slotsInSubframe = 2;            % Количество слотов в одном субфрейме
        totalSubcarriers = 12;          % Количество поднесущих
        totalOFDMSymbolsInSlot = 7;     % Количество OFDM-символов в одном слоте
        
        GridGenerated = 0;         % Сгенерировали ли пустую ресурсную сетку
        SignalGenerated = 0;       % Сгенерировали ли сигнал



    end
    properties (Access = private)
        defaultLogging = false;    % Логи в консоль

        defaultTotalFrames = 1;    % Всего фреймов
        defaultStartFrame = 0;     % Стартовый фрейм
        defaultNCellID = 0;        % ID соты

        defaultBits_NPBCH = repelem([1 0], 17);    % Дефолтный набор битов, передающийся в NPBCH

        defaultRNTI = 1;            % Дефолтный RNTI (получатель)
        defaultSIB1NBGen = false;   % Есть ли генерация SIB1NB (NPDSCH, несущее BCCH) !НЕ РЕАЛИЗОВАНО
        default_NPDSCH_map = [0 0 1 1 1 0 1 1 1 1];     % В каких субфреймах желательно передавать NPDSCH
        % Генерация плотностей вероятности для дефолтных кодовых слов для передачи через NPDSCH
        default_p1 = (sin(0.01:0.01:10)+1)/2 ; % Signal Processing Toolbox (sawtooth(0.01:0.01:10)+1)/2;
        default_p2 = (sin(0.01:0.01:5)+1)/2;
        
        % Посторения кодовых слов
        default_cw1_rep = 3;
        default_cw2_rep = 2;
        
        default_NPDCCH_map = [0 1 0 0 0 0 0 0 0 0];     % В каких субфреймах желательно передавать NPDCCH
        % Дефолтные биты DCI, а также их тип
        default_DCI1 = randi([0 1], 1, 23);
        default_DCI2 = randi([0 1], 1, 23);
        default_DCI3 = randi([0 1], 1, 23);
        default_DCI1_type = 0;
        default_DCI2_type = 0;
        default_DCI3_type = 1;
        default_DCI1_Mrep = 2;
        default_DCI2_Mrep = 1;
        default_DCI3_Mrep = 3;

        % defaultColor_empty = [255 255 255];
        % defaultColor_NRS = [0 0 0];
        % defaultColor_NPSS = [255 90 0];
        % defaultColor_NSSS = [255 120 20];
        % defaultColor_NPBCH = [255 175 80];
        % defaultColor_SIB1NB = [255 200 120];
        % defaultColor_NPDCCH = [255 240 200];
        % defaultColor_NPDSCH = [255 220 160];

        defaultColor_empty = [255 255 255];
        defaultColor_NRS = [255 235 180];
        defaultColor_NPSS = [255 210 110];
        defaultColor_NSSS = [255 170 50];
        defaultColor_NPBCH = [255 130 0];
        defaultColor_SIB1NB = [240 80 0];
        defaultColor_NPDCCH = [200 40 0];
        defaultColor_NPDSCH = [140 0 0];

    end
    


    % Методы
    methods
        
        % Конструктор класса
        function obj = NBIoTResourceGrid()
            %NBIoTResourceGrid Constructor

            addpath(genpath("Packs"));  % Добавляем паки

            % Задание стандартных значений
            obj.Config.Logging = obj.defaultLogging;

            obj.Config.totalFrames = obj.defaultTotalFrames;
            obj.Config.startFrame = obj.defaultStartFrame;
            obj.Config.NCellID = obj.defaultNCellID;

            obj.Config.Bits.NPBCH = obj.defaultBits_NPBCH;

            obj.Config.NPDSCH.RNTI = obj.defaultRNTI;
            obj.Config.NPDSCH.SIB1NBGen = obj.defaultSIB1NBGen;
            obj.Config.NPDSCH.Map = obj.default_NPDSCH_map;

            obj.Config.Bits.NPDSCH_Codeword{1}.bits = double(rand(1,length(obj.default_p1)) < obj.default_p1);
            obj.Config.Bits.NPDSCH_Codeword{1}.Mrep = obj.default_cw1_rep;
            obj.Config.Bits.NPDSCH_Codeword{2}.bits = double(rand(1,length(obj.default_p2)) < obj.default_p2);
            obj.Config.Bits.NPDSCH_Codeword{2}.Mrep = obj.default_cw2_rep;


            obj.Config.NPDCCH.Map = obj.default_NPDCCH_map;
            obj.Config.Bits.NPDCCH_DCI{1}.bits = obj.default_DCI1;
            obj.Config.Bits.NPDCCH_DCI{1}.type = obj.default_DCI1_type;
            obj.Config.Bits.NPDCCH_DCI{1}.Mrep = obj.default_DCI1_Mrep;
            obj.Config.Bits.NPDCCH_DCI{2}.bits = obj.default_DCI2;
            obj.Config.Bits.NPDCCH_DCI{2}.type = obj.default_DCI2_type;
            obj.Config.Bits.NPDCCH_DCI{2}.Mrep = obj.default_DCI2_Mrep;
            obj.Config.Bits.NPDCCH_DCI{3}.bits = obj.default_DCI3;
            obj.Config.Bits.NPDCCH_DCI{3}.type = obj.default_DCI3_type;
            obj.Config.Bits.NPDCCH_DCI{3}.Mrep = obj.default_DCI3_Mrep;


            obj.Config.Colormap.empty = obj.defaultColor_empty;
            obj.Config.Colormap.NRS = obj.defaultColor_NRS;
            obj.Config.Colormap.NPSS = obj.defaultColor_NPSS;
            obj.Config.Colormap.NSSS = obj.defaultColor_NSSS;
            obj.Config.Colormap.NPBCH = obj.defaultColor_NPBCH;
            obj.Config.Colormap.SIB1NB = obj.defaultColor_SIB1NB;
            obj.Config.Colormap.NPDCCH = obj.defaultColor_NPDCCH;
            obj.Config.Colormap.NPDSCH = obj.defaultColor_NPDSCH;
        end
        
        % Вызывать эту функцию надо после конфигурации
        function GridGen(obj)
            %NBIoTResourceGrid Вся магия происходит после того как настроен конфиг
            
            obj.NPDSCHScheduler = NBIoTNPDSCHScheduler(obj, obj.Config.Bits.NPDSCH_Codeword);   % Создание планировщика отправки кодовых слов

            % Предварительный CRC и tail biting для битов NPDCCH (rate
            % matching производится в планировщике в зависимости от типа
            % DCI)
            for k = 1:length(obj.Config.Bits.NPDCCH_DCI)
                obj.processedBits.NPDCCH{k}.bits = NBIoTEncoding().tail_coding(NBIoTCRC().crc16(obj.Config.Bits.NPDCCH_DCI{k}.bits));
                obj.processedBits.NPDCCH{k}.type = obj.Config.Bits.NPDCCH_DCI{k}.type;
                obj.processedBits.NPDCCH{k}.Mrep = obj.Config.Bits.NPDCCH_DCI{k}.Mrep;
            end

            obj.NPDCCHScheduler = NBIoTNPDCCHScheduler(obj, obj.processedBits.NPDCCH);


            totalOFDMSymbols = obj.totalOFDMSymbolsInSlot * obj.slotsInSubframe * obj.subframesInFrame * obj.Config.totalFrames;
            % Добавляем в ресурсную сетку "третье измерение" - индекс,
            % указывающий тип сигнала (нужно для "раскрашивания")
            
            obj.GridGenerated = 1;
            obj.resourceGrid = ones(obj.totalSubcarriers, totalOFDMSymbols, 2);
            
            obj.NRS_shift = mod(obj.Config.NCellID, 6);     % Расчёт сдвига NRS
            
            % Обработка NPBCH-битов
            NPBCH_crc = NBIoTCRC().crc16(obj.Config.Bits.NPBCH);
            NPBCH_encoded = NBIoTEncoding().tail_coding(NPBCH_crc);
            NPBCH_ratematched = NBIoTRateMatcher().rate_match(NPBCH_encoded, 1600);
            scrambler_NPBCH = NBIoTScrambler(NPBCH_ratematched, obj.Config.NCellID,"NPBCH");
            modulator_NPBCH = NBIoTQPSK(scrambler_NPBCH.scrambledBits);
            obj.processedBits.NPBCH = modulator_NPBCH.modulatedBits;


            % Создание объектов фреймов
            for frameID = 0:obj.Config.totalFrames-1
                obj.frames(frameID+1) = NBIoTFrame(obj, frameID+obj.Config.startFrame);
            end
            
            % Соединение фреймов
            grids = {obj.frames.frameGrid};
            obj.resourceGrid = cat(2, grids{:});
                

        end

        % Вывод ресурсной сетки
        function showResourceGrid(obj)
            if ~obj.GridGenerated
                 error('Ресурсная сетка не сгенерирована! Используй GridGen после конфигурации!');
            end
            
            obj.resourceGrid(1,1,2) = 2;
            obj.resourceGrid(2,1,2) = 3;
            obj.resourceGrid(3,1,2) = 4;
            obj.resourceGrid(4,1,2) = 5;
            obj.resourceGrid(5,1,2) = 6;
            obj.resourceGrid(6,1,2) = 7;
            obj.resourceGrid(7,1,2) = 8;

            colorConfig = obj.Config.Colormap;
            
            % Создание colormap
            cmap_full = [
                colorConfig.empty;
                colorConfig.NRS;
                colorConfig.NPSS;
                colorConfig.NSSS;
                colorConfig.NPBCH;
                colorConfig.SIB1NB;
                colorConfig.NPDCCH;
                colorConfig.NPDSCH]./255;
            
            figure(name="Ресурсная сетка Downlink NB-IoT (Standalone)");

            x_axis = size(obj.resourceGrid(1,:,1))/(obj.slotsInSubframe*obj.totalOFDMSymbolsInSlot);
            y_axis = 0;
            imagesc(x_axis, y_axis, obj.resourceGrid(:,:,2));
            axis xy;
            yticks(0:obj.totalSubcarriers-1);

            xlabel("Сабфреймы");
            ylabel("Поднесущие");
            grid on;

            % Этот раздел кода генерирует легенду (но всё равно багованно)
            labels = {'Пусто','NRS','NPSS','NSSS','NPBCH','SIB1-NB','NPDCCH','NPDSCH'};

            present = unique(obj.resourceGrid(:,:,2));  % Находим то что присутствует     
            legend_labels = labels(present);
            cmap = cmap_full(present, :);
            colormap(cmap);

            
            handles = gobjects(length(present), 1);
            hold on;
            for k = 1:length(present)
                    handles(k) = patch(NaN, NaN, cmap(k,:));
            end
            handles(6) = [];
            legend_labels(6) = [];
            legend(handles, legend_labels);
            title("Ресурсная сетка Downlink NB-IoT (Standalone)");
            
        end

        function SignalGen(obj)
            % Генерация сигнала методом OFDM-модуляции

            if ~obj.GridGenerated
                 error('Ресурсная сетка не сгенерирована! Используй GridGen после конфигурации!');
            end

            ofdm = NBIoTOFDM(obj.resourceGrid);
            [obj.time, obj.signal] = ofdm.SignalGen();
            obj.SignalGenerated = 1;

            % figure;
            % plot(time, real(signal).*cos(2.*pi.*0.*time)+imag(signal).*(-sin(2.*pi.*0.*time)));
            % figure;
            % semilogy(abs(fftshift(fft(real(signal).*cos(2.*pi.*0.*time)+imag(signal).*(-sin(2.*pi.*0.*time))))));
        end

        function showSignal(obj, f0)
            % Вывод сигнала во временной области
            % f0 - несущая частота

            if ~obj.SignalGenerated
                 error('Сигнал не сгенерирован! Используй SignalGen после генерации сетки!');
            end

            figure(name="Сигнал Downlink NB-IoT во временной области (f0 = "+f0.*1e-3+" кГц)");
            plot(obj.time, real(obj.signal).*cos(2.*pi.*f0.*obj.time)+imag(obj.signal).*(-sin(2.*pi.*f0.*obj.time)));
            title("Сигнал Downlink NB-IoT во временной области (f0 = "+f0.*1e-3+" кГц)");
            grid on;
            xlabel("t, с");
            ylabel("u, В");
        end

        function showSpectr(obj, f0)
            % Вывод сигнала во частотной
            % f0 - несущая частота

            if ~obj.SignalGenerated
                 error('Сигнал не сгенерирован! Используй SignalGen после генерации сетки!');
            end

            figure(name="Амплитудный спектр Downlink NB-IoT (f0 = "+f0.*1e-3+" кГц)");
            
            s = real(obj.signal).*cos(2.*pi.*f0.*obj.time)+imag(obj.signal).*(-sin(2.*pi.*f0.*obj.time));
            A = abs(fftshift(fft(s)));
            N = length(s);
            f = (-N/2 : N/2-1) .* (1./obj.time(2)) ./ N .*1e-3;

            plot(f,A);
            title("Амплитудный спектр Downlink NB-IoT (f0 = "+f0.*1e-3+" кГц)");
            grid on;
            xlabel("f, кГц");
            ylabel("u, В/Гц");
            xlim([f0.*1e-3-200 f0.*1e-3+200]);
            xline(f0.*1e-3-90, '--',f0.*1e-3-90+" кГц");
            xline(f0.*1e-3+90, '--',f0.*1e-3+90+" кГц");
        end
    end
end