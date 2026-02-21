% Создание NRS
function subframeGrid = gen_NRS(obj)
    subframeGrid = obj.subframeGrid;
    NCellID = obj.parentFrame.parentGrid.Config.NCellID;
    NRS_shift = obj.parentFrame.parentGrid.NRS_shift;

    NRS_coords = [...
        [mod(NRS_shift,6)+1 6]; ...
        [6+mod(NRS_shift,6)+1 6]; ...
        [mod(3+NRS_shift,6)+1 7]; ...
        [6+mod(3+NRS_shift,6)+1 7]; ...
        [mod(NRS_shift,6)+1 13]; ...
        [6+mod(NRS_shift,6)+1 13]; ...
        [mod(3+NRS_shift,6)+1 14]; ...
        [6+mod(3+NRS_shift,6)+1 14]];
    
    m = 0;  % max dl rb (для NB-IoT=1)
    for i = 1:length(NRS_coords)
        subcarrier_index = NRS_coords(i,1);
        symbol_index = NRS_coords(i,2);
        ns = floor(symbol_index/7) + obj.subframeID.*2;   % Номер слота в фрейме
        l = mod(symbol_index,7)-1;    % Номер OFDM-символа внутри слота
        NCP = 1;    % Для нормального cyclic prefix = 1

        c_init = (2.^10).*(7.*(ns+1)+l+1).*(2.*NCellID+1)+2.*NCellID+NCP;
        c = NBIoTScrambler(zeros(4),c_init,"NRS").scramblingSequence;
        
        r = (1./sqrt(2)).*(1-2.*c(2.*m+1)) + 1i.*(1./sqrt(2)).*(1-2.*c(2.*m+2));

        subframeGrid(subcarrier_index,symbol_index,2) = 2;
        subframeGrid(subcarrier_index,symbol_index,1) = r;

        if m == 0
            m = 1;
        elseif m == 1
            m = 0;
        end
    end
    

end