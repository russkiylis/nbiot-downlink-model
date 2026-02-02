% Создание сигнала NPDSCH
function subframeGrid = gen_NPDSCH(obj)
    subframeGrid = obj.subframeGrid;


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
end