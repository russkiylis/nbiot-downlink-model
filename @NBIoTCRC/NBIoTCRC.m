classdef NBIoTCRC < handle
    %CRC16 for NBPCH
    
    properties (SetAccess = protected)
    end
    properties (SetAccess = public)

    end
    methods
        function crc16(arr)
            arr = [arr, zeros(1, 16)];
            d = [1 5 12 17];
            while d(1) <= 34
                if arr(d(1))==0
                    d=d+1;
                    continue
                end
                arr(d) = mod(arr(d)+1,2);
                d=d+1;
            end
            disp(arr)
        end
        function obj = NBIoTCRC()
            NBIoTCRC.divide(randi([0, 1], 1, 34));
        end
    end
end