% Создание сигнала NPDSCH
function subframeGrid = gen_NPDSCH(obj)
    subframeGrid = obj.subframeGrid;
    
    % Получаем то что нужно мапить
    bitsToMap = obj.parentFrame.parentGrid.NPDSCHScheduler.get_NPDSCH_data(obj.parentFrame.frameID, obj.subframeID);

    % Раскрашивание ресурсной сетки (не забываем про NRS)
    for subcarrier_index = 1:obj.totalSubcarriers
        if ismember(subcarrier_index, mod([0 6]+obj.parentFrame.parentGrid.NRS_shift, 12)+1)
            subframeGrid(subcarrier_index, 1:5, 2) = 8;
            subframeGrid(subcarrier_index, 7:12, 2) = 8;
            subframeGrid(subcarrier_index, 14, 2) = 8;
        elseif ismember(subcarrier_index, mod([3 9]+obj.parentFrame.parentGrid.NRS_shift, 12)+1)
            subframeGrid(subcarrier_index, 1:6, 2) = 8;
            subframeGrid(subcarrier_index, 8:13, 2) = 8;
        else
            subframeGrid(subcarrier_index, 1:14, 2) = 8;
        end
    end
    
    % Маппинг элементов на ресурсную сетку
    for subcarrier_index = 1:obj.totalSubcarriers
        if isempty(bitsToMap)
            break
        end        
        for subframe_index = 1:obj.symbolsInSubframe
            if isempty(bitsToMap)
                break
            end
            if subframeGrid(subcarrier_index,subframe_index,2) == 8
                subframeGrid(subcarrier_index,subframe_index,1) = bitsToMap(1);
                bitsToMap(1) = [];
            end
        end
    end

    % Отчёт планировщику отправки кодовых слов
    obj.parentFrame.parentGrid.NPDSCHScheduler.sendRemainingBits(bitsToMap);
end