% Создание сигнала NPDSCH
function subframeGrid = gen_NPDSCH(obj)
    subframeGrid = obj.subframeGrid;
    
    % Получаем то что нужно мапить
    bitsToMap = obj.parentFrame.parentGrid.NPDSCHScheduler.get_NPDSCH_data(obj.parentFrame.frameID, obj.subframeID);

    % Получение фазового сдвига
    c_init = (obj.parentFrame.parentGrid.Config.NPDSCH.RNTI+1).*(mod(10.*obj.parentFrame.frameID+obj.subframeID,61)+1).*(2.^9)+obj.parentFrame.parentGrid.Config.NCellID;
    scramblingSeq = NBIoTScrambler(zeros(length(bitsToMap).*2+1),c_init,"NPDSCH").scramblingSequence;   % Не играет роли, какие биты подаем на вход, только количество
    theta = zeros(1,length(bitsToMap));
    for i = 1:length(bitsToMap)
        if scramblingSeq(2.*i)==0 && scramblingSeq(2.*i+1)==0
            theta(i)=1;
        elseif scramblingSeq(2.*i)==0 && scramblingSeq(2.*i+1)==1
            theta(i)=-1;
        elseif scramblingSeq(2.*i)==1 && scramblingSeq(2.*i+1)==0
            theta(i)=1i;
        else
            theta(i)=-1i;
        end
    end

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
    
    % Маппинг элементов на ресурсную сетку
    for subcarrier_index = 1:obj.totalSubcarriers
        if isempty(bitsToMap)
            break
        end        
        for subframe_index = 1:obj.symbolsInSubframe
            if isempty(bitsToMap)
                break
            end
            if subframeGrid(subcarrier_index,subframe_index,2) == 8
                subframeGrid(subcarrier_index,subframe_index,1) = bitsToMap(1).*theta(1);
                bitsToMap(1) = [];
                theta(1) = [];
            end
        end
    end

    % Отчёт планировщику отправки кодовых слов
    obj.parentFrame.parentGrid.NPDSCHScheduler.sendRemainingBits(bitsToMap);
end