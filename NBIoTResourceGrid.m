classdef NBIoTResourceGrid < handle
    %NBIoTResourceGrid NBIoT Resource grid class

    % Параметры ресурсной сетки
    properties (Access = public)
        Config;         % Конфиг
        frames NBIoTFrame;
        resourceGrid;   % Непосредственно ресурсная сетка
        NRS_shift = 0;              % Сдвиг NRS
    end
    properties (Access = protected)
        subframesInFrame = 10;          % Количество субфреймов в одном фрейме
        slotsInSubframe = 2;            % Количество слотов в одном субфрейме
        totalSubcarriers = 12;          % Количество поднесущих
        totalOFDMSymbolsInSlot = 7;     % Количество OFDM-символов в одном слоте
        
        GridGenerated = 0;         % Сгенерировали ли пустую ресурсную сетку



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
            obj.Config.startFrame = obj.defaultStartFrame;
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
            
            for frameID = 0:obj.Config.totalFrames-1
                obj.frames(frameID+1) = NBIoTFrame(obj, frameID+obj.Config.startFrame);
            end

            grids = {obj.frames.frameGrid};
            obj.resourceGrid = cat(2, grids{:});
                

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
end