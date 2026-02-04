function sendRemainingBits(obj, remainingBits)
%SENDREMAININGBITS Получение от сабфрейма оставшихся символов кодового слова.

    if ~isempty(remainingBits)
        % Если ещё остались символы для передачи — сохраняем хвост.
        obj.currentModulatedCWRemain = remainingBits;
    else
        obj.currentRepCount = obj.currentRepCount + 1;
        if obj.currentRepCount > obj.currentMrep
            % Повторили кодовое слово нужное число раз — переходим дальше.
            obj.isNewRep = true;
            obj.isNewCW = true;
            
            obj.currentCWID = mod(obj.currentCWID, length(obj.CW)) + 1;

            obj.currentCW = obj.CW{obj.currentCWID}.bits;
            obj.currentMrep = min(obj.CW{obj.currentCWID}.Mrep, 4);

            obj.currentRepCount = 1;
        else
            % Кодовое слово нужно повторить — готовим новое повторение.
            obj.isNewRep = true;
        end
    end

end
