% Генерация ресурсной сетки субфрейма
function subframeGrid = gridGen(obj)
    % Руководствуемся типом субфрейма
    switch obj.subframeType
        case "NPSS"
            subframeGrid = obj.gen_NPSS();
        
        case "NSSS"
            subframeGrid = obj.gen_NSSS();

        case "NPBCH"
            subframeGrid = obj.gen_NPBCH();
        
        case "NPDSCH"
            % На этом месте всунуть "подаватель правильных
            % последовательностей кодовых слов для NPDSCH"
            subframeGrid = obj.gen_NPDSCH();
        
        case "NPDCCH"
            subframeGrid = obj.gen_NPDCCH();

        otherwise
            %%%
            subframeGrid = obj.subframeGrid;
        
    end
end