function data = getData(obj, FrameID, SubframeID, length1, length2)
%GETDATA Метод получения QPSK-символов для NPDCCH

    obj.currentFrameID = FrameID;
    obj.currentSubframeID = SubframeID;
    obj.currentNS = 2.*(10.*obj.currentFrameID+obj.currentSubframeID);
    obj.currentLength1 = length1;
    obj.currentLength2 = length2;

    DCI0 = obj.DCI0;
    DCI1 = obj.DCI1;

    % Проверка на ожидание передачи длинного DCI
    if DCI0{obj.currentDCIID0}.type == 1 || DCI1{obj.currentDCIID1}.type == 1
        obj.awaitingForLongDCI = 1;
        if DCI0{obj.currentDCIID0}.type == 1
            obj.whereIsLongDCI = 0;
        else
            obj.whereIsLongDCI = 1;
        end
    end


    % Обработка NCCE (большое)
    if obj.ended_DCI0 == 1 && obj.ended_DCI1 == 1 && obj.awaitingForLongDCI == 1
        if obj.whereIsLongDCI == 0
            data = NBIoTRateMatcher().rate_match(DCI0{obj.currentDCIID0}.bits, (length1+length2)*2);
            if obj.currentMrep0 < DCI0{obj.currentDCIID0}.Mrep
                obj.currentMrep0 = obj.currentMrep0+1;
            else
                obj.currentMrep0 = 1;
                obj.currentDCIID0 = nextIndex(obj.currentDCIID0, length(DCI0));
                obj.awaitingForLongDCI = 0;

            end
        else
            data = NBIoTRateMatcher().rate_match(DCI1{obj.currentDCIID1}.bits, (length1+length2)*2);
            if obj.currentMrep1 < DCI1{obj.currentDCIID1}.Mrep
                obj.currentMrep1 = obj.currentMrep1+1;
            else
                obj.currentMrep1 = 1;
                obj.currentDCIID1 = nextIndex(obj.currentDCIID1, length(DCI1));
                obj.awaitingForLongDCI = 0;
            end
        end
    else
        % Обработка 1 NCCE (маленькое)
        if obj.ended_DCI0 == 1 && obj.awaitingForLongDCI == 1
            data0 = zeros(1,length1*2);
        else
            obj.ended_DCI0 = 0;
            data0 = NBIoTRateMatcher().rate_match(DCI0{obj.currentDCIID0}.bits, length1*2);

            if obj.currentMrep0 < DCI0{obj.currentDCIID0}.Mrep
                obj.currentMrep0 = obj.currentMrep0 + 1;
            else
                obj.currentMrep0 = 1;
                obj.ended_DCI0 = 1;
                obj.currentDCIID0 = nextIndex(obj.currentDCIID0, length(DCI0));
            end
        end


        % Обработка 2 NCCE (маленькое)
        if obj.ended_DCI1 == 1&& obj.awaitingForLongDCI == 1
            data1 = zeros(1,length2*2);
        else
            obj.ended_DCI1 = 0;
            data1 = NBIoTRateMatcher().rate_match(DCI1{obj.currentDCIID1}.bits, length2*2);

            if obj.currentMrep1 < DCI1{obj.currentDCIID1}.Mrep
                obj.currentMrep1 = obj.currentMrep1 + 1;
            else
                obj.currentMrep1 = 1;
                obj.ended_DCI1 = 1;
                obj.currentDCIID1 = nextIndex(obj.currentDCIID1, length(DCI1));
            end
        end

        data = [data0 data1];
        


        if obj.untilNextScrambling == 1
            obj.c_init = obj.currentSubframeID*(2^9)+obj.parentGrid.Config.NCellID;
            obj.untilNextScrambling = nextIndex(obj.untilNextScrambling, 4);
            obj.scrambler = NBIoTScrambler(zeros(1,1000),obj.c_init,"NPDCCH");
        end
        
        data = NBIoTQPSK(obj.scrambler.scramble_seqsubstract(data)).modulatedBits;
        obj.untilNextScrambling = nextIndex(obj.untilNextScrambling,4);

    end


end

function result = nextIndex(a,b)
    if a>=b
        result = 1;
    else
        result = a + 1;
    end
end
