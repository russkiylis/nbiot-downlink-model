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

            obj.currentRepCount = 1;
        else
            % Если кодовое слово нужно повторить
            obj.isNewRep = true;
        end
    end

end

