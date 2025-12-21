classdef NBIoTResourceGrid < handle
    %NBIoTResourceGrid NBIoT Resource grid class

    % Параметры ресурсной сетки
    properties (Access = public)
        Config;         % Конфиг
        resourceGrid;   % Непосредственно ресурсная сетка
    end
    properties (Access = protected)
        subframesInFrame = 10;          % Количество субфреймов в одном фрейме
        slotsInSubframe = 2;            % Количество слотов в одном субфрейме
        totalSubcarriers = 12;          % Количество поднесущих
        totalOFDMSymbolsInSlot = 7;     % Количество OFDM-символов в одном слоте
        
        GridGenerated = 0;         % Сгенерировали ли пустую ресурсную сетку

        NRS_shift = 0;              % Сдвиг NRS

    end
    properties (Access = private)
        defaultTotalFrames = 1;    % Всего фреймов
        defaultStartFrame = 0;     % Стартовый фрейм
        defaultNCellID = 0;        % ID соты
        
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

            % Задание стандартных значений
            obj.Config.totalFrames = obj.defaultTotalFrames;
            obj.Config.StartFrame = obj.defaultStartFrame;
            obj.Config.NCellID = obj.defaultNCellID;

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
            %NBIoTResourceGrid Создание пустой сетки

            totalOFDMSymbols = obj.totalOFDMSymbolsInSlot * obj.slotsInSubframe * obj.subframesInFrame * obj.Config.totalFrames;
            % Добавляем в ресурсную сетку "третье измерение" - индекс,
            % указывающий тип сигнала (нужно для "раскрашивания")
            
            obj.GridGenerated = 1;
            obj.resourceGrid = ones(obj.totalSubcarriers, totalOFDMSymbols, 2);
            
            obj.NRS_shift = mod(obj.Config.NCellID, 6);     % Расчёт сдвига NRS

            obj.gen_NPSS();
            obj.gen_NSSS();
            obj.gen_NPBCH();

        end

        % Вывод ресурсной сетки
        function showResourceGrid(obj)
            if ~obj.GridGenerated
                 error('Ресурсная сетка не сгенерирована! Используй emptyGridGen после конфигурации!');
            end
            
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
            
            x_axis = size(obj.resourceGrid(1,:,1))/(obj.slotsInSubframe*obj.totalOFDMSymbolsInSlot);
            y_axis = 0;
            imagesc(x_axis, y_axis, obj.resourceGrid(:,:,2));
            axis xy;
            yticks(0:obj.totalSubcarriers-1);

            xlabel("Субфреймы");
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
            
            legend(handles, legend_labels);

        end
    end


    % Методы генерации сигналов
    methods (Access = protected)
        
        % создаём NPBCH
        function gen_NPBCH(obj)
            totalOFDMSymbols = obj.totalOFDMSymbolsInSlot * obj.slotsInSubframe * obj.subframesInFrame * obj.Config.totalFrames;
            
            for subcarrier_index = 1:obj.totalSubcarriers
                for slot_index = 1:obj.totalOFDMSymbolsInSlot * obj.slotsInSubframe * obj.subframesInFrame:totalOFDMSymbols
                    % Оставляем место
                    if ismember(subcarrier_index, mod([0 3 6 9]+obj.NRS_shift, 12)+1)
                        obj.resourceGrid(subcarrier_index, slot_index+3, 2) = 5;
                        obj.resourceGrid(subcarrier_index, slot_index+9:slot_index+10, 2) = 5;
                    else
                        obj.resourceGrid(subcarrier_index, slot_index+3:slot_index+13, 2) = 5;
                    end
                end
            end

        end

        % создаём NPSS
        function gen_NPSS(obj)
            totalOFDMSymbols = obj.totalOFDMSymbolsInSlot * obj.slotsInSubframe * obj.subframesInFrame * obj.Config.totalFrames;

            cyclic_prefix = [1 1 1 1 -1 -1 1 1 1 -1 1]; % Циклический префикс для генерации NPSS в символах 3-13
            u = 5;
            n = (0:10)';

            d = cyclic_prefix .* exp((-1i.*pi.*u.*n.*(n+1))./(11));
            % disp(d);

            for subcarrier_index = 1:obj.totalSubcarriers-1
                for slot_index = obj.totalOFDMSymbolsInSlot * obj.slotsInSubframe * 5 + 1:obj.totalOFDMSymbolsInSlot * obj.slotsInSubframe * obj.subframesInFrame:totalOFDMSymbols
                    obj.resourceGrid(subcarrier_index, slot_index+3:slot_index+13, 2) = 3;
                    obj.resourceGrid(subcarrier_index, slot_index+3:slot_index+13, 1) = d(subcarrier_index, :);
                end
            end
        end
        
        % создаём NSSS
        function gen_NSSS(obj)
            totalOFDMSymbols = obj.totalOFDMSymbolsInSlot * obj.slotsInSubframe * obj.subframesInFrame * obj.Config.totalFrames;
            
            n = 0:131;
            n_ = mod(n,131);
            m = mod(n,128);
            u = mod(obj.Config.NCellID, 126) + 3;
            q = floor(obj.Config.NCellID./126);
            
            b = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
                 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1;
                 1  -1  -1  1  -1  1  1  -1  -1  1  1  -1  1  -1  -1  1  -1  1  1  -1  1  -1  -1  1  1  -1  -1  1  -1  1  1  -1  -1  1  1  -1  1  -1  -1  1  1  -1  -1  1  -1  1  1  -1  1  -1  -1  1  -1  1  1  -1  -1  1  1  -1  1  -1  -1  1  1  -1  -1  1  -1  1  1  -1  -1  1  1  -1  1  -1  -1  1  -1  1  1  -1  1  -1  -1  1  1  -1  -1  1  -1  1  1  -1  -1  1  1  -1  1  -1  -1  1  1  -1  -1  1  -1  1  1  -1  1  -1  -1  1  -1  1  1  -1  -1  1  1  -1  1  -1  -1  1;
                 1  -1  -1  1  -1  1  1  -1  -1  1  1  -1  1  -1  -1  1  -1  1  1  -1  1  -1  -1  1  1  -1  -1  1  -1  1  1  -1  -1  1  1  -1  1  -1  -1  1  1  -1  -1  1  -1  1  1  -1  1  -1  -1  1  -1  1  1  -1  -1  1  1  -1  1  -1  -1  1  -1  1  1  -1  1  -1  -1  1  1  -1  -1  1  -1  1  1  -1  1  -1  -1  1  -1  1  1  -1  -1  1  1  -1  1  -1  -1  1  1  -1  -1  1  -1  1  1  -1  -1  1  1  -1  1  -1  -1  1  -1  1  1  -1  1  -1  -1  1  1  -1  -1  1  -1  1  1  -1];
            
            d = b(q+1, m+1) .* exp(-1i.*2.*pi.*n) .* exp(-1i.*((pi.*u.*n_.*(n_+1))./(131)));
            d_ = [];
            while ~isempty(d)
                cusochek = d(1:12)';
                d = d(13:end);
                d_ = [d_ cusochek];
            end

            for subcarrier_index = 1:obj.totalSubcarriers
                NPSS_generated = 0;
                for slot_index = obj.totalOFDMSymbolsInSlot * obj.slotsInSubframe * 9 + (mod(obj.Config.StartFrame,2))*obj.totalOFDMSymbolsInSlot * obj.slotsInSubframe * obj.subframesInFrame + 1:obj.totalOFDMSymbolsInSlot * obj.slotsInSubframe * obj.subframesInFrame*2:totalOFDMSymbols
                    obj.resourceGrid(subcarrier_index, slot_index+3:slot_index+13, 2) = 4;

                    if mod(obj.Config.StartFrame, 2) == 0
                        n_f = obj.Config.StartFrame + NPSS_generated.*2;
                    else
                        n_f = obj.Config.StartFrame + 1 + NPSS_generated.*2;
                    end

                    cyclic_shift = mod((((33)./(132)).*((n_f)./2)), 4);
                    d__ = d_ .* exp(cyclic_shift);
                    
                    obj.resourceGrid(subcarrier_index, slot_index+3:slot_index+13, 1) = d__(subcarrier_index, :);

                    NPSS_generated = NPSS_generated + 1;
                end
            end
        end

    end

end