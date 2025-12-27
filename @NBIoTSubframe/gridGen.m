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
        
        otherwise
            %%%
            subframeGrid = obj.subframeGrid;
        
    end
end