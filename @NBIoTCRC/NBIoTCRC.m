classdef NBIoTCRC < handle
    %CRC16 for NBPCH
    
    properties (SetAccess = protected)
    end
    properties (SetAccess = public)

    end
    methods
        function crc16(obj, arr)
            tmp = [arr, zeros(1, 16)];
            d = [1 5 12 17];
            while d(1) <= 34
                if tmp(d(1))==0
                    d=d+1;
                    continue
                end
                tmp(d) = mod(tmp(d)+1,2);
                d=d+1;
            end
            arr=[arr, tmp(length(tmp)-16:length(tmp))];
            disp(arr)
        end
        function obj = NBIoTCRC()
            obj.crc16(randi([0, 1], 1, 34));
        end
    end
end