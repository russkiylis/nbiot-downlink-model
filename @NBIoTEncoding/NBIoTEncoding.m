classdef NBIoTEncoding < handle
    %tail for NBPCH

    methods
        function tail_coding(obj, arr)
            d = zeros(3,length(arr));
            s = length(arr)-5:length(arr);
            i = 1;
            while i <= length(arr)
                d(1,i)= mod(arr(i)+arr(s(2))+arr(s(3))+arr(s(5))+arr(s(6)),2);
                d(2,i)= mod(arr(i)+arr(s(1))+arr(s(2))+arr(s(3))+arr(s(6)),2);
                d(3,i)= mod(arr(i)+arr(s(1))+arr(s(2))+arr(s(4))+arr(s(6)),2);
                i = i+1;
                s = s+1;
                s(s==length(arr)+1)=1; %Переход к 1
            end
            disp(d)
        end
        function obj = NBIoTEncoding()
            obj.tail_coding(randi([0, 1], 1, 50));
        end
    end
end