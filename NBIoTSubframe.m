classdef NBIoTSubframe
    %NBIOTSUBFRAME NBIoT Subframe Class

    % Параметры субфрейма
    properties (Access = public)
        parentFrame;         % Родительский фрейм

        subframeID;          % Номер субфрейма
        subframeType;        % Тип субфрейма

        subframeGrid;        % Сетка субфрейма
    end
    properties (Access = protected)


        slotsInSubframe = 2;
        symbolsInSlot = 7;
        symbolsInSubframe;

        totalSubcarriers = 12;
    end


    methods (Access = public)
        function obj = NBIoTSubframe(parentFrame, subframeID)
            %NBIOTSUBFRAME Construct an instance of this class
            obj.parentFrame = parentFrame;          % Передача родительского фрейма
            obj.symbolsInSubframe = obj.symbolsInSlot .* obj.slotsInSubframe;
            obj.subframeID = subframeID;
            
            % Создание пустой сетки
            obj.subframeGrid = zeros(obj.totalSubcarriers, obj.symbolsInSubframe);
            obj.subframeGrid(:,:,2) = ones(obj.totalSubcarriers, obj.symbolsInSubframe);

            obj.subframeType = obj.getSubframeType();
            obj.subframeGrid = obj.gridGen();
        end
    end
    methods (Access = protected)
        function subframeType = getSubframeType(obj)
            switch obj.subframeID
                case 0
                    subframeType = "NPBCH";

                case 1
                    subframeType = "null"; %

                case 2
                    subframeType = "null"; %

                case 3
                    subframeType = "null"; %

                case 4
                    subframeType = "null"; %

                case 5
                    subframeType = "NPSS";

                case 6
                    subframeType = "null"; %

                case 7
                    subframeType = "null"; %

                case 8
                    subframeType = "null"; %

                case 9
                    if mod(obj.parentFrame.frameID, 2) == 0     % чётный
                        subframeType = "NSSS";
                    else    % нечётный
                        subframeType = "null"; %
                    end
            end
        end

        function subframeGrid = gridGen(obj)
            switch obj.subframeType
                case "NPSS"
                    subframeGrid = obj.gen_NPSS();
                
                case "NSSS"
                    subframeGrid = obj.gen_NSSS();

                case "NPBCH"
                    subframeGrid = obj.gen_NPBCH();
                
                otherwise
                    %%%
                    subframeGrid = obj.subframeGrid;
                
            end
        end

        % Далее функции генерации разнообразных сигналов
        %% Генератор NPSS
        function subframeGrid = gen_NPSS(obj)
            subframeGrid = obj.subframeGrid;

            cyclic_prefix = [1 1 1 1 -1 -1 1 1 1 -1 1]; % Циклический префикс для генерации NPSS в символах 3-13
            u = 5;
            n = (0:10)';
            d = cyclic_prefix .* exp((-1i.*pi.*u.*n.*(n+1))./(11));
            
            for subcarrier_index = 1:obj.totalSubcarriers-1
                subframeGrid(subcarrier_index, 4:14, 2) = 3;
                subframeGrid(subcarrier_index, 4:14, 1) = d(subcarrier_index, :);
            end
        end

        %% Генаратор NSSS
        function subframeGrid = gen_NSSS(obj)
            subframeGrid = obj.subframeGrid;

            n = 0:131;
            n_ = mod(n,131);
            m = mod(n,128);
            u = mod(obj.parentFrame.parentGrid.Config.NCellID, 126) + 3;
            q = floor(obj.parentFrame.parentGrid.Config.NCellID./126);

            b = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
                 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1;
                 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1;
                 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 -1 1 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1];

            d = b(q+1, m+1) .* exp(-1i.*2.*pi.*n) .* exp(-1i.*((pi.*u.*n_.*(n_+1))./(131)));
            d_ = [];
            while ~isempty(d)
                cusochek = d(1:12)';
                d = d(13:end);
                d_ = [d_ cusochek];
            end
            
            cyclic_shift = mod((((33)./(132)).*((obj.parentFrame.frameID)./2)), 4);
            d__ = d_ .* exp(cyclic_shift);


            for subcarrier_index = 1:obj.totalSubcarriers
                subframeGrid(subcarrier_index, 4:14, 2) = 4;
                subframeGrid(subcarrier_index, 4:14, 1) = d__(subcarrier_index, :);
            end      
        end
        
        %% Генератор NPBCH
        function subframeGrid = gen_NPBCH(obj)
            subframeGrid = obj.subframeGrid;

            for subcarrier_index = 1:obj.totalSubcarriers
                if ismember(subcarrier_index, mod([0 3 6 9]+obj.parentFrame.parentGrid.NRS_shift, 12)+1)
                    subframeGrid(subcarrier_index, 4, 2) = 5;
                    subframeGrid(subcarrier_index, 10:11, 2) = 5;
                else
                    subframeGrid(subcarrier_index, 4:14, 2) = 5;
                end
            end
        end
    end
end