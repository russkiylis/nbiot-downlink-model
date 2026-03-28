function sendRemainingBits(obj, remainingBits)
%SENDREMAININGBITS Получение планировщиком оставшихся битов кодового слова

    if ~isempty(remainingBits)
        % Если у нас ещё остались биты, которые надо передать
        obj.currentModulatedCWRemain = remainingBits;
    else
        obj.currentRepCount = obj.currentRepCount+1;
        if obj.currentRepCount > obj.currentMrep
            % Если мы повторили кодовое слово нужное количество раз
            obj.isNewRep = true;
            obj.isNewCW = true;
            
            obj.currentCWID = mod(obj.currentCWID,length(obj.CW))+1;

            obj.currentCW = obj.CW{obj.currentCWID}.bits;
            obj.currentMrep = min(obj.CW{obj.currentCWID}.Mrep,4);
            obj.current_nSF = obj.CW{obj.currentCWID}.nSF;

            obj.currentRepCount = 1;

            if obj.parentGrid.Config.Logging == true
                disp("[NPDSCH] Переход к новому CW: CWID = " + obj.currentCWID + ", Mrep = " + obj.currentMrep);
            end
        else
            % Если кодовое слово нужно повторить
            obj.isNewRep = true;

            if obj.parentGrid.Config.Logging == true
                disp("[NPDSCH] Новое повторение CW: CWID = " + obj.currentCWID + ", повторение " + obj.currentRepCount + "/" + obj.currentMrep);
            end
        end
    end

end

