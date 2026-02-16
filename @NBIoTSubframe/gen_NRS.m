% Создание NRS
function subframeGrid = gen_NRS(obj)
    NCellID = obj.parentFrame.parentGrid.Config.NCellID;

    NRS_coords = [[1 0]; [1 8]; [4 5]; [4 12]; [7 0]; [7 8]; [10 5]; [10 12]];
    
    m = 2;  % max dl rb (для NB-IoT=1) но в матлабе не 0 1 а 1 2
    for i = 1:length(NRS_coords)
        subcarrier_index = NRS_coords(i,1);
        symbol_index = NRS_coords(i,2);
        ns = floor(symbol_index,7) + obj.subframeID.*2;   % Номер слота в фрейме
        l = mod(symbol_index,7)-1;    % Номер OFDM-символа внутри слота
        NCP = 1;    % Для нормального cyclic prefix = 1

        c_init = (2.^10).*(7.*(ns+1)+l+1).*(2.*NCellID+1)+2.*NCellID+NCP;
        c = NBIoTScrambler(zeros(1:3),c_init,"NRS").scramblingSequence;
        
        % TBC %
    end

    subframeGrid(subcarrier_index, 4, 2) = 5;
    

end