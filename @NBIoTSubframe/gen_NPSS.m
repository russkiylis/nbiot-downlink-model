% Генерация NPSS в соответствии с документацией
function subframeGrid = gen_NPSS(obj)
    subframeGrid = obj.subframeGrid;

    % Циклический префикс для генерации NPSS в символах 3-13.
    cyclic_prefix = [1 1 1 1 -1 -1 1 1 1 -1 1];
    u = 5;
    n = (0:10)';
    d = cyclic_prefix .* exp((-1i.*pi.*u.*n.*(n+1))./(11));
    
    % Заполнение ресурсной сетки (12 поднесущих, символы 4-14).
    for subcarrier_index = 1:obj.totalSubcarriers-1
        subframeGrid(subcarrier_index, 4:14, 2) = 3;
        subframeGrid(subcarrier_index, 4:14, 1) = d(subcarrier_index, :);
    end
end
