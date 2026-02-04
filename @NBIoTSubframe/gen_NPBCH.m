% Создание сигнала NPBCH в соответствии с документацией
function subframeGrid = gen_NPBCH(obj)
    subframeGrid = obj.subframeGrid;
    bitsToMap = obj.parentFrame.bitsToMap.NPBCH;

    % Сначала отмечаем, куда можно мапить данные NPBCH (учёт NRS).
    for subcarrier_index = 1:obj.totalSubcarriers
        if ismember(subcarrier_index, mod([0 3 6 9]+obj.parentFrame.parentGrid.NRS_shift, 12)+1)
            subframeGrid(subcarrier_index, 4, 2) = 5;
            subframeGrid(subcarrier_index, 10:11, 2) = 5;
        else
            subframeGrid(subcarrier_index, 4:14, 2) = 5;
        end
    end

    i = 1;
    % Последовательно заполняем доступные RE символами NPBCH.
    for subcarrier_index = 1:obj.totalSubcarriers
        for subframe_index = 1:obj.symbolsInSubframe
            if subframeGrid(subcarrier_index,subframe_index,2) == 5
                subframeGrid(subcarrier_index,subframe_index,1) = bitsToMap(i);
                i=i+1;
            end
        end
    end
end
