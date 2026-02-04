% Выдача готовых данных сабфрейму NPDSCH
function processedData = get_NPDSCH_data(obj, frameID, subframeID)
    obj.currentFrameID = frameID;
    obj.currentSubframeID = subframeID;
    obj.currentNS = 2 .* (10 .* obj.currentFrameID + obj.currentSubframeID);
    
    % Если у нас новое повторение — начинаем обработку.
    if obj.isNewRep == true
        % Скремблирование.
        c_init = obj.RNTI .* (2 .^ 14) + mod(obj.currentFrameID, 2) .* (2 .^ 13) ...
            + floor(obj.currentNS ./ 2) .* (2 .^ 9) + obj.NCellID;
        scrambledBits = NBIoTScrambler(obj.currentCW, c_init, "NPDSCH").scrambledBits;

        % Модуляция.
        obj.currentModulatedCW = NBIoTQPSK(scrambledBits).modulatedBits;
        obj.currentModulatedCWRemain = obj.currentModulatedCW;

        obj.isNewCW = false;
        obj.isNewRep = false;
    end
    
    % Вывод логов.
    if obj.parentGrid.Config.Logging == true
        disp(newline);
        disp("FrameID: " + obj.currentFrameID + "       SubframeID: " + obj.currentSubframeID);
        disp("CWID: " + obj.currentCWID + "     Осталось передать: " + length(obj.currentModulatedCWRemain));
        disp("Повторение: " + obj.currentRepCount + "       Mrep: " + obj.currentMrep);
    end

    processedData = obj.currentModulatedCWRemain;
end
