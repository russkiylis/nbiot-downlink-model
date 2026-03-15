% Создание сигнала NPDCCH
function subframeGrid = gen_NPDCCH(obj)
    subframeGrid = obj.subframeGrid;

    % Доступные RE в каждом NCCE
    RE_available1 = 0;
    RE_available2 = 0;
    % Раскрашивание ресурсной сетки (не забываем про NRS)
    for subcarrier_index = 1:obj.totalSubcarriers
        if ismember(subcarrier_index, mod([0 6]+obj.parentFrame.parentGrid.NRS_shift, 12)+1)
            subframeGrid(subcarrier_index, 1:5, 2) = 7;
            subframeGrid(subcarrier_index, 7:12, 2) = 7;
            subframeGrid(subcarrier_index, 14, 2) = 7;
            if subcarrier_index <= 6
                RE_available1 = RE_available1 + 12;
            else
                RE_available2 = RE_available2 + 12;
            end
        elseif ismember(subcarrier_index, mod([3 9]+obj.parentFrame.parentGrid.NRS_shift, 12)+1)
            subframeGrid(subcarrier_index, 1:6, 2) = 7;
            subframeGrid(subcarrier_index, 8:13, 2) = 7;
            if subcarrier_index <= 6
                RE_available1 = RE_available1 + 12;
            else
                RE_available2 = RE_available2 + 12;
            end
        else
            subframeGrid(subcarrier_index, 1:14, 2) = 7;
            if subcarrier_index <= 6
                RE_available1 = RE_available1 + 14;
            else
                RE_available2 = RE_available2 + 14;
            end
        end
    end
    
    data = obj.parentFrame.parentGrid.NPDCCHScheduler.getData(obj.parentFrame.frameID, obj.subframeID, RE_available1, RE_available2);

    % Получение фазового сдвига
    currentNS = 2.*(10.*obj.parentFrame.frameID+obj.subframeID);
    c_init = (obj.parentFrame.parentGrid.Config.NCellID+1)*(mod(10*obj.parentFrame.frameID+floor(currentNS/2),8192)+1)*(2^9)+obj.parentFrame.parentGrid.Config.NCellID;
    scramblingSeq = NBIoTScrambler(zeros(1,length(data).*2+1),c_init,"NPDCCH").scramblingSequence;   % Не играет роли, какие биты подаем на вход, только количество
    theta = zeros(1,length(data));
    for i = 1:length(data)
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
    data = data.*theta;

    % Маппинг элементов на ресурсную сетку
    for subcarrier_index = 1:obj.totalSubcarriers
        if isempty(data)
            break
        end        
        for subframe_index = 1:obj.symbolsInSubframe
            if isempty(data)
                break
            end
            if subframeGrid(subcarrier_index,subframe_index,2) == 7
                subframeGrid(subcarrier_index,subframe_index,1) = data(1);
                data(1) = [];
            end
        end
    end

end