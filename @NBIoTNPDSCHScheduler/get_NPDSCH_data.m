% Выдача готовых данных сабфрейму NPDSCH
function processedData = get_NPDSCH_data(obj, frameID, subframeID, RE_available)
    obj.currentFrameID = frameID;
    obj.currentSubframeID = subframeID;
    obj.currentNS = 2.*(10.*obj.currentFrameID+obj.currentSubframeID);
    
    % Если у нас новое повторение - начинаем обработку
    if obj.isNewRep == true
        
        % Rate matching (количество битов зависит о количества сабфреймов,
        % в которых передаётся кодовое слово. Поскольку режим работы не
        % меняется со временем, можно посчитать количество доступных RE
        % в одном сабфрейме, а затем просто домножить на количество
        % сабфреймов, в которых передаётся кодовое слово. Затем домножить
        % на 2, так как потом применяется QPSK, которая превращает 2 бита в
        % одно комплексное число (QPSK-символ)
        n_bits = RE_available .* obj.current_nSF .* 2;
        rate_matched_CW = NBIoTRateMatcher().rate_match(obj.currentCW,n_bits);

        % Скремблирование
        c_init = obj.RNTI.*(2.^14) + mod(obj.currentFrameID,2).*(2.^13) + floor(obj.currentNS./2).*(2.^9) + obj.NCellID;
        scrambledBits = NBIoTScrambler(rate_matched_CW,c_init,"NPDSCH").scrambledBits;

        % Модуляция
        obj.currentModulatedCW = NBIoTQPSK(scrambledBits).modulatedBits;
        obj.currentModulatedCWRemain = obj.currentModulatedCW;

        obj.isNewCW = false;
        obj.isNewRep = false;
    end
    
    % Вывод логов
    if obj.parentGrid.Config.Logging == true
        disp(newline);
        disp("FrameID: " + obj.currentFrameID + "       SubframeID: " + obj.currentSubframeID);
        disp("CWID: " + obj.currentCWID + "     Осталось передать: " + length(obj.currentModulatedCWRemain));
        disp("Повторение: " + obj.currentRepCount + "       Mrep: " + obj.currentMrep);
    end


    processedData = obj.currentModulatedCWRemain;
end

