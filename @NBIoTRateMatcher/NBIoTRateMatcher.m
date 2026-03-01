classdef NBIoTRateMatcher < handle
    %NBIOTRATEMATCHER NBIoT RateMatcher
    
    properties (SetAccess = protected)
        perm_pat = [2, 18, 10, 26, 6, 22, 14, 30, 4, 20, 12, 28, 8, 24, 16, 32, 1, 17, 9, 25, 5, 21, 13, 29, 3, 19, 11, 27, 7, 23, 15, 31];
    end

    methods
        function interleave(obj, arr)
            len_arr = size(arr,2);
            row_num = fix(len_arr/32)+mod(len_arr,32)==0;
            len_tmp = row_num*32;
            dummy_size = len_tmp-len_arr;
            tmp = zeros(3, len_tmp);
            if dummy_size ~= 0
                tmp(:, 1:dummy_size)= NaN(3, dummy_size);
                tmp(:, dummy_size+1:len_tmp)=arr;
            else
                tmp = arr;
            end
            tmp = reshape(tmp, [3, row_num,32]);
            result = zeros([3, row_num,32]);
            for i = 1:32
                result(:,:,i)=tmp(:,:,obj.perm_pat(i));
            end
            %По столбцам читается
        end
        function obj = NBIoTRateMatcher()
            obj.interleave();
        end
    end
end